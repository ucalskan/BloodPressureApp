//
//  HistoryViewController.swift
//  BloodPressureApp
//
//  Created by Utku Çalışkan on 27.12.2022.
//

import UIKit
import Firebase
import FirebaseAuth


class HistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var currentUserLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var pulseArray = [Int]()
    var systoleArray = [Int]()
    var diastoleArray = [Int]()
    var dateArray = [String]()
    var profileArray = [String]()
    var usernameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        DispatchQueue.global().async {
            self.getDataBase()
        }
        tableView.dataSource = self
        tableView.delegate = self
        
        
        //making tableview look good
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
       // currentUserLabel.text! = (Auth.auth().currentUser?.email!)!
        currentUserLabel.backgroundColor = UIColor(red: 110/255, green: 34/255, blue: 110/255, alpha: 0.8)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diastoleArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as! HistoryCell
        
        if systoleArray.count != 0  {
            cell.systoleLabel.text = String(systoleArray[indexPath.row])
            cell.diastoleLabel.text = String(diastoleArray[indexPath.row])
            cell.pulseLabel.text = String(pulseArray[indexPath.row])
            cell.dateLabel.text = dateArray[indexPath.row]
            
        }
        
        else {
            cell.systoleLabel.text = ""
            cell.diastoleLabel.text = ""
            cell.pulseLabel.text = ""
            cell.dateLabel.text = ""
        }
        
        
        
        
        // making cell look good
        cell.historyView.layer.cornerRadius = cell.historyView.frame.height / 2
        cell.historyView.backgroundColor = UIColor(red: 110/255, green: 34/255, blue: 110/255, alpha: 0.5)
        return cell
    }
    
    func getDataBase(){
        
        let db = Firestore.firestore()
        db.collection("Pulse").order(by: "systemdates",descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                self.makeAlert(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "Error")
            }
            else{
                if snapshot?.isEmpty != true{
                    for doc in snapshot!.documents {
                        if let addedBy = doc.get("addedBy") as? String{
                            self.profileArray.append(addedBy)
                            if Auth.auth().currentUser?.email == addedBy{
                                if let systole = doc.get("systole") as? Int {
                                    self.systoleArray.append(systole)
                                    if let diastole = doc.get("diastole") as? Int {
                                        self.diastoleArray.append(diastole)
                                        if let pulse = doc.get("pulse") as? Int{
                                            self.pulseArray.append(pulse)
                                            if let dates = doc.get("dates") as? String{
                                                self.dateArray.append(dates)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        self.tableView.reloadData()
                            }
                        }  
            }
        }
        
        db.collection("Profile").addSnapshotListener { snapshot2, error in
            if error != nil {
                self.makeAlert(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "Error")
            }
            else{
                if snapshot2?.isEmpty != true{
                    for doc in snapshot2!.documents {
                        if let email = doc.get("addedBy") as? String{
                            if email == Auth.auth().currentUser?.email! {
                                if let username = doc.get("username") as? String{
                                    self.currentUserLabel.text! = username
                                }
                            }
                        }
                    }
                }
                
            }
        }
        
    }
    
    func makeAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
   
}
