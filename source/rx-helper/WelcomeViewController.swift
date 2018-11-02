//
//  WelcomeViewController.swift
//  rx-helper
//
//  Created by Juan Brena on 10/10/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

//owner!
var owner: Owner?


//selected user uid
var selectedUserUid: String?

func fetchMembers() {
    owner!.members.removeAll()
    Database.database().reference().child("users/\(getUsersUid())/members").observeSingleEvent(of: .value, with: { (snapshot) in
        
        for child in snapshot.children {
            
            let mem = child as! DataSnapshot
            if let dict = mem.value as? [String: Any] {
                let memexample = Member()
                memexample.name = dict["name"] as? String
                memexample.key = mem.key
                owner!.members.append(memexample)
            }
        }
    })
}


func fetchOwner() {
    Database.database().reference().child("users/\(getUsersUid())").observeSingleEvent(of: .value, with: { (snapshot) in
        
        if let dictionary = snapshot.value as? [String: AnyObject] {
            owner!.key = getUsersUid()
            owner!.name = dictionary["name"] as? String
            selectedUserUid = owner!.key
        }
    })
}

class WelcomeViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        welcomeLabel.text = "Welcome " + getUserDisplayName()
        owner = Owner()
        fetchOwner()
        fetchMembers()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.performSegue(withIdentifier: "toHome", sender: self)
        }
    }
    
}
