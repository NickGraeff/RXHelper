//
//  StartViewController.swift
//  rx-helper
//
//  Created by Juan Brena on 9/26/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import FirebaseAuth

class StartViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "StartToHome", sender: nil)
        }
    }
    
    
    @IBAction func StartToLoginButton(_ sender: Any) {
    performSegue(withIdentifier: "StartToLogin", sender: self)
        
    }
    
    @IBAction func StartToSignUpButton(_ sender: Any) {
    performSegue(withIdentifier: "StartToSignUp", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
