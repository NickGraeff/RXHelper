//
//  MenuViewController.swift
//  rx-helper
//
//  Created by Juan Brena on 10/20/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index: Int32)
}

//users list
var members = [member]()

func fetchMembers() {
    Database.database().reference().child("users/\(getUsersUid())/members").observe(.childAdded, with: { (snapshot) in

        if let dictionary = snapshot.value as? [String: AnyObject] {

            let mem = member()
            mem.name = dictionary["name"] as? String
            mem.key = snapshot.key
            members.append(mem)

//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
        }
    }, withCancel: nil)
}

func deleteMember(member: member) {
    let ref = Database.database().reference()
    ref.child("users").child("\(getUsersUid())").child("members").child("\(member.key! as String)").removeValue()
}

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.


    }

    //setting the number of cells in the table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (members.count + 1)
    }

    //setting the text for each cell in the table View
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (indexPath.item < members.count){
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath)
            let member = members[indexPath.row]
            cell.textLabel?.text = member.name

            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath)
            cell.textLabel?.text = "Add user +"

            return cell
        }
    }

    //setting the size of the cells in the table View
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }

    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("You tapped cell number \(indexPath.row).")
        if (indexPath.row == members.count){
            print("To Add User VC")
            self.performSegue(withIdentifier: "toAddUser", sender: nil)
        }
        else{
            print("To Home VC")
            self.performSegue(withIdentifier: "toHome", sender: nil)
        }
    }

    // method to handle row deletion
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if (indexPath.row != members.count) {
            if editingStyle == .delete {

                //remove the item from the data model
                deleteMember(member: members[indexPath.row])

                //remove from members array
                members.remove(at: indexPath.row)

                //delete the table view row
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            else if editingStyle == .insert{
                //Not used in our example, but if you were adding a new row, this is where you would do it
            }
        }
    }

    @IBAction func logoutButton(_ sender: Any) {
        let alert = UIAlertController(title: "Log out of " + getUserDisplayName() + "?", message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Log out", style: .default, handler: logoutHandler))

        self.present(alert, animated: true)
    }

    var btnMenu: UIButton!
    var delegate: SlideMenuDelegate?

    @IBOutlet weak var btnCloseMenuOverlay: UIButton!
    @IBAction func onCloseMenuClick(_ button: UIButton!) {
        btnMenu.tag = 0

        if (self.delegate != nil) {
            var index = Int32((button as AnyObject).tag)
            if(button == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }

        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }

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

    func logoutHandler(alert: UIAlertAction) {
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }
}
