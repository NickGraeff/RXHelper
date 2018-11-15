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
        
        MainUser.deleteOnlyInstance()

        //Login Button text
        self.loginButton.setTitle("Login", for: UIControl.State.normal)

        //SignUp Button text
        self.signUpButton.setTitle("Sign up", for: UIControl.State.normal)
    }

    override func viewDidAppear(_ animated: Bool) {
        //auto login
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "toWelcome", sender: self)
        }
    }

    @IBOutlet var startView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!

    //If login button is pressed go to Login VC
    @IBAction func loginAction(_ sender: Any) {
        performSegue(withIdentifier: "toLogin", sender: self)
    }

    //IF sign up button is pressed go to SignUp VC
    @IBAction func signUpAction(_ sender: Any) {
        performSegue(withIdentifier: "toSignUp", sender: self)
    }
}
