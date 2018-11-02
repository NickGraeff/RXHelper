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

class PrescriptionTableViewController: UITableViewController {

    // Mark: Properties
    let cellIdentifier = "PrescriptionTableViewCellIdentifier"
    let cellSpacingHeight: CGFloat = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        self.tableView.separatorStyle = .none
        self.tableView.layer.cornerRadius = 4;

        
        // Load any saved prescriptions, otherwise load sample data.
        loadPrescriptions()
        
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if owner!.key! == selectedUserUid || selectedUserUid == nil {
            return owner!.prescriptions.count
        } else {
            for member in owner!.members {
                if member.key == selectedUserUid {
                    return member.prescriptions.count
                }
            }
        }
        return 0
    }
    
    // Set the spacing between sections
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    // Make the background color show through
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PrescriptionTableViewCell else {
            fatalError("The dequeued cell is not an instance of PrescriptionTableViewCell")
        }
        
        // Fetches the appropriate prescription for the data source layout
        var prescription: Prescription? = nil
        if owner!.key == selectedUserUid || selectedUserUid == nil {
            prescription = owner!.prescriptions[indexPath.row]
        } else {
            for member in owner!.members {
                if member.key == selectedUserUid {
                    prescription = member.prescriptions[indexPath.row]
                    break
                }
            }
        }
        
        
        cell.nameLabel.text = prescription!.name
        cell.prescriptionImageView.image = prescription!.photo
        cell.nextDueLabel.text = prescription!.nextTimeToBeTaken
        
        cell.contentView.backgroundColor = UIColor.clear
        var whiteRoundedView : UIView = UIView(frame: CGRect(x:0, y:10, width:self.view.frame.size.width, height:70))
        whiteRoundedView.layer.backgroundColor = UIColor.lightGray.cgColor
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 3.0
        whiteRoundedView.layer.shadowOpacity = 0.5
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
        
        cell.backgroundColor = UIColor.white
        cell.contentView.layer.cornerRadius = 50
        cell.contentView.clipsToBounds = true
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
            
            if owner!.key == selectedUserUid || selectedUserUid == nil {
                if owner!.prescriptions[indexPath.row].key != nil {
                    deletePrescription(key: owner!.prescriptions[indexPath.row].key!)
                }
                owner!.prescriptions.remove(at: indexPath.row)
            } else {
                for member in owner!.members {
                    if member.key == selectedUserUid {
                        if member.prescriptions[indexPath.row].key != nil {
                            deletePrescription(key: member.prescriptions[indexPath.row].key!)
                        }
                        member.prescriptions.remove(at: indexPath.row)
                        break
                    }
                }
            }
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
                
                var selectedPrescription: Prescription? = nil
                if owner!.key == selectedUserUid || selectedUserUid == nil {
                    selectedPrescription = owner!.prescriptions[indexPath.row]
                } else {
                    for member in owner!.members {
                        if member.key == selectedUserUid {
                            selectedPrescription = member.prescriptions[indexPath.row]
                            break
                        }
                    }
                }
                
                prescriptionDetailViewController.prescription = selectedPrescription!
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "nil")")
        }
     }
    
    // MARK: Actions
    @IBAction func unwindToPrescriptionList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? PrescriptionViewController, let prescription = sourceViewController.prescription {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing prescription
                
                if owner!.key == selectedUserUid || selectedUserUid == nil {
                    owner!.prescriptions[selectedIndexPath.row] = prescription
                } else {
                    for member in owner!.members {
                        if member.key == selectedUserUid {
                            member.prescriptions[selectedIndexPath.row] = prescription
                            break
                        }
                    }
                }
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new prescription
                var newIndexPath: IndexPath? = nil
                if owner!.key == selectedUserUid || selectedUserUid == nil {
                    newIndexPath = IndexPath(row: owner!.prescriptions.count, section: 0)
                    owner!.prescriptions.append(prescription)
                } else {
                    for member in owner!.members {
                        if member.key == selectedUserUid {
                            newIndexPath = IndexPath(row: member.prescriptions.count, section: 0)
                            member.prescriptions.append(prescription)
                            break
                        }
                    }
                }
                tableView.insertRows(at: [newIndexPath!], with: .automatic)
            }
            
            // Save Prescriptions
            savePrescriptions()
        }
    }
    
    // MARK: Private Methods
    private func loadSamplePrescriptions() {
        guard let prescription1 = Prescription(name: "SamplePrescription1") else {
            fatalError("Unable to instantiate prescription1")
        }
        
        guard let prescription2 = Prescription(name: "SamplePrescription2" ) else {
            fatalError("Unable to instantiate prescription2")
        }
        
        guard let prescription3 = Prescription(name: "SamplePrescription3") else {
            fatalError("Unable to instantiate prescription3")
        }
        
        if owner!.key == selectedUserUid || selectedUserUid == nil {
            owner!.prescriptions += [prescription1, prescription2, prescription3]
        } else {
            for member in owner!.members {
                if member.key == selectedUserUid {
                    member.prescriptions += [prescription1, prescription2, prescription3]
                    break
                }
            }
        }
        
    }
    
    private func deletePrescription(key: String) {
        let ref = Database.database().reference()
        var ref2: DatabaseReference
        if selectedUserUid! == owner!.key! {
            ref2 = ref.child("users/\(owner!.key!)/prescriptions/\(key)")
        } else {
            ref2 = ref.child("users/\(owner!.key!)/members/\(selectedUserUid!)/prescriptions/\(key)")
        }
        ref2.removeValue()
    }
    
    private func savePrescriptions() {
        /* let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(prescriptions, toFile: Prescription.ArchiveURL.path + getUserDisplayName())
        if isSuccessfulSave {
            os_log("Prescriptions successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save prescriptions...", log: OSLog.default, type: .error)
        } */
        
        savePrescriptionsToFirebase()
    }
    
    private func savePrescriptionsToFirebase() {
        let ref = Database.database().reference()

        if owner!.key == selectedUserUid {
            for prescription in owner!.prescriptions {
                if prescription.key != nil {
                    ref.child("users/\(getUsersUid())/prescriptions/\(prescription.key!)/\(Prescription.PropertyKey.name)").setValue(prescription.name)
                    ref.child("users/\(getUsersUid())/prescriptions/\(prescription.key!)/\(Prescription.PropertyKey.dosage)").setValue(prescription.dosage ?? 0)
                } else {
                    let newRef = ref.child("users/\(getUsersUid())/prescriptions").childByAutoId()
                    newRef.child("\(Prescription.PropertyKey.name)").setValue("\(prescription.name)")
                    newRef.child("\(Prescription.PropertyKey.dosage)").setValue("\(prescription.dosage ?? 0)")
                    prescription.key = newRef.key
                }
            }
        } else {
            var selectedMember: Member? = nil
            for member in owner!.members {
                if member.key == selectedUserUid {
                    selectedMember = member
                    break
                }
            }
            for prescription in selectedMember!.prescriptions {
                if prescription.key != nil {
                    ref.child("users/\(getUsersUid())/members/\(selectedUserUid!)/prescriptions/\(prescription.key!)/\(Prescription.PropertyKey.name)").setValue(prescription.name)
                    ref.child("users/\(getUsersUid())/members/\(selectedUserUid!)/prescriptions/\(prescription.key!)/\(Prescription.PropertyKey.dosage)").setValue(prescription.dosage ?? 0)
                } else {
                    let newRef = ref.child("users/\(getUsersUid())/members/\(selectedUserUid!)/prescriptions").childByAutoId()
                    newRef.child("\(Prescription.PropertyKey.name)").setValue("\(prescription.name)")
                    newRef.child("\(Prescription.PropertyKey.dosage)").setValue("\(prescription.dosage ?? 0)")
                    prescription.key = newRef.key
                }
            }
        }
    }
    
    private func getPrescriptionsFromFirebase() {
        let ref = Database.database().reference()

        

        if owner!.key == selectedUserUid {
            ref.child("users/\(getUsersUid())/prescriptions").observeSingleEvent(of: .value, with: { (snapshot) in
                owner!.prescriptions.removeAll()
                for child in snapshot.children {
                    let prescription = child as! DataSnapshot
                    if let dict = prescription.value as? [String: Any] {
                        let name = dict[Prescription.PropertyKey.name] as! String
                        let dosage = dict[Prescription.PropertyKey.dosage] as? Int
                        owner!.prescriptions.append(Prescription(name: name, key: prescription.key, dosage: dosage)!)
                    }
                }
                if owner!.prescriptions.isEmpty {
                    self.loadSamplePrescriptions()
                }
                
                self.tableView.reloadData()
            })
        } else {
            var selectedMember: Member? = nil
            for member in owner!.members {
                if selectedUserUid == member.key {
                    selectedMember = member
                    break
                }
            }
            selectedMember!.prescriptions.removeAll()
            ref.child("users/\(getUsersUid())/members/\(selectedUserUid)/prescriptions").observeSingleEvent(of: .value, with: { (snapshot) in
                
                for child in snapshot.children {
                    let prescription = child as! DataSnapshot
                    if let dict = prescription.value as? [String: Any] {
                        let name = dict[Prescription.PropertyKey.name] as! String
                        let dosage = dict[Prescription.PropertyKey.dosage] as? Int
                        selectedMember!.prescriptions.append(Prescription(name: name, key: prescription.key, dosage: dosage)!)
                    }
                }
                if selectedMember!.prescriptions.isEmpty {
                    self.loadSamplePrescriptions()
                }
                
                self.tableView.reloadData()
            })
        }

       
    }
    
    private func loadPrescriptions() {
        
        // Try loading prescriptions locally, else try firebase
        /* return */ /* NSKeyedUnarchiver.unarchiveObject(withFile: Prescription.ArchiveURL.path + getUserDisplayName()) as? [Prescription] ?? */ getPrescriptionsFromFirebase()
        
    }

}
