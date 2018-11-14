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
        //insert new user beneath getDisplayName()
        //make sure new users name is not empty
        if newUsersName.text?.isEmpty == true {
            let alertController = UIAlertController(title: "Name is empty", message: "Please type in a valid name", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        //else add new member to firebase
        else {
            
            let owner = MainUser.getInstance()
            
            var ref: DatabaseReference!
            ref = Database.database().reference()

            let newref = ref.child("users").child(owner.primaryUser.key).child("members").childByAutoId()
            newref.child("name").setValue("\(newUsersName.text!)")
            newref.child("key").setValue(newref.key!)
            let memExample = Member()
            memExample.name = newUsersName.text!
            memExample.key = newref.key!
            owner.members.append(memExample)
            //members.setValue("\(newUsersName.text!)")

        }

        self.performSegue(withIdentifier: "toHome", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.newUsersName.setBottomBorder()

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
