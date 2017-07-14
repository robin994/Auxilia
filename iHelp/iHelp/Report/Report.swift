//
//  Report.swift
//  iHelp
//
//  Created by Tortora Roberto on 11/07/2017.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import UIKit
import Contacts

class Report: NSObject {
    var name: String
    var date: Date
    var isMine: Bool
    var contact: CNContact
    var message: String
    
    init(name: String, isMine: Bool, contact: CNContact, message: String) {
        self.name = name
        date = Date()
        self.isMine = isMine
        self.contact = contact
        self.message = message
    }
}
