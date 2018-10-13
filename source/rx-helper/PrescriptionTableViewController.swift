//
//  PrescriptionTableViewController.swift
//  rx-helper
//
//  Created by Nick Graeff on 10/11/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import os.log

class PrescriptionTableViewController: UITableViewController {

    // Mark: Properties
    var prescriptions = [Prescription]()
    let cellIdentifier = "PrescriptionTableViewCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved meals, otherwise load sample data.
        if let savedPrescriptions = loadPrescriptions() {
            prescriptions += savedPrescriptions
        } else {
            // Load the sample data
            loadSamplePrescriptions()
        }
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prescriptions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PrescriptionTableViewCell else {
            fatalError("The dequeued cell is not an instance of PrescriptionTableViewCell")
        }
        
        // Fetches the appropriate prescription for the data source layout
        let prescription = prescriptions[indexPath.row]
        
        cell.nameLabel.text = prescription.name
        cell.prescriptionImageView.image = prescription.photo
        cell.nextDueLabel.text = prescription.nextTimeToBeTaken
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            prescriptions.remove(at: indexPath.row)
            savePrescriptions()
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
                
                let selectedPrescription = prescriptions[indexPath.row]
                prescriptionDetailViewController.prescription = selectedPrescription
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "nil")")
        }
     }
    
    // MARK: Actions
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? PrescriptionViewController, let prescription = sourceViewController.prescription {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing prescription
                prescriptions[selectedIndexPath.row] = prescription
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new prescription
                let newIndexPath = IndexPath(row: prescriptions.count, section: 0)
                prescriptions.append(prescription)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save Prescriptions
            savePrescriptions()
        }
    }
    
    // MARK: Private Methods
    private func loadSamplePrescriptions() {
        guard let prescription1 = Prescription(name: "hello") else {
            fatalError("Unable to instantiate prescription1")
        }
        
        guard let prescription2 = Prescription(name: "brother") else {
            fatalError("Unable to instantiate prescription2")
        }
        
        guard let prescription3 = Prescription(name: "itfitmany") else {
            fatalError("Unable to instantiate prescription3")
        }
        
        self.prescriptions += [prescription1, prescription2, prescription3]
    }
    
    private func savePrescriptions() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(prescriptions, toFile: Prescription.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadPrescriptions() -> [Prescription]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Prescription.ArchiveURL.path) as? [Prescription]
    }

}
