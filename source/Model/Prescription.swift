//
//  Prescription.swift
//  rx-helper
//
//  Created by Nick Graeff on 10/8/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import os.log

class Prescription: NSObject, NSCoding {
    
    // MARK: Properties
    var name: String
    var dosage: Int?
    var amount: String?
    var datePrescribed: String?
    var expirationDate: String?
    var photo: UIImage?
    var lastTaken: String?
    var nextTimeToBeTaken: String?
    var key: String?
    var alerts = [Alert]()
    
    struct PropertyKey {
        static let name = "name"
        static let dosage = "dosage"
        static let datePrescribed = "datePrescribed"
        static let expirationDate = "expirationDate"
        static let photo = "photo"
        static let lastTaken = "lastTaken"
        static let nextTimeToBeTaken = "nextTimeToBeTaken"
    }
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("prescriptions")
    
    // MARK: Initialization
    init?(name: String, key: String? = nil, dosage: Int? = nil, datePrescribed: String? = nil, expirationDate: String? = nil, photo: UIImage? = nil, lastTaken: String? = nil, nextTimeToBeTaken: String? = nil) {
        
        // Initialization should fail if there is no name
        if name.isEmpty {
            return nil
        }
        
        // Initialize stored properties
        self.name = name
        self.key = key
        self.dosage = dosage
        self.datePrescribed = datePrescribed
        self.expirationDate = expirationDate
        self.photo = photo
        self.lastTaken = lastTaken
        self.nextTimeToBeTaken = nextTimeToBeTaken
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(datePrescribed, forKey: PropertyKey.datePrescribed)
        aCoder.encode(expirationDate, forKey: PropertyKey.expirationDate)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(lastTaken, forKey: PropertyKey.lastTaken)
        aCoder.encode(nextTimeToBeTaken, forKey: PropertyKey.nextTimeToBeTaken)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Prescription object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        
        let dosage = aDecoder.decodeInteger(forKey: PropertyKey.dosage)
        let datePrescribed = aDecoder.decodeObject(forKey: PropertyKey.datePrescribed) as? String
        let expirationDate = aDecoder.decodeObject(forKey: PropertyKey.expirationDate) as? String
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let lastTaken = aDecoder.decodeObject(forKey: PropertyKey.lastTaken) as? String
        let nextTimeToBeTaken = aDecoder.decodeObject(forKey: PropertyKey.nextTimeToBeTaken) as? String
        
        // Must call designated initializer.
        self.init(name: name, dosage: dosage, datePrescribed: datePrescribed, expirationDate: expirationDate, photo: photo, lastTaken: lastTaken, nextTimeToBeTaken: nextTimeToBeTaken)
        
    }
}
