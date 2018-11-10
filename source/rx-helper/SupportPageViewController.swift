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
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = nameField.text!
            changeRequest?.commitChanges { (error) in
                // ...
            }
        }
        if !emailField.text!.isEmpty {
            Auth.auth().currentUser?.updateEmail(to: emailField.text!) { (error) in
                // ...
            }
            owner?.email = emailField.text!
        }
        if !pharmacyName.text!.isEmpty {
            ref.child("users/\(getUsersUid())/pharmacyName").setValue(pharmacyName.text)
            owner?.pharmacyName = pharmacyName.text
        }
        if !pharmacyPhoneNumber.text!.isEmpty {
            ref.child("users/\(getUsersUid())/pharmacyPhoneNumber").setValue(pharmacyPhoneNumber.text)
            owner?.pharmacyPhoneNumber = pharmacyPhoneNumber.text
        }
    }
    
    @IBAction func deleteMyAccount(_ sender: Any) {
        
        let alert = UIAlertController(title: "Are you sure you want to delete your account?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: deleteAccountHandler))
        
        self.present(alert, animated: true)
    }
    
    func deleteAccountHandler(alert: UIAlertAction) {
        let ref = Database.database().reference()
        let ref2 = ref.child("users/\(getUsersUid())")
        ref2.removeValue() // delete the user's data
        Auth.auth().currentUser!.delete() // delete the user
        
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }

        self.performSegue(withIdentifier: "toVeryFirstPage", sender: nil)
    }

    @IBAction func reportIssue(_ sender: Any) {
        let subject = "RxHelper Issue"
        let body = "Hi, I have an issue"
        let coded = "mailto:rxheler18@gmail.com?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        if let emailURL:NSURL = NSURL(string: coded!)
        {
            if UIApplication.shared.canOpenURL(emailURL as URL)
            {
                UIApplication.shared.open(emailURL as URL, options: [:], completionHandler: { (sucess) in /**/ })
            }
        }
    }

    @IBAction func logoutAction(_ sender: Any) {
        let alert = UIAlertController(title: "Log out of " + getUserDisplayName() + "?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Log out", style: .default, handler: logoutHandler))
        
        self.present(alert, animated: true)
    }
    
    func logoutHandler(alert: UIAlertAction) {
        owner = nil
        selectedUserUid = nil
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameField.setBottomBorder()
        self.emailField.setBottomBorder()
        self.pharmacyName.setBottomBorder()
        self.pharmacyPhoneNumber.setBottomBorder()

        self.nameField.text = owner!.name
        self.emailField.text = owner!.email
        self.pharmacyName.text = owner!.pharmacyName
        self.pharmacyPhoneNumber.text = owner!.pharmacyPhoneNumber

        self.nameField.delegate = self
        self.emailField.delegate = self
        self.pharmacyName.delegate = self
        self.pharmacyPhoneNumber.delegate = self

        self.hideKeyboardWhenTappedAround()
    }
}

extension SupportPageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        switch textField {
        case nameField:
            emailField.becomeFirstResponder()
        case emailField:
            pharmacyName.becomeFirstResponder()
        case pharmacyName:
            pharmacyPhoneNumber.becomeFirstResponder()
        case pharmacyPhoneNumber:
            pharmacyPhoneNumber.resignFirstResponder()
            saveChanges((Any).self)
        default:
            self.hideKeyboardWhenTappedAround()
        }
        return true
    }
}
