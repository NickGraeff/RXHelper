//
//  owner.swift
//  rx-helper
//
//  Created by Juan Brena on 10/31/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit

class Owner: NSObject {
    var name: String?
    var email: String? = ""
    var pharmacyName: String? = ""
    var pharmacyPhoneNumber: String? = ""
    var key: String?
    var members = [Member]()
    var prescriptions = [Prescription]()
}
