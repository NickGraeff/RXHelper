//
//  MainUser.swift
//  rx-helper
//
//  Created by Nick Graeff on 11/12/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import Foundation

class MainUser {
    
    // Instance variables
    var email: String = ""
    var pharmacyName: String = ""
    var pharmacyPhoneNumber: String = ""
    var primaryUser: Member
    var currentUser: Member
    var members: [Member] = [Member]()
    
    // Default constructor, not allowed to be accessed outside of the class
    // Singleton classes should only ever be instantiated once, which is what this is
    private init() {
        self.members.append(Member())
        self.primaryUser = self.members[0]
        self.currentUser = self.primaryUser
    }
    
    // Static variables and getInstance() function for Singleton class
    private static var mainUserInstance: MainUser? = nil
    
    static func getInstance() -> MainUser {
        if mainUserInstance == nil {
            mainUserInstance = MainUser()
        }
        return mainUserInstance!
    }
    
    // Call this only when the user is logged out and you do not intend
    // to use any of the logging out user's information
    static func deleteOnlyInstance() {
        mainUserInstance = nil
    }
}

