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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        addSlideMenuButton()
        HomeNavBar.title = getUserDisplayName()
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //This function will return the name of the user that is logged in
    //We will need to modify this to change in case the person decides
    //to change profile
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

}
