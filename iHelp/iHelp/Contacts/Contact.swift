//
//  Contact.swift
//  iHelp
//
//  Created by Tortora Roberto on 11/07/2017.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import UIKit

class Contact: NSObject {
    var name: String
    var number: String
    var reportKey: String
    
    init(name: String, number: String) {
        self.name = name
        self.number = number
        reportKey = UUID().uuidString
    }
}
