//
//  SOS.swift
//  iHelp
//
//  Created by Tortora Roberto on 12/07/2017.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import UIKit

class SOS: NSObject {
    static func callSOS() -> UIAlertController {
        let alert = UIAlertController(title: "SOS", message: "Need help?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        return alert
    }
}
