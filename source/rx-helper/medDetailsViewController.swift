//
//  medDetailsViewController.swift
//  rx-helper
//
//  Created by Work-Account on 10/14/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit

class medDetailsViewController: UIViewController {

    @IBOutlet weak var lbl: UILabel!
    var name = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl.text = "\(name) "
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
