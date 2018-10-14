//
//  LoginViewController.swift
//  rx-helper
//
//  Created by Juan Brena on 10/13/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet var loginView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Login View
        self.loginView.layer.borderWidth = 9
        self.loginView.layer.cornerRadius = 35
        self.loginView.clipsToBounds = true
        self.loginView.layer.borderColor = UIColor(red:0.35, green:0.60, blue:0.83, alpha:1.0).cgColor
        self.loginView.backgroundColor = UIColor(red:0.87, green:0.92, blue:0.97, alpha:1.0)
        
        //email textfield
        self.email.layer.borderWidth = 1
        self.email.layer.cornerRadius = 5
        self.email.layer.borderColor = UIColor(red:0.35, green:0.60, blue:0.83, alpha:1.0).cgColor
        
        //password textfield
        self.password.layer.borderWidth = 1
        self.password.layer.cornerRadius = 5
        self.password.layer.borderColor = UIColor(red:0.35, green:0.60, blue:0.83, alpha:1.0).cgColor
    }
    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "toStart", sender: self)
    }

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func loginAction(_ sender: Any) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!)
        { (user, error) in
            if error == nil {
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
