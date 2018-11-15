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

    if (Auth.auth().currentUser != nil ) {
        return (Auth.auth().currentUser?.uid)!
    }
    else {
        return "Error: no user logged in"
    }
}

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var HomeNavBar: UINavigationItem!
    
    var referenceToTableViewController: PrescriptionTableViewController?
    
    var reloadTableViewController = false
    
    @IBAction func allTabPressed(_ sender: Any) {
        referenceToTableViewController?.kindOfTableSelected = PrescriptionTableViewController.allSelected
        referenceToTableViewController?.tableView.reloadData()
    }
    @IBAction func upcomingTabPressed(_ sender: Any) {
        referenceToTableViewController?.kindOfTableSelected = PrescriptionTableViewController.upcomingSelected
        referenceToTableViewController?.tableView.reloadData()
    }
    @IBAction func takenTodayPressed(_ sender: Any) {
        referenceToTableViewController?.kindOfTableSelected = PrescriptionTableViewController.takenTodaySelected
        referenceToTableViewController?.tableView.reloadData()
    }
    @IBAction func missedPressed(_ sender: Any) {
        referenceToTableViewController?.kindOfTableSelected = PrescriptionTableViewController.missedSelected
        referenceToTableViewController?.tableView.reloadData()
    }
    
    
    @IBOutlet weak var tabToolbar: UIToolbar!

    @IBAction func addButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toNewPrescription", sender: nil)
    }
    
    @IBOutlet weak var tapToAddMed: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (didAllow, error) in})
        // Do any additional setup after loading the view

        addSlideMenuButton()
        let owner = MainUser.getInstance()
        self.HomeNavBar.title = owner.currentUser.name
        
        if self.HomeNavBar.title == nil {
            self.HomeNavBar.title = owner.currentUser.name
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "EmbeddedTableView" {
            if let tableViewReference = segue.destination as? PrescriptionTableViewController {
                tableViewReference.tapToAddMedFromSegueThing = self.tapToAddMed
                referenceToTableViewController = tableViewReference
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
