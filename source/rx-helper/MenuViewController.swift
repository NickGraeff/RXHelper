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

func deleteMember(member: Member) {
    let ref = Database.database().reference()
    ref.child("users").child("\(getUsersUid())").child("members").child("\(member.key! as String)").removeValue()
}

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //setting the number of cells in the table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (owner!.members.count + 2)
    }

    //setting the text for each cell in the table View
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.item == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath)
            //let member = owner!
            //cell.textLabel?.text = member.name
            cell.textLabel?.text = owner!.name
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17.0)
            return cell
        }
        else if (indexPath.item < owner!.members.count + 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath)
            let member = owner!.members[indexPath.row - 1]
            cell.textLabel?.text = member.name
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17.0)

            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath)
            cell.textLabel?.text = "Add User +"
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 13.5)
            cell.textLabel?.textColor = UIColor(red:0.36, green:0.60, blue:0.81, alpha:1.0)

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
        if (indexPath.row == owner!.members.count+1){
            print("To Add User VC")
            self.performSegue(withIdentifier: "toAddUser", sender: nil)
        }
        else{
            print("To Home VC")
            if (indexPath.row == 0) {
                selectedUserUid = owner!.key!
            } else {
                selectedUserUid = owner!.members[indexPath.row-1].key!
            }
            print("Selected User UID: \(selectedUserUid ?? "")")
            self.performSegue(withIdentifier: "toHomeFromMenu", sender: nil)
        }
    }

    // method to handle row deletion
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if (indexPath.row != owner!.members.count+1) {
            if editingStyle == .delete {

                //remove the item from the data model
                deleteMember(member: owner!.members[indexPath.row-1])

                
                if selectedUserUid == owner!.members[indexPath.row-1].key {
                    selectedUserUid = owner!.key
                }
                
                //remove from members array
                owner!.members.remove(at: indexPath.row-1)
                

                //delete the table view row
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            }
            else if editingStyle == .insert{
                //Not used in our example, but if you were adding a new row, this is where you would do it
            }
        }
    }

    // method to disable cell editing for "Add user" row
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        if (indexPath.row == owner!.members.count+1 || indexPath.row == 0){
            return false
        }
        else {
            return true
        }
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


}
