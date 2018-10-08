//
//  LoginViewController.swift
//  rx-helper
//
//  Created by Juan Brena on 10/6/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
         performSegue(withIdentifier: "toHome", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButton(_ sender: UIButton) {
        
        //Get the default auth UI object
        let authUI = FUIAuth.defaultAuthUI()
        
        guard authUI != nil else {
            //Log error
            return
        }
        
        //Set ourselves as the delegate
        authUI?.delegate = self
        
        //Get a reference to the auth UI view controller
        let authViewController = authUI!.authViewController()
        
        
        //Show it
        present(authViewController, animated:true, completion: nil)
        
    }
    
}

extension LoginViewController: FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        if error != nil {
            //Log error
            return
        }

        //get uid
        //authDataResult?.user.uid


        performSegue(withIdentifier: "toHome", sender: self)
    }
}




















