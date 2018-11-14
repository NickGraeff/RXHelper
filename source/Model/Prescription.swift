//
//  Prescription.swift
//  rx-helper
//
//  Created by Nick Graeff on 10/8/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import os.log

class Prescription {
    
    // MARK: Properties
    var name: String? = nil
    var dosage: Int? = nil
    var key: String?
    var alerts = [Alert]()
    
    struct PropertyKey {
        static let name = "name"
        static let key = "key"
        static let dosage = "dosage"
        static let alerts = "alerts"
    }
}
