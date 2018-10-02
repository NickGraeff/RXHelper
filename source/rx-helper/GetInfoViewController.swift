//
//  GetInfoViewController.swift
//  rx-helper
//
//  Created by Juan Brena on 10/1/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class GetInfoViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    
    @IBAction func EnterAction(_ sender: Any) {
        let user = Auth.auth().currentUser
//        if let user = user {
//
//        }
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
