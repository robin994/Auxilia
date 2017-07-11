//
//  Report.swift
//  iHelp
//
//  Created by Tortora Roberto on 11/07/2017.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import UIKit

class Report: NSObject {
    var name: String
    var reportKey: String
    var date: Date
    
    init(name: String) {
        self.name = name
        date = Date()
        reportKey = UUID().uuidString
    }
}
