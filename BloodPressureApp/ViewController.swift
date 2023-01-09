//
//  ViewController.swift
//  BloodPressureApp
//
//  Created by Utku Çalışkan on 25.12.2022.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage


class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }
    

    @IBAction func loginClicked(_ sender: Any) {
            
        if emailTextField.text == "" && passwordTextField.text == "" && usernameTextField.text == ""{
            MakeAlert(titleInput: "ERROR", messageInput: "Email/TextField?")
        }
        else{
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){(authdata,error) in
                if error != nil{
                    self.MakeAlert(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "Error")
                }
                else{
                    self.performSegue(withIdentifier: "goHomePage", sender: nil)
                }
            }
        }
    }
    
    @IBAction func signupClicked(_ sender: Any) {
        if emailTextField.text == "" && passwordTextField.text == "" {
            MakeAlert(titleInput: "ERROR", messageInput: "Şifre veya email adresi giriniz.")
        }
    
        else{
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!){(authdata,error) in
                if error != nil{
                    self.MakeAlert(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "Error")
                }
                else{
                    self.performSegue(withIdentifier: "goHomePage", sender: nil)
                }
                let db = Firestore.firestore()
                
                var FirestoreReferance : DocumentReference? = nil
                let fireStorePost = ["addedBy" : self.emailTextField.text!, "username" : self.usernameTextField.text!] as? [String : Any]
                FirestoreReferance = db.collection("Profile").addDocument(data: fireStorePost!, completion: { error in
                    if error != nil {
                        self.MakeAlert(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "Error")
                    }
                })
            }
        }
        
        
    }
    
    
    func MakeAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
   
    
    
}
