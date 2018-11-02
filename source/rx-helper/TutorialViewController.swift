//
//  TutorialViewController.swift
//  rx-helper
//
//  Created by Nick Graeff on 11/2/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0){
            self.performSegue(withIdentifier: "toWelcome", sender: nil)
        }
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
