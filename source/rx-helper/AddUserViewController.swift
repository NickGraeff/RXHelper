//
//  AddUserViewController.swift
//  rx-helper
//
//  Created by Juan Brena on 10/28/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddUserViewController: UIViewController {
    
    var databaseRefer : DatabaseReference!
    var databaseHandle : DatabaseHandle!

    @IBOutlet weak var newUser: UITextField!
    @IBAction func addNewUser(_ sender: Any) {
        databaseRefer = Database.database().reference()
        databaseRefer.child("users").setValue("New User 100")
        //databaseRefer.child("name").childByAutoId().setValue("New User 200")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
