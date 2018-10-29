//
//  RxMedDetailsViewController.swift
//  rx-helper
//
//  Created by Work-Account on 10/28/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit

class RxMedDetailsViewController: UIViewController {

    @IBOutlet weak var lbl01: UILabel!
    
    var name = ""
    var name2 = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if name != "" {
            lbl01.text = "\(name)"
        }
        else{
            lbl01.text = name2
        }
        
        
        //lbl01.text = "\(name)"
        //lbl01.text = name2
        
        //print(name)
        //print(name2)
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
