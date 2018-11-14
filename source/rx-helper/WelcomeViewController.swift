//
//  WelcomeViewController.swift
//  rx-helper
//
//  Created by Juan Brena on 10/10/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

func fetchMainUsersInfo() {
    
    let owner = MainUser.getInstance()
    
    owner.email = Auth.auth().currentUser?.email ?? "No Email provided"
    Database.database().reference().child("users/\(getUsersUid())").observeSingleEvent(of: .value, with: { (snapshot1) in
        
        for temp1 in snapshot1.children {
            if let snapshot2 = temp1 as? DataSnapshot {
                for child in snapshot2.children {
                    if let memberSnap = child as? DataSnapshot {
                        if let dictionary1 = memberSnap.value as? [String: AnyObject] {
                            if dictionary1["key"] as! String == getUsersUid() {
                                owner.primaryUser.name = dictionary1["name"] as! String
                                owner.primaryUser.key = dictionary1["key"] as! String
                            } else {
                                let member = Member()
                                member.name = dictionary1["name"] as! String
                                member.key = dictionary1["key"] as! String
                                owner.members.append(member)
                            }
                        }
                    }
                }
            }
        }
        
        if let dictionary2 = snapshot1.value as? [String: AnyObject] {
            
            owner.pharmacyName = dictionary2["pharmacyName"] as! String
            owner.pharmacyPhoneNumber = dictionary2["pharmacyPhoneNumber"] as! String
        }
    })
}

class WelcomeViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Pull owners information from database
        fetchMainUsersInfo()

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
