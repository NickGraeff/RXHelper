//
//  StartViewController.swift
//  rx-helper
//
//  Created by Juan Brena on 10/3/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBAction func LoginButton(_ sender: Any) {
        self.performSegue(withIdentifier: "StartToLogin", sender: self)
    }

    @IBAction func SignUpButton(_ sender: Any) {
        self.performSegue(withIdentifier: "StartToSignUp", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
