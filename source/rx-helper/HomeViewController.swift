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

class HomeViewController: BaseViewController {

    @IBOutlet weak var HomeNavBar: UINavigationItem!

    @IBAction func addButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toMedChoice", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        addSlideMenuButton()
        self.HomeNavBar.title = getUserDisplayName()
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
