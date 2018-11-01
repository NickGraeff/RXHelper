//
//  SupportPageViewController.swift
//  rx-helper
//
//  Created by Nick Graeff on 11/1/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SupportPageViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pharmacyName: UITextField!
    @IBOutlet weak var pharmacyPhoneNumber: UITextField!
    
    @IBAction func saveChanges(_ sender: Any) {
        
        let ref = Database.database().reference()
        
        // TODO: There is literally no verification here, it just does it, fix plz
        if !nameField.text!.isEmpty {
            ref.child("users/\(getUsersUid())/name").setValue(nameField.text)
            owner!.name = nameField.text!
        }
        if !emailField.text!.isEmpty {
            Auth.auth().currentUser!.updateEmail(to: emailField.text!)
        }
        if !pharmacyName.text!.isEmpty {
            ref.child("users/\(getUsersUid())/pharmacyName").setValue(pharmacyName.text)
        }
        if !pharmacyPhoneNumber.text!.isEmpty {
            ref.child("users/\(getUsersUid())/pharmacyPhoneNumber").setValue(pharmacyPhoneNumber.text)
        }
    }
    
    @IBAction func deleteMyAccount(_ sender: Any) {
        print("literally anything")
        let ref = Database.database().reference()
        let ref2 = ref.child("users/\(getUsersUid())")
        ref2.removeValue() // delete the user's data
        print(getUsersUid() + " has been deleted")
        Auth.auth().currentUser!.delete() // delete the user
        self.performSegue(withIdentifier: "toVeryFirstPage", sender: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        nameField.text = owner!.name
        emailField.text = owner!.email
        pharmacyName.text = owner!.pharmacyName
        pharmacyPhoneNumber.text = owner!.pharmacyPhoneNumber
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
