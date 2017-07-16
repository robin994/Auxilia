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
    var phoneNumber: String
    var message: String
    var clinicalFolder: ClinicalFolder
    init(name: String, isMine: Bool, phoneNumber: String, message: String, clinicalFolder: ClinicalFolder) {
        self.name = name
        date = Date()
        self.isMine = isMine
        self.phoneNumber = phoneNumber
        self.message = message
        self.clinicalFolder = clinicalFolder
    }
}
