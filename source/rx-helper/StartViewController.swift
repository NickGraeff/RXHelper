//
//  StartViewController.swift
//  rx-helper
//
//  Created by Juan Brena on 10/13/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseAuth

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //If a user is still logged in go straight to Home View Controller
//        Auth.auth().addStateDidChangeListener { auth, user in
//            if user != nil{
//                self.performSegue(withIdentifier: "toHome", sender: nil)
//            }
//        }
        //Login Button text
        self.loginButton.setTitle("Login", for: UIControl.State.normal)

        //SignUp Button text
        self.signUpButton.setTitle("Sign up", for: UIControl.State.normal)
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
