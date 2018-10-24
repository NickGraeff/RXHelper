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

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let users = ["Juan Brena","Nick Graeff","Ajanae Williams","Alexis Acosta","Jean-Paul Castro","Eduardo Meza","Blossom Hamika"]


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(users.count)
        return (users.count + 1)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        //cell.textLabel?.text = "hello"
        if (indexPath.item < users.count){
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath)
                cell.textLabel?.text = users[indexPath.row]

            let imageName = UIImage(named: users[indexPath.row])
            cell.imageView?.image = imageName

            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath)
            cell.textLabel?.text = "Add user +"
            
            let imageName = UIImage(named: "Add user +++")
            cell.imageView?.image = imageName
            
            return cell
        }
    }
    

    @IBAction func logoutButton(_ sender: Any) {
        let baseVC = BaseViewController()
        let alert = UIAlertController(title: "Log out of " + baseVC.getUserDisplayName() + "?", message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Log out", style: .default, handler: logoutHandler))

        self.present(alert, animated: true)
    }
    var btnMenu: UIButton!
    var delegate: SlideMenuDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }

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
    
    func createUserToFirebase(name: String){
        let ref = Database.database().reference()
        ref.child("\name")
    }

}
