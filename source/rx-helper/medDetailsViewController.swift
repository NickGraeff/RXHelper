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
    
    
    //@IBOutlet weak var lbl2: UILabel!
    
    var name = ""
    var name2 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl.text = "\(name)"
        lbl.text = "\(name2)"
        
        //print(name)
        print(name2)
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
