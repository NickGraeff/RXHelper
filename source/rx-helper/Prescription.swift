//
//  Prescription.swift
//  rx-helper
//
//  Created by Nick Graeff on 10/8/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit

class Prescription {
    
    // MARK: Properties
    var name: String
    var datePrescribed: String?
    var expirationDate: String?
    var photo: UIImage?
    var lastTaken: String?
    var nextTimeToBeTaken: String?
    
    // MARK: Initialization
    init?(name: String, datePrescribed: String? = nil, expirationDate: String? = nil, photo: UIImage? = nil, lastTaken: String? = nil, nextTimeToBeTaken: String? = nil) {
        
        // Initialization should fail if there is no name
        if name.isEmpty {
            return nil
        }
        
        // Initialize stored properties
        self.name = name
        self.datePrescribed = datePrescribed
        self.expirationDate = expirationDate
        self.photo = photo
        self.lastTaken = lastTaken
        self.nextTimeToBeTaken = nextTimeToBeTaken
    }
}
