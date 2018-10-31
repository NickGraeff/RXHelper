//
//  WelcomeViewController.swift
//  rx-helper
//
//  Created by Juan Brena on 10/10/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import FirebaseAuth

func getUserDisplayName() -> String {
    let user = Auth.auth().currentUser
    if user != nil {
        if user?.displayName != nil {
            return (user?.displayName!)!
        }
        else{
            return("")
        }
    }
    return ("Error: no user logged in")
}

//get users
func getUsersUid() -> String {

    if (Auth.auth().currentUser != nil ){
        print("users id: " + (Auth.auth().currentUser?.uid)!)
        return (Auth.auth().currentUser?.uid)!
    }
    else {
        return "Error: no user logged in"
    }
}

var prescriptionCount = 0

var memberCount = 0

class WelcomeViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        welcomeLabel.text = "Welcome " + getUserDisplayName()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
            self.performSegue(withIdentifier: "toHome", sender: self)
        }
    }
    


}
