//
//  WebViewController.swift
//  rx-helper
//
//  Created by Work-Account on 11/5/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    
    var myString = String()
    @IBOutlet var web: WKWebView!
    @IBOutlet weak var backButton: UIButton!
    
    //@IBOutlet weak var backButton: UIButton!
    
    
    //@IBOutlet weak var label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("med segue is:")
            //print(myString)

           // let url = URL(string: "https://www.rxlist.com/\(myString)-drug.htm")
            //let url = URL(string: "https://www.rxlist.com/\(myString)-drug.htm#description")
            let url = URL(string: "https://www.rxlist.com/\(myString)-drug/patient-images-side-effects.htm#whatis")
            let request = URLRequest(url: url!)
            web.load(request)

        
        // Do any additional setup after loading the view.
    }
    
    
 

}
