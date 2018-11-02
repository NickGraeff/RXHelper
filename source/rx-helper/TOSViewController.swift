//
//  TOSViewController.swift
//  rx-helper
//
//  Created by Nick Graeff on 11/2/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class TOSViewController: UIViewController {

    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickedDeclineButton(_ sender: Any) {
        // Delete this mf's account and go back to the first screen
        let alert = UIAlertController(title: "If you decline you account will be deleted.", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: deleteAccountHandler))
        
        self.present(alert, animated: true)
    }
    
    func deleteAccountHandler(alert: UIAlertAction) {
        let ref = Database.database().reference()
        let ref2 = ref.child("users/\(getUsersUid())")
        ref2.removeValue() // delete the user's data
        Auth.auth().currentUser!.delete() // delete the user
        
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        self.performSegue(withIdentifier: "toVeryFirstPage", sender: nil)
    }
    
    @IBAction func clickedAcceptButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toTutorial", sender: nil)
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
