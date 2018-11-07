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
    
    //@IBOutlet weak var hours: UITextField!
    //@IBOutlet weak var minutes: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().delegate = self
        //hours.delegate = self as? UITextFieldDelegate
        //minutes.delegate = self as? UITextFieldDelegate
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Dismiss keyboard when you tap outside the number pad
        //hours.resignFirstResponder()
        //minutes.resignFirstResponder()
    }
    
    @IBAction func schedule(_ sender: Any) {
        setAlarm()
        
        //timePicker.
    }
    
    func makeAlarmCategories() {
        let takeAction = UNNotificationAction(identifier: "takeAction", title: "Take", options: [])
        let snoozeAction = UNNotificationAction(identifier: "snoozeAction", title: "Snooze", options: [])
        let category = UNNotificationCategory(identifier: "RxHelperCategory",
                                              actions: [takeAction,snoozeAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    func setAlarm () {
        makeAlarmCategories()
        
        let content = UNMutableNotificationContent()
        content.title = "Rx Helper"
        content.body = "Time to take your medicine!"
        content.sound = UNNotificationSound.default
        badge += 1
        content.badge = badge as NSNumber
        content.categoryIdentifier = "RxHelperCategory"
        
        
        // Actual alarm setter
        let date = timePicker.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hours = components.hour!
        let minutes = components.minute!
        var dateComponents = DateComponents()
        dateComponents.hour = hours
        dateComponents.minute = minutes
         
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func pressedSnooze () {
        makeAlarmCategories()
        
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
        UNUserNotificationCenter.current().add(request)
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
