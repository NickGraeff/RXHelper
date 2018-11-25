//
//  PrescriptionViewController.swift
//  rx-helper
//
//  Created by Nick Graeff on 10/11/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import UserNotifications
import os.log
import SwiftyJSON
import FirebaseDatabase

class PrescriptionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {



    // Mark: Properties
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var dosageField: UITextField!
    @IBOutlet weak var remainingDosageField: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var alertTable: UITableView!
    @IBOutlet weak var webInfo: UIButton!

    let searchController = UISearchController(searchResultsController: nil)
    let rxlist = try! JSON(data: NSData(contentsOfFile: Bundle.main.path(forResource: "rxListMed", ofType: "json")!)! as Data)
    var filteredRxList = [JSON]()

    var searching = false

    var prescription: Prescription?
    var tempAlerts: [Alert]?

    override func viewDidLoad() {

        super.viewDidLoad()
        tempAlerts = [Alert]()

        self.nameField.setBottomBorder()
        self.dosageField.setBottomBorder()
        self.remainingDosageField.setBottomBorder()

        if let prescription = prescription {
            navigationItem.title = prescription.name
            nameField.text = prescription.name
            if prescription.dosage != nil {
                dosageField.text = String(prescription.dosage!)
            } else {
                dosageField.text = ""
            }
            
            if prescription.remainingDoses != nil {
                remainingDosageField.text = String(prescription.remainingDoses!)
            } else {
                remainingDosageField.text = ""
            }
            //etcetcetc (name, image, etc)

        } else {
            prescription = Prescription()
        }

        if prescription?.name == nil {
            webInfo.isHidden = true
        }


        nameField.delegate = self
        dosageField.delegate = self
        remainingDosageField.delegate = self

        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true

        alertTable.delegate = self
        alertTable.dataSource = self

        // Manage tableView visibility via TouchDown in textField
        nameField.addTarget(self, action: #selector(textFieldActive), for: UIControl.Event.touchDown)
        nameField.addTarget(self, action: #selector(textFieldDidChange(_:)), for:UIControl.Event.editingChanged)

        nameField.setBottomBorder()
        dosageField.setBottomBorder()
        //self.hideKeyboardWhenTappedAround()
    }

    // If user changes text, hide the tableView
    @IBAction func textFieldChanged(_ sender: AnyObject) {
        tableView.isHidden = true
    }


    @IBAction func schedule(_ sender: Any) {
        let date = timePicker.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hours = components.hour!
        let minutes = components.minute!

        // Makes time variable equivalent to time chosen from clock
        let time = "\(hours):\(minutes)"

        // Takes time in HH:MM format
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "HH:mm"

        // Converts it to HH:MM AM/PM format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"

        // Does conversion
        let formattedTime: Date? = dateFormatterGet.date(from: time)
        dateFormatter.string(from:formattedTime!)

        // Stores hours and minutes into array/table
        let alert = Alert()
        alert.alertValue = dateFormatter.string(from:formattedTime!)
        alert.hours = hours
        alert.minutes = minutes
        tempAlerts!.append(alert)

        let indexPath = IndexPath(row: prescription!.alerts.count + tempAlerts!.count - 1, section: 0)

        alertTable.beginUpdates()
        alertTable.insertRows(at: [indexPath], with: .automatic)
        alertTable.endUpdates()

        alertTable.reloadData()

        // Store time into database
        //timePicker.
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
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        switch textField {
        case nameField:
            dosageField.becomeFirstResponder()
        case dosageField:
            remainingDosageField.becomeFirstResponder()
        case remainingDosageField:
            remainingDosageField.resignFirstResponder()
        default:
            self.hideKeyboardWhenTappedAround()
        }
        return true
    }


    //TABLE STUFF

    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == alertTable {
            return prescription!.alerts.count + tempAlerts!.count
        }

        else if tableView == tableView {
            if searching{//searchController.isActive && searchController.searchBar.text != ""{
                return filteredRxList.count
            }
            return rxlist.count
        }

        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == alertTable {
            var alertTime: Alert
            if indexPath.row < prescription!.alerts.count {
                alertTime = prescription!.alerts[indexPath.row]
            } else {
                alertTime = tempAlerts![indexPath.row - prescription!.alerts.count]
            }

            let cell = UITableViewCell()
            cell.textLabel?.text = alertTime.alertValue
            cell.textLabel?.textAlignment = .center
            cell.backgroundColor = UIColor.clear
            return cell
        }

        else if tableView == tableView {
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
        return UITableViewCell()
    }
    
    func deleteAlert(key: String?) {
        if key != nil && prescription!.key != nil {
            
            let owner = MainUser.getInstance()
            
            let ref = Database.database().reference()
            var ref2: DatabaseReference
            
            ref2 = ref.child("users/\(owner.primaryUser.key)/members/\(owner.currentUser.key)/prescriptions/\(prescription!.key!)/alerts/\(key!)")
            
            ref2.removeValue()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            if indexPath.row < prescription!.alerts.count {
                deleteAlert(key: prescription!.alerts[indexPath.row].key)
                prescription!.alerts.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                tempAlerts?.remove(at: indexPath.row - prescription!.alerts.count)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == alertTable {

        }

        else if tableView == tableView {
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


                //let svc = segue.destination as? UINavigationController
                //let WebController: WebViewController = svc?.topViewController as! WebViewController
                let WebController = segue.destination as! WebViewController
                WebController.myString = prescription!.name!
            }
        }

        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }

        prescription!.name = nameField.text!
        prescription!.dosage = dosageField.text!
        prescription!.remainingDoses = Int(remainingDosageField.text!)
        prescription!.alerts += tempAlerts!

        self.tableView.reloadData()
    }

}
