//
//  LoginViewController.swift
//  rx-helper
//
//  Created by Juan Brena on 10/13/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet var loginView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //email textfield
        self.email.setBottomBorder()
        self.password.setBottomBorder()
        //password textfield

        self.hideKeyboardWhenTappedAround()

        self.email.delegate = self
        self.password.delegate = self
    }
    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "toStart", sender: self)
    }

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func forgotPassword(_ sender: Any) {
    }
    @IBAction func loginAction(_ sender: Any) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!)
        { (user, error) in
            if error == nil {
                self.performSegue(withIdentifier: "toWelcome", sender: self)
            }
            else {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case email:
            password.becomeFirstResponder()
        case password:
            password.resignFirstResponder()
            loginAction((Any).self)
        default:
            self.hideKeyboardWhenTappedAround()
        }

        return true
    }
}

extension UITextField {
    func setBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(origin: CGPoint(x: 0, y:self.frame.height - 1), size: CGSize(width: self.frame.width, height:  1))
        bottomLine.backgroundColor = UIColor.gray.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
}
