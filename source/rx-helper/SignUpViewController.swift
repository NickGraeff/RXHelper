//
//  SignUpViewController.swift
//  rx-helper
//
//  Created by Juan Brena on 10/13/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    @IBOutlet var signUpView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()

        self.email.setBottomBorder()
        self.name.setBottomBorder()
        self.pharmacy.setBottomBorder()
        self.pharmacyPhoneNumber.setBottomBorder()
        self.password.setBottomBorder()
        self.passwordConfirm.setBottomBorder()

        self.email.delegate = self
        self.name.delegate = self
        self.pharmacy.delegate = self
        self.pharmacyPhoneNumber.delegate = self
        self.password.delegate = self
        self.passwordConfirm.delegate = self
    }

    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toStart", sender: self)
    }

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    @IBOutlet weak var pharmacy: UITextField!
    @IBOutlet weak var pharmacyPhoneNumber: UITextField!
    
    @IBAction func signUpAction(_ sender: Any) {

        if email.text?.isEmpty == true {
            let alertController = UIAlertController(title: "Email is empty", message: "Please type a valid email", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }

        else if name.text?.isEmpty == true {
            let alertController = UIAlertController(title: "Name is empty", message: "Please type in a name", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }

        else if password.text?.isEmpty == true {
            let alertController = UIAlertController(title: "Password is empty", message: "Please type in a password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }

        else if password.text != passwordConfirm.text {
            let alertController = UIAlertController(title: "Passwords do not match", message: "Please re-type password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, error) in

                if error == nil {
                    //creation of account successful
                    //insert user to firebase
                    var ref: DatabaseReference!
                    ref = Database.database().reference()

                    let info = ["name": "\(self.name.text!)", "pharmacyName":"\(self.pharmacy.text!)","pharmacyPhoneNumber":"\(self.pharmacyPhoneNumber.text!)"]

                    ref.child("users").child(getUsersUid()).setValue(info)
                    //insert name of user
                    let user = Auth.auth().currentUser
                    if let user = user {
                        let changeRequest = user.createProfileChangeRequest()

                        changeRequest.displayName = self.name.text!
                        changeRequest.commitChanges { error in
                            if let error = error {
                                //error
                                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                alertController.addAction(defaultAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                            else {
                                //change request works
                                self.performSegue(withIdentifier: "toTOS", sender: self)
                            }
                        }
                    }
                }
                else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =     UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case email:
            name.becomeFirstResponder()
        case name:
            pharmacy.becomeFirstResponder()
        case pharmacy:
            pharmacyPhoneNumber.becomeFirstResponder()
        case pharmacyPhoneNumber:
            password.becomeFirstResponder()
        case password:
            passwordConfirm.becomeFirstResponder()
        case passwordConfirm:
            passwordConfirm.resignFirstResponder()
            signUpAction((Any).self)
        default:
            self.hideKeyboardWhenTappedAround()
        }

        return true
    }
}
