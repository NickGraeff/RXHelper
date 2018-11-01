//
//  WelcomeViewController.swift
//  rx-helper
//
//  Created by Juan Brena on 10/10/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import FirebaseAuth

class WelcomeViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        welcomeLabel.text = "Welcome " + getUserDisplayName()
        DispatchQueue.main.asyncAfter(deadline: .now() + .5){
            self.performSegue(withIdentifier: "toHome", sender: self)
        }
    }
    
}
