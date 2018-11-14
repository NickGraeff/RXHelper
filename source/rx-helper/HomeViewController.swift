//
//  HomeViewController.swift
//  rx-helper
//
//  Created by Juan Brena on 10/6/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import UserNotifications
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

//get ownsers UID
func getUsersUid() -> String {

    if (Auth.auth().currentUser != nil ){
        return (Auth.auth().currentUser?.uid)!
    }
    else {
        return "Error: no user logged in"
    }
}

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var HomeNavBar: UINavigationItem!
    var reloadTableViewController = false

    @IBAction func addButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toNewPrescription", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (didAllow, error) in})
        // Do any additional setup after loading the view

        addSlideMenuButton()
        let owner = MainUser.getInstance()
        self.HomeNavBar.title = owner.currentUser.name
        
        if self.HomeNavBar.title == nil {
            self.HomeNavBar.title = getUserDisplayName()
        }
        //TO FIX
        //self.navigationController?.navigationBar.prefersLargeTitles = true
        //self.navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    func getSelectedUserName() {
        var sName : String?
        let owner = MainUser.getInstance()
        Database.database().reference().child("users/\(owner.primaryUser.key)/members/\(owner.currentUser.key)").observeSingleEvent(of:.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                sName = dictionary["name"] as? String
                print(sName ?? "error")
                
                self.HomeNavBar.title = sName ?? "error"
            }
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
