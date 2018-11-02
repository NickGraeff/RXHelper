//
//  ReportIssuesViewController.swift
//  
//
//  Created by Nick Graeff on 11/2/18.
//

import UIKit

class ReportIssuesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func reportAnIssue(_ sender: Any) {
        let subject = "RxHelper Issue"
        let body = "Hi, I have an issue. Thanks."
        let coded = "mailto:rxheler18@gmail.com?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let emailURL:NSURL = NSURL(string: coded!)
        {
            if UIApplication.shared.canOpenURL(emailURL as URL)
            {
                UIApplication.shared.open(emailURL as URL, options: [:], completionHandler: { (sucess) in /**/ })
            }
        }
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
