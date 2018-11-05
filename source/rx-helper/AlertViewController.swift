//
//  AlertViewController.swift
//  rx-helper
//
//  Created by Jean-Paul Castro on 11/4/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import UserNotifications

//var alert: Alert?

var badge = 0
class AlertViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
    }
    
    @IBAction func schedule(_ sender: Any) {
        setAlarm()
    }
    
    func setAlarm () {
        let center = UNUserNotificationCenter.current()
        
        let takeAction = UNNotificationAction(identifier: "takeAction", title: "Take", options: [])
        let snoozeAction = UNNotificationAction(identifier: "snoozeAction", title: "Snooze", options: [])
        let category = UNNotificationCategory(identifier: "RxHelperCategory",
                                              actions: [takeAction,snoozeAction], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
        
        let content = UNMutableNotificationContent()
        content.title = "Rx Helper"
        content.body = "Time to take your medicine!"
        content.sound = UNNotificationSound.default
        badge += 1
        content.badge = badge as NSNumber
        content.categoryIdentifier = "RxHelperCategory"
        
        /*
         var dateComponents = DateComponents()
         dateComponents.hour = 10
         dateComponents.minute = 03
         
         let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
         */
        
        // Switch 5 to 900 to snooze
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func pressedSnooze () {
        let center = UNUserNotificationCenter.current()
        
        let takeAction = UNNotificationAction(identifier: "takeAction", title: "Take", options: [])
        let snoozeAction = UNNotificationAction(identifier: "snoozeAction", title: "Snooze", options: [])
        let category = UNNotificationCategory(identifier: "RxHelperCategory",
                                              actions: [takeAction,snoozeAction], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
        
        let content = UNMutableNotificationContent()
        content.title = "Rx Helper"
        content.body = "Time to take your medicine!"
        content.sound = UNNotificationSound.default
        badge += 1
        content.badge = badge as NSNumber
        content.categoryIdentifier = "RxHelperCategory"
        
        // Snoozes for 15 minutes, switch 5 to 900
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "takeAction" {
            print ("Take medicine")
            // Subtract from quantity of medicine
            // Perform check for refill
        }
        else if response.actionIdentifier == "snoozeAction" {
            pressedSnooze()
        }
        
        completionHandler()
    }

}
