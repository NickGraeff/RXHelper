//
//  SignUpViewController.swift
//  rx-helper
//
//  Created by Juan Brena on 10/13/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    @IBOutlet var signUpView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //signUp View
        self.signUpView.layer.borderWidth = 9
        self.signUpView.layer.cornerRadius = 35
        self.signUpView.clipsToBounds = true
        self.signUpView.layer.borderColor = UIColor(red:0.35, green:0.60, blue:0.83, alpha:1.0).cgColor
        self.signUpView.backgroundColor = UIColor(red:0.87, green:0.92, blue:0.97, alpha:1.0)
        
        //email textfield
        self.email.layer.borderWidth = 1
        self.email.layer.cornerRadius = 5
        self.email.layer.borderColor = UIColor(red:0.35, green:0.60, blue:0.83, alpha:1.0).cgColor
        
        //name textfield
        self.name.layer.borderWidth = 1
        self.name.layer.cornerRadius = 5
        self.name.layer.borderColor = UIColor(red:0.35, green:0.60, blue:0.83, alpha:1.0).cgColor
        
        //password textfield
        self.password.layer.borderWidth = 1
        self.password.layer.cornerRadius = 5
        self.password.layer.borderColor = UIColor(red:0.35, green:0.60, blue:0.83, alpha:1.0).cgColor
        
        //passwordConfirm textfield
        self.passwordConfirm.layer.borderWidth = 1
        self.passwordConfirm.layer.cornerRadius = 5
        self.passwordConfirm.layer.borderColor = UIColor(red:0.35, green:0.60, blue:0.83, alpha:1.0).cgColor
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toStart", sender: self)
    }
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    
    @IBAction func signUpAction(_ sender: Any) {
        
        if password.text?.isEmpty == true {
            let alertController = UIAlertController(title: "Password is empty", message: "Please type in a password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        else if password.text != passwordConfirm.text {
            let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, error) in
                
                if error == nil {
                    //creation of account successful
                    //TO DOinsert name
                    self.performSegue(withIdentifier: "toWelcome", sender: self)
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
