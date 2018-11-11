//
//  WelcomeViewController.swift
//  rx-helper
//
//  Created by Juan Brena on 10/10/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        //Pull owners information from database
        fetchOwner()
        //Pull owners members from database
        fetchMembers()

        //Color of Welcome text
        welcomeLabel.textColor = UIColor.gray

        //Text for the Welcome text
        welcomeLabel.text = "Welcome " + getUserDisplayName()

        //Show Welcome VC for x seconds then segue to HomeVC
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
            self.performSegue(withIdentifier: "toHome", sender: self)
        }
    }
    
}
