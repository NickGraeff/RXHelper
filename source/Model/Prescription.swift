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
    
    func getUpcomingAlerts() -> [Alert] {
        let date = NSDate() as Date
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hours = components.hour!
        let minutes = components.minute!
        
        var upcomingAlerts = [Alert]()
        for alert in alerts {
            if alert.hours! > hours && alert.minutes! > minutes {
                upcomingAlerts.append(alert)
            }
        }
        return upcomingAlerts
    }
    
    func getSkippedAlerts() -> [Alert] {
        var skippedAlerts = [Alert]()
        for alert in alerts {
            if alert.skipped {
                skippedAlerts.append(alert)
            }
        }
        return skippedAlerts
    }
    
    func getTakenAlerts() -> [Alert] {
        var takenAlerts = [Alert]()
        for alert in alerts {
            if alert.taken {
                takenAlerts.append(alert)
            }
        }
        return takenAlerts
    }
}

