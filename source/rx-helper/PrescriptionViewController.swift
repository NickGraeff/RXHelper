//
//  PrescriptionViewController.swift
//  rx-helper
//
//  Created by Nick Graeff on 10/11/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import os.log
import SwiftyJSON


class PrescriptionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Mark: Properties
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var alarmButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dosageField: UITextField!
    
    
    @IBOutlet weak var webInfo: UIButton!
    
    let searchController = UISearchController(searchResultsController: nil)
    let rxlist = try! JSON(data: NSData(contentsOfFile: Bundle.main.path(forResource: "rxListMed", ofType: "json")!)! as Data)
    var filteredRxList = [JSON]()
    
    var searching = false
    
    
    var prescription: Prescription?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameField.setBottomBorder()
        self.dosageField.setBottomBorder()
        
        if let prescription = prescription {
            navigationItem.title = prescription.name
            nameField.text = prescription.name
            if prescription.dosage != nil {
                dosageField.text = String(prescription.dosage!)
            } else {
                dosageField.text = ""
            }
            //etcetcetc (name, image, etc)
            
        }
        
        /*
        if prescription?.name == nil {
            //medInfoPressed.isHidden = true
            webInfo.isHidden = true
        }
         */
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        nameField.delegate = self
        
        tableView.isHidden = true
        
        // Manage tableView visibility via TouchDown in textField
        nameField.addTarget(self, action: #selector(textFieldActive), for: UIControl.Event.touchDown)
        nameField.addTarget(self, action: #selector(textFieldDidChange(_:)), for:UIControl.Event.editingChanged)
    }
    
    // If user changes text, hide the tableView
    @IBAction func textFieldChanged(_ sender: AnyObject) {
        tableView.isHidden = true
    }
    
    // Manage keyboard and tableView visibility
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch:UITouch = touches.first else
        {
            return;
        }
        if touch.view != tableView
        {
            nameField.endEditing(true)
            tableView.isHidden = true
        }
    }
    
    // Toggle the tableView visibility when click on textField
    @objc func textFieldActive() {
        searching = true
        tableView.isHidden = true
    }
    
    // Toggle the tableView visibility when click on textField
    @objc func textFieldDidChange(_ textField: UITextField) {
        filteredRxList = rxlist.array!.filter({$0["term"].stringValue.prefix(self.nameField.text!.count) == nameField.text!})
        searching = true
        if nameField.text != "" {
            tableView.isHidden = false
        } else {
            tableView.isHidden = true
        }
        //print("searchText \(searchText)")
        tableView.reloadData()
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // TODO: Your app can do something when textField finishes editing
        searching = false
        print("The textField ended editing. Do something based on app requirements.")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching{//searchController.isActive && searchController.searchBar.text != ""{
            return filteredRxList.count
        }
        return rxlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell02")
        
        var data: JSON
        
        if searching && nameField.text! != "" && nameField.text != (self.prescription?.name ?? ""){
            data = filteredRxList[indexPath.row]
            let countryName = data["term"].stringValue
            cell?.textLabel?.text = countryName
            
        } else{
            data = rxlist[indexPath.row]
            let countryName = data["term"].stringValue
            cell?.textLabel?.text = countryName
            tableView.reloadData()
        }
        return cell!
    }
    
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Row selected, so set textField to relevant value, hide tableView
        // endEditing can trigger some other action according to requirements
        if searching {
            nameField.text = filteredRxList[indexPath.row]["term"].stringValue
        } else {
            nameField.text = rxlist[indexPath.row]["term"].stringValue
        }
        tableView.isHidden = true
        nameField.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }

    // Mark: Navigation
    @IBAction func cancel(_ sender: Any) {
        
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddPrescriptionMode = presentingViewController is UINavigationController
        
        if isPresentingInAddPrescriptionMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The PrescriptionViewController is not inside a navigation controller.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let medname = prescription?.name

        if segue.identifier == "segue01"{
            if medname != nil{
            
                
                let svc = segue.destination as? UINavigationController
                let WebController: WebViewController = svc?.topViewController as! WebViewController
                //var WebController = segue.destination as! WebViewController
                WebController.myString = prescription!.name
            }
        }
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        prescription = Prescription(name: nameField.text ?? "Unknown", key: prescription?.key, dosage: Int(dosageField.text ?? "0"))
        
        
    }

}
