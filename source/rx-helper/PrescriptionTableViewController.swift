//
//  PrescriptionTableViewController.swift
//  rx-helper
//
//  Created by Nick Graeff on 10/8/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit

class PrescriptionTableViewController: UITableViewController {

    // MARK: Properties
    var prescriptions = [Prescription]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load the sample data
        loadSamplePrescriptions()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prescriptions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier
        let cellIdentifier = "PrescriptionTableViewCell"
        
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
}
