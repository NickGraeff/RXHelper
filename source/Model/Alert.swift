//
//  Alert.swift
//  rx-helper
//
//  Created by Jean-Paul Castro on 11/5/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit

class Alert: NSObject {
    var alertValue: String? = nil
    var hours: Int? = nil
    var minutes: Int? = nil
    var key: String? = nil
    var skipped: Bool = false
    var taken: Bool = false
    
    struct PropertyKey {
        static let alertValue = "alertValue"
        static let key = "key"
    }
}

