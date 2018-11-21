//
//  PrescriptionTableViewController.swift
//  rx-helper
//
//  Created by Nick Graeff on 10/11/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import os.log
import FirebaseAuth
import FirebaseDatabase
import UserNotifications

class PrescriptionTableViewController: UITableViewController, UNUserNotificationCenterDelegate {

    // Mark: Properties
    let cellIdentifier = "PrescriptionTableViewCellIdentifier"
    let cellSpacingHeight: CGFloat = 5

    var tapToAddMedFromSegueThing: UILabel?

    static let allSelected = 1
    static let upcomingSelected = 2
    static let takenTodaySelected = 3
    static let missedSelected = 4
    
    var kindOfTableSelected: Int?
    
    
    @objc func setKindOfTable(sender: UIBarButtonItem?) {
        switch sender?.title {
            case "All":
                kindOfTableSelected = PrescriptionTableViewController.allSelected
            case "Upcoming":
                kindOfTableSelected = PrescriptionTableViewController.upcomingSelected
            case "Taken Today":
                kindOfTableSelected = PrescriptionTableViewController.takenTodaySelected
            case "Missed":
                kindOfTableSelected = PrescriptionTableViewController.missedSelected
            default:
                fatalError("Invalid button pressed")
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kindOfTableSelected = PrescriptionTableViewController.allSelected
        
        UNUserNotificationCenter.current().delegate = self
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        //self.tableView.separatorStyle = .none
        self.tableView.layer.cornerRadius = 4;
        self.tableView.reloadData()

        // Load any saved prescriptions, otherwise load sample data.
        loadPrescriptions()

    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let owner = MainUser.getInstance()
        
        if owner.currentUser.prescriptions.count == 0 {
            self.tapToAddMedFromSegueThing?.isHidden = false
            self.tableView.isHidden = true
        } else {
            self.tapToAddMedFromSegueThing?.isHidden = true
            self.tableView.isHidden = false
        }
        
        var count = 0
        switch kindOfTableSelected {
        case PrescriptionTableViewController.allSelected:
            count = owner.currentUser.prescriptions.count
        case PrescriptionTableViewController.upcomingSelected:
            for prescription in owner.currentUser.prescriptions {
                if prescription.getUpcomingAlerts().count > 0 {
                    count += 1
                }
            }
            
        case PrescriptionTableViewController.takenTodaySelected:
            for prescription in owner.currentUser.prescriptions {
                if prescription.getTakenAlerts().count > 0 {
                    count += 1
                }
            }
            
        case PrescriptionTableViewController.missedSelected:
            for prescription in owner.currentUser.prescriptions {
                if prescription.getSkippedAlerts().count > 0 {
                    count += 1
                }
            }
            
        default:
            fatalError("Invalid tab selected")
        }
        
        return count
    }

    // Set the spacing between sections
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }

    // Make the background color show through
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        //headerView.backgroundColor = UIColor.white
        return headerView
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PrescriptionTableViewCell else {
            fatalError("The dequeued cell is not an instance of PrescriptionTableViewCell")
        }

        // Fetches the appropriate prescription for the data source layout
        let owner = MainUser.getInstance()
        
        //let prescription: Prescription = owner.currentUser.prescriptions[indexPath.row]
        var prescriptionToReturn: Prescription? = nil
        var count = 0
        switch kindOfTableSelected {
            
            // All prescriptions
            case PrescriptionTableViewController.allSelected:
                prescriptionToReturn = owner.currentUser.prescriptions[indexPath.row]
            
            // All upcoming prescriptions
            case PrescriptionTableViewController.upcomingSelected:
                for prescription in owner.currentUser.prescriptions {
                    if prescription.getUpcomingAlerts().count > 0 {
                        if count == indexPath.row {
                            prescriptionToReturn = prescription
                        }
                        count += 1
                    }
                }
            
            // All prescriptions taken today
            case PrescriptionTableViewController.takenTodaySelected:
                for prescription in owner.currentUser.prescriptions {
                    if prescription.getTakenAlerts().count > 0 {
                        if count == indexPath.row {
                            prescriptionToReturn = prescription
                        }
                        count += 1
                    }
                }
            
            // All upcoming prescriptions
            case PrescriptionTableViewController.missedSelected:
                for prescription in owner.currentUser.prescriptions {
                    if prescription.getSkippedAlerts().count > 0 {
                        if count == indexPath.row {
                            prescriptionToReturn = prescription
                        }
                        count += 1
                    }
                }
            
            default:
                fatalError("Invalid tab selected")
        }
        
        cell.nameLabel.text = prescriptionToReturn!.name
        //cell.prescriptionImageView.image = prescription!.photo
        
        if prescriptionToReturn!.alerts.count > 0 {
            cell.nextDueLabel.text = prescriptionToReturn!.alerts[0].alertValue
        } else {
            cell.nextDueLabel.text = "Never"
        }

