//
//  HomeViewController.swift
//  rx-helper
//
//  Created by Juan Brena on 10/6/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!

    @IBOutlet var homeView: UIView!
    @IBOutlet weak var homeSegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        //Display welcome users.displayName
        welcomeLabel.text = "Welcome " + getUserDisplayName()
        welcomeLabel.isHidden = true;
    }

    @IBAction func scTapped(_ sender: Any) {
    }


    func getUserDisplayName() -> String {
        let user = Auth.auth().currentUser
        if user != nil {
            return (user?.displayName!)!
        }
        return ("Error: No current user logged in")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
