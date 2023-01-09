//
//  UploadViewController.swift
//  BloodPressureApp
//
//  Created by Utku Çalışkan on 25.12.2022.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class UploadViewController: UIViewController {

    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var bigTextField: UITextField!
    @IBOutlet weak var smallTextField: UITextField!
    @IBOutlet weak var pulseTextField: UITextField!
    
   

    let datePicker = UIDatePicker()


    override func viewDidLoad() {
        super.viewDidLoad()
                
       createDatePicker()
            
    }
    


    @IBAction func uploadClicked(_ sender: Any) {
        let db  = Firestore.firestore()
        
        var FireStoreReference : DocumentReference? = nil
        let fireStorePost = ["addedBy" : Auth.auth().currentUser?.email!,"systole" : Int(bigTextField.text!)!, "diastole" : Int(smallTextField.text!)!, "pulse" : Int(pulseTextField.text!)! , "dates" : dateTextField.text! , "systemdates" : FieldValue.serverTimestamp()] as? [String : Any]
        FireStoreReference = db.collection("Pulse").addDocument(data: fireStorePost! , completion: { error in
            if error != nil {
                self.makeAlert(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "Error")
            }
            else {
                self.pulseTextField.text = ""
                self.dateTextField.text = ""
                self.bigTextField.text = ""
                self.smallTextField.text = ""
            }
        })
    }
    
    func makeAlert(titleInput: String , messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    func createDatePicker() {
            
            //DatePicker'da oluşan tarihi textfield'a kaydetmek için kullancağımız butonu koyacağımız barı oluşturuyoruz.
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            
            //Barda bulunacak butonu oluşturduk.
            let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: #selector(doneButtonClicked))
            toolbar.setItems([doneButton], animated: true)
            
            //inputAccessoryView : Text field için sistem tarafından sunulan klavyeye aksesuar görünümü eklemek için kullanıyoruz. Bizde butonumuz için bir toolbar ekliyoruz.
            dateTextField.inputAccessoryView = toolbar
            
            //inputAccessoryView : Text field için sistem tarafından sunulan klavyenin yerini alacak bir görünüm eklemek için kullanıyoruz. Bizde klavye yerine datePicker kullanıyoruz.
            dateTextField.inputView = datePicker
            
            //DatePicker'ımızın modunu belirliyor. Tarih, saat, zamanlayıcı gibi.
            datePicker.datePickerMode =  .date
            
        
        }
    @objc func doneButtonClicked() {
            
            //Yazdıracağımız tarihin formatını belirliyoruz.
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            
            //Text field'a date picker'dan gelen değeri yazdırıyoruz.
            dateTextField.text = formatter.string(from: datePicker.date)
            
            //Done butonuna bastıktan sonra klavyemizin kapanacağını söylüyruz.
            self.view.endEditing(true)
        }
    
   
    @IBAction func backClicked(_ sender: Any) {
        performSegue(withIdentifier: "goBackHome", sender: nil)
        
    }
    
}
