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
    var surname: String
    var creationDate: String
    var deliveryDate: Date
    var isMine: Bool
    var phoneNumber: String
    var message: String
    var clinicalFolder: ClinicalFolder
    init(name: String,surname: String, isMine: Bool, phoneNumber: String, message: String, creationDate: String, clinicalFolder: ClinicalFolder) {
        self.name = name
        self.surname = surname
        self.creationDate = creationDate
        deliveryDate = Date()
        self.isMine = isMine
        self.phoneNumber = phoneNumber
        self.message = message
        self.clinicalFolder = clinicalFolder
    }
}