        //TO FIX
        cell.dosageLabel.text = String(prescriptionToReturn!.dosage ?? 0)
//        cell.contentView.backgroundColor = UIColor.clear
//        var whiteRoundedView : UIView = UIView(frame: CGRect(x:0, y:10, width:self.view.frame.size.width, height:70))
//        whiteRoundedView.layer.backgroundColor = UIColor.lightGray.cgColor
//        whiteRoundedView.layer.masksToBounds = false
//        whiteRoundedView.layer.cornerRadius = 3.0
//        //whiteRoundedView.layer.shadowOpacity = 0.5
//        cell.contentView.addSubview(whiteRoundedView)
//        cell.contentView.sendSubviewToBack(whiteRoundedView)

//        cell.backgroundColor = UIColor.white
//        cell.contentView.layer.cornerRadius = 50
//        cell.contentView.clipsToBounds = true
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            let owner = MainUser.getInstance()
            deletePrescription(key: owner.currentUser.prescriptions[indexPath.row].key!)
            owner.currentUser.prescriptions.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            case "AddPrescription":
                os_log("Adding a new prescription.", log: OSLog.default, type: .debug)
            
            case "ShowDetail":
                guard let prescriptionDetailViewController = segue.destination as? PrescriptionViewController else {
                        fatalError("Unexpected destination: \(segue.destination)")
                    }
                
                guard let selectedPrescriptionCell = sender as? PrescriptionTableViewCell else {
                    fatalError("Unexpected sender: \(sender ?? "nil")")
                }
                
