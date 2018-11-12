//
//  StartViewController.swift
//  rx-helper
//
//  Created by Juan Brena on 10/13/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseAuth

//owner!
var owner: Owner?

//selected user uid
var selectedUserUid: String?

func fetchMembers() {
    owner!.members.removeAll()
    Database.database().reference().child("users/\(getUsersUid())/members").observeSingleEvent(of: .value, with: { (snapshot) in

        for child in snapshot.children {

            let mem = child as! DataSnapshot
            if let dict = mem.value as? [String: Any] {
                let memexample = Member()
                memexample.name = dict["name"] as? String
                memexample.key = mem.key
                owner!.members.append(memexample)
            }
        }
    })
}


func fetchOwner() {
    Database.database().reference().child("users/\(getUsersUid())").observeSingleEvent(of: .value, with: { (snapshot) in

        if let dictionary = snapshot.value as? [String: AnyObject] {
            owner!.key = getUsersUid()
            owner!.name = dictionary["name"] as? String
            owner!.email = Auth.auth().currentUser?.email
            owner!.pharmacyName = dictionary["pharmacyName"] as? String
            owner!.pharmacyPhoneNumber = dictionary["pharmacyPhoneNumber"] as? String
            selectedUserUid = owner!.key
        }
    })
}

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //Create owner
        owner = Owner()
        //Pull owners information from database
        fetchOwner()
        //Pull owners members from database
        fetchMembers()

        //If a user is still logged in go straight to Home View Controller
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil{

                //This pause if put to let fetchOwner() and fetchMembers() finish loading
                //and not cause a nil unwrapped
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    self.performSegue(withIdentifier: "toHome", sender: self)
                }
            }
        }

        //Login Button text
        self.loginButton.setTitle("Login", for: UIControl.State.normal)

        //SignUp Button text
        self.signUpButton.setTitle("Sign up", for: UIControl.State.normal)
    }

    @IBOutlet var startView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!

    //If login button is pressed go to Login VC
    @IBAction func loginAction(_ sender: Any) {
        performSegue(withIdentifier: "toLogin", sender: self)
    }

    //IF sign up button is pressed go to SignUp VC
    @IBAction func signUpAction(_ sender: Any) {
        performSegue(withIdentifier: "toSignUp", sender: self)
    }
}
