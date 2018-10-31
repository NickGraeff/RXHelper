//
//  AddUserViewController.swift
//  rx-helper
//
//  Created by Juan Brena on 10/29/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddUserViewController: UIViewController {

    @IBOutlet weak var newUsersName: UITextField!
    @IBAction func addNewUserButton(_ sender: Any) {
        users.append(newUsersName.text!)
        //insert new user beneath getDisplayName()

        let ref = Database.database().reference()
        ref.child("users/\(getUserDisplayName())/members/\(newUsersName.text!)/prescriptions/name").setValue("blank")

        self.performSegue(withIdentifier: "toHome", sender: nil)
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
