//
//  HomeViewController.swift
//  BloodPressureApp
//
//  Created by Utku Çalışkan on 25.12.2022.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
   
    @IBOutlet weak var smallLabel: UILabel!
    @IBOutlet weak var pulseLabel: UILabel!
    @IBOutlet weak var diastoleLabel: UILabel!
    @IBOutlet weak var systoleLabel: UILabel!
    @IBOutlet weak var homePageView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var systoleArray = [Int]()
    var diastoleArray = [Int]()
    var pulseArray = [Int]()
    let textArray = ["Yüksek tansiyonu ilaçsız kontrol etmenin 10 yolu","Kan basıncı değerlerini anlama","Hipertansiyonu kontrol etmek için egzersizler","Hipertansiyon ile ilgili acil durumlar için ilk yardım","10 tansiyon efsanesi","Düşük tansiyonla ilgili acil durumlar için ilk yardım"]
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tabBarController?.tabBar.backgroundColor = UIColor(red: 110/255, green: 34/255, blue: 110/255, alpha: 0.8)
        
        
        
        
        
        DispatchQueue.global().async {
            self.getDataBase()
        }
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        homePageView.layer.cornerRadius = homePageView.frame.height / 5
        homePageView.backgroundColor = UIColor(patternImage: UIImage(named: "doctor")!)
        smallLabel.layer.cornerRadius = smallLabel.frame.height / 2
        
        view.backgroundColor = UIColor(red: 110/255, green: 34/255, blue: 110/255, alpha: 0.8)
        
        
    }
    

   
    @IBAction func addClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "goUpload", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeCell
        cell.infoLabel.text = textArray[indexPath.row]
        cell.homeView.layer.cornerRadius = cell.homeView.frame.height / 4
        //cell.homeView.backgroundColor = UIColor(patternImage: UIImage(named: "hap")!)
        cell.homeView.backgroundColor = UIColor(red: 110/255, green: 34/255, blue: 110/255, alpha: 0.5)
        
        
            
        
        return cell
    }
    
    func getDataBase(){
        let db = Firestore.firestore()
        db.collection("Pulse").order(by: "systemdates" ,descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                self.makeAlert(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "Error")
            }
            else{
                if snapshot?.isEmpty != nil {
                    for doc in snapshot!.documents {
                        if let addedBy = doc.get("addedBy") as? String{
                            if Auth.auth().currentUser?.email == addedBy {
                                if let systole = doc.get("systole") as? Int{
                                    self.systoleArray.append(systole)
                                    if let diastole = doc.get("diastole") as? Int{
                                        self.diastoleArray.append(diastole)
                                        if let pulse = doc.get("pulse") as? Int{
                                            self.pulseArray.append(pulse)
                                        }
                                    }
                                }

                            }
                        }
                    }
                }
                
                if self.systoleArray.count != 0 {
                    self.pulseLabel.text = String(self.pulseArray[0])
                    self.diastoleLabel.text = String(self.diastoleArray[0])
                    self.systoleLabel.text = String(self.systoleArray[0])
                    self.tableView.reloadData()
                }
                else{
                    self.pulseLabel.text = ""
                    self.diastoleLabel.text = ""
                    self.systoleLabel.text = ""
                    self.tableView.reloadData()
                }
                
            }
        }
        
    }
    
    func makeAlert(titleInput : String , messageInput : String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    @IBAction func graphicClicked(_ sender: Any) {
        
    }
    @IBAction func statisticsClicked(_ sender: Any) {
        performSegue(withIdentifier: "goStat", sender: nil)
    }
    
    @IBAction func signOutClicked(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }
        catch{
            
        }
        performSegue(withIdentifier: "goSignOut", sender: nil)
    }
}