                guard let indexPath = tableView.indexPath(for: selectedPrescriptionCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                let owner = MainUser.getInstance()
                prescriptionDetailViewController.prescription = owner.currentUser.prescriptions[indexPath.row]
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "nil")")
        }
     }
    
    // MARK: Actions
    @IBAction func unwindToPrescriptionList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? PrescriptionViewController, let prescription = sourceViewController.prescription {
            let owner = MainUser.getInstance()
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing prescription
                
                owner.currentUser.prescriptions[selectedIndexPath.row] = prescription
                
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new prescription
                let newIndexPath = IndexPath(row:owner.currentUser.prescriptions.count, section:0)
                owner.currentUser.prescriptions.append(prescription)
                
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                tableView.reloadRows(at: [newIndexPath], with: .none)
            }
            
            for alert in prescription.alerts {
                setAlarm(prescription.name!, alert.hours!, alert.minutes!, prescription)
            }
            
            // Save Prescriptions
            savePrescriptions()
        }
    }
    
    func setAlarm (_ name: String, _ hours: Int, _ minutes: Int, _ prescription: Prescription) {
        makeAlarmCategories()
        
        let owner = MainUser.getInstance()
        
        let content = UNMutableNotificationContent()
        content.title = "RxHelper"
        content.body = "Time to take your \(name)!"
        content.sound = UNNotificationSound.default
        owner.badge += 1
        content.badge = owner.badge as NSNumber
        content.categoryIdentifier = "RxHelperCategory"
        content.userInfo = ["Key" : prescription.key!]
        
        // Actual alarm setter
        var dateComponents = DateComponents()
        dateComponents.hour = hours
        dateComponents.minute = minutes
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func makeAlarmCategories() {
        let takeAction = UNNotificationAction(identifier: "takeAction", title: "Take", options: [])
        let snoozeAction = UNNotificationAction(identifier: "snoozeAction", title: "Snooze", options: [])
        let category = UNNotificationCategory(identifier: "RxHelperCategory",
                                              actions: [takeAction,snoozeAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    func pressedSnooze (_ key: String) {
        makeAlarmCategories()
        
        let owner = MainUser.getInstance()
        
        var alarmedPrescription: Prescription? = nil
        
        for member in owner.members {
            for prescription in member.prescriptions {
                if prescription.key == key {
                    alarmedPrescription = prescription
                    break
                }
            }
            if alarmedPrescription != nil {
                break
            }
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Rx Helper"
        content.body = "Time to take your \(alarmedPrescription!.name!)!"
        content.sound = UNNotificationSound.default
        owner.badge += 1
        content.badge = owner.badge as NSNumber
        content.categoryIdentifier = "RxHelperCategory"
        content.userInfo = ["Key" : key]
        
        
        // Snoozes for 15 minutes, switch 5 to 900
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        let key = userInfo["Key"] as! String
        
        var alarmedPrescription: Prescription? = nil
        let owner = MainUser.getInstance()
        
        for member in owner.members {
            for prescription in member.prescriptions {
                if prescription.key == key {
                    alarmedPrescription = prescription
                    break
                }
            }
            if alarmedPrescription != nil {
                break
            }
        }
        
        if response.actionIdentifier == "takeAction" {
            print ("I took \(alarmedPrescription!.name!)")
            // Subtract from quantity of medicine
            // Perform check for refill
        }
        else if response.actionIdentifier == "snoozeAction" {
            print ("I snoozed \(alarmedPrescription!.name!)")
            pressedSnooze(key)
        }
        
        completionHandler()
    }
    
    // MARK: Private Methods
    private func loadSamplePrescriptions() {
        
        // Making new prescriptions
        let prescription1 = Prescription(); prescription1.name = "Sample Prescription 1"; prescription1.dosage = 0;
        let prescription2 = Prescription(); prescription2.name = "Sample Prescription 2"; prescription2.dosage = 0;
        let prescription3 = Prescription(); prescription3.name = "Sample Prescription 3"; prescription3.dosage = 0;
        
        let owner = MainUser.getInstance()
        owner.currentUser.prescriptions += [prescription1, prescription2, prescription3]
        
    }
    
    private func deletePrescription(key: String) {
        let owner = MainUser.getInstance()
        
        let ref = Database.database().reference()
        var ref2: DatabaseReference
        
        ref2 = ref.child("users/\(owner.primaryUser.key)/members/\(owner.currentUser.key)/prescriptions/\(key)")
        
        ref2.removeValue()
    }
    
    private func savePrescriptions() {
        
        savePrescriptionsToFirebase()
    }
    
    private func savePrescriptionsToFirebase() {
        let ref = Database.database().reference()
        let owner = MainUser.getInstance()
        for prescription in owner.currentUser.prescriptions {
            
            var ref2: DatabaseReference
            // If key is nil make a new one, else use the old
            if prescription.key == nil {
                ref2 = ref.child("users/\(owner.primaryUser.key)/members/\(owner.currentUser.key)/prescriptions/").childByAutoId()
                prescription.key = ref2.key
            } else {
                ref2 = ref.child("users/\(owner.primaryUser.key)/members/\(owner.currentUser.key)/prescriptions/\(prescription.key!)")
            }
            
            // Set all values desired
            ref2.child("\(Prescription.PropertyKey.name)").setValue(prescription.name)
            ref2.child("\(Prescription.PropertyKey.dosage)").setValue(prescription.dosage ?? 0)
            
            // Set all alert values
            for alert in prescription.alerts {
                var alertRef: DatabaseReference
                
                // If key is nil make a new one else use the old
                if alert.key == nil {
                    alertRef = ref2.child(Prescription.PropertyKey.alerts).childByAutoId()
                    alert.key = alertRef.key
                } else {
                    alertRef = ref.child("\(Prescription.PropertyKey.alerts)/\(alert.key!)")
                }
                
                // Setting alertValue
                alertRef.child(Alert.PropertyKey.alertValue).setValue(alert.alertValue)
            }
        
        }
        
    }

    private func getPrescriptionsFromFirebase() {
        let ref = Database.database().reference()
        let owner = MainUser.getInstance()
        
        // Reset whatever is in the prescriptions array
        owner.currentUser.prescriptions.removeAll()

        // Send a single request to retrieve information from the db
        ref.child("users/\(owner.primaryUser.key)/members/\(owner.currentUser.key)/prescriptions").observeSingleEvent(of: .value, with: { (snapshot) in

            for prescriptionChild in snapshot.children {
                let prescriptionSnapshot = prescriptionChild as! DataSnapshot
                
                let prescription = Prescription()
                // If this snapshot has values, retrieve them
                if let dict = prescriptionSnapshot.value as? [String: Any] {
                    
                    // Retrieving the values
                    prescription.name = dict[Prescription.PropertyKey.name] as? String
                    prescription.key = prescriptionSnapshot.key
                    prescription.dosage = dict[Prescription.PropertyKey.dosage] as? Int
                    
                    // Retrieving the alerts for this prescription
                    for alertNest in prescriptionSnapshot.children {
                        let alertsSnapshot = alertNest as! DataSnapshot
                        for alertChild in alertsSnapshot.children {
                            let alertSnapshot = alertChild as! DataSnapshot
                            if let dict = alertSnapshot.value as? [String: Any] {
                                let alert = Alert()
                                alert.alertValue = dict[Alert.PropertyKey.alertValue] as? String
                                alert.key = alertSnapshot.key
                                
                                var vectorthing1 = alert.alertValue?.components(separatedBy: ":")
                                var vectorthing2 = vectorthing1![1].components(separatedBy: " ")
                                alert.hours = Int(vectorthing1![0])! - 1 + (vectorthing2[1] == "PM" ? 13 : 0)
                                alert.minutes = Int(vectorthing2[0])
                                prescription.alerts.append(alert)
                            }
                        }
                    }
                    
                    owner.currentUser.prescriptions.append(prescription)
                }
            }
            if owner.currentUser.prescriptions.isEmpty {
                //If owners has no prescriptions then a text view
                //should appear and show a message saying
                //"Tap on + to add a medicine"
                //self.loadSamplePrescriptions()
                self.tableView.isHidden = true

            }

            self.tableView.reloadData()
        })

    }

    private func loadPrescriptions() {

        // Try loading prescriptions with firebase
        getPrescriptionsFromFirebase()

    }
}
