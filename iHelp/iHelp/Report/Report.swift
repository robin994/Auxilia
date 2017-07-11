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
    var isMine: Bool
    
    init(name: String, isMine: Bool) {
        self.name = name
        date = Date()
        reportKey = UUID().uuidString
        self.isMine = isMine
    }
}
