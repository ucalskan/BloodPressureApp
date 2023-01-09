//
//  StatViewController.swift
//  BloodPressureApp
//
//  Created by Utku Çalışkan on 3.01.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage


class StatViewController: UIViewController{
    
    
    
    var systoleArray = [Int]()
    var diastoleArray = [Int]()
    var pulseArray = [Int]()
    
    
    
 
    
    @IBOutlet weak var statView: UIView!
    
    @IBOutlet weak var systoleMaxLabel: UILabel!
    
    @IBOutlet weak var pulseMinLabel: UILabel!
    @IBOutlet weak var pulseMaxLabel: UILabel!
    @IBOutlet weak var systoleMinLabel: UILabel!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var pulseAverLabel: UILabel!
    @IBOutlet weak var diastoleAverLabel: UILabel!
    @IBOutlet weak var diastoleMinLabel: UILabel!
    @IBOutlet weak var diastoleMaxLabel: UILabel!
    @IBOutlet weak var systoleAverLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getDataBase()
        
        
       // navigationBar.barTintColor = .white
        statView.layer.cornerRadius = view.frame.height / 13
        statView.backgroundColor = .white
        view.backgroundColor = UIColor(red: 110/255, green: 34/255, blue: 110/255, alpha: 0.8)
       
    }
    
    
    func getDataBase(){
        let db = Firestore.firestore()
        db.collection("Pulse").addSnapshotListener { snapshot, error in
            if error != nil {
                self.makeAlert(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "ERROR")
            }
            else{
                if snapshot?.isEmpty != true {
                    for doc in snapshot!.documents {
                        if let addedBy = doc.get("addedBy") as? String{
                            if Auth.auth().currentUser?.email == addedBy{
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
                if self.systoleArray.count == 0 {
                    self.makeAlert(titleInput: "ERROR", messageInput: "Henüz ölçümünüz bulunmamaktadır.")
                }
                else{
                    self.systoleMaxLabel.text = String(self.systoleArray.max()!)
                    self.systoleMinLabel.text = String(self.systoleArray.min()!)
                    self.diastoleMaxLabel.text = String(self.diastoleArray.max()!)
                    self.diastoleMinLabel.text = String(self.diastoleArray.min()!)
                    self.pulseMaxLabel.text = String(self.pulseArray.max()!)
                    self.pulseMinLabel.text = String(self.pulseArray.min()!)
                    
                    self.makeCalculated(array: self.systoleArray, label: self.systoleAverLabel)
                    self.makeCalculated(array: self.diastoleArray, label: self.diastoleAverLabel)
                    self.makeCalculated(array: self.pulseArray, label: self.pulseAverLabel)
                    
                }
               
                
            }
        }
    }
    
    func makeCalculated(array: [Int], label: UILabel){
        let  sum = array.reduce(0, +)
        let aver = sum / array.count
        label.text = String(aver)
        
    }
    
    
    func makeAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
   

    @IBAction func backClicked(_ sender: Any) {
        performSegue(withIdentifier: "goStatToHome", sender: nil)
    }
    
}
