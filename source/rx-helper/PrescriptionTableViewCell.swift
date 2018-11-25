//
//  PrescriptionTableViewCell.swift
//  rx-helper
//
//  Created by Nick Graeff on 10/8/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit

class PrescriptionTableViewCell: UITableViewCell {

    // Mark: Properties
    @IBOutlet weak var prescriptionImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nextDueLabel: UILabel!
    @IBOutlet weak var dosageLabel: UILabel!
    
    
    @IBOutlet weak var cellPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
