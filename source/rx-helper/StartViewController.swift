//
//  StartViewController.swift
//  rx-helper
//
//  Created by Juan Brena on 10/13/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        Auth.auth().addStateDidChangeListener { auth, user in
//            if user != nil{
//                self.performSegue(withIdentifier: "toHome", sender: nil)
//            }
//        }
        // Do any additional setup after loading the view.
        self.startView.layer.borderWidth = 9
        self.startView.layer.cornerRadius = 35
        self.startView.clipsToBounds = true
        self.startView.layer.borderColor = UIColor(red:0.35, green:0.60, blue:0.83, alpha:1.0).cgColor
        self.startView.backgroundColor = UIColor(red:0.87, green:0.92, blue:0.97, alpha:1.0)

        //Login Button
        self.loginButton.backgroundColor = UIColor(red:0.35, green:0.60, blue:0.83, alpha:1.0)
        self.loginButton.layer.cornerRadius = 5
        self.loginButton.layer.borderWidth = 1
        self.loginButton.setTitle("Log in using an existing account", for: UIControl.State.normal)
        self.loginButton.layer.borderColor = UIColor.black.cgColor

        //SignUp Button
        self.signUpButton.backgroundColor = UIColor(red:0.35, green:0.60, blue:0.83, alpha:1.0)
        self.signUpButton.layer.cornerRadius = 5
        self.signUpButton.layer.borderWidth = 1
        self.signUpButton.setTitle("Create a new Rx Helper account", for: UIControl.State.normal)
        self.signUpButton.layer.borderColor = UIColor.black.cgColor
    }

    @IBOutlet var startView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!

    @IBAction func loginAction(_ sender: Any) {
        performSegue(withIdentifier: "toLogin", sender: self)
    }

    @IBAction func signUpAction(_ sender: Any) {
        performSegue(withIdentifier: "toSignUp", sender: self)
    }
}
