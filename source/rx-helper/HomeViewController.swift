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

//number of prescriptions
var prescriptionCount = 0

//number of members
var memberCount = 0

var fetchMem = 1

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
        if (fetchMem == 1){
            fetchMembers()
            fetchMem = 0
        }
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
