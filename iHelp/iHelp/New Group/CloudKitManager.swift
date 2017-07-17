//
//  CloudKitManager.swift
//  iHelp
//
//  Created by Tortora Roberto on 17/07/2017.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import UIKit
import CloudKit

class CloudKitManager: NSObject {
    
    
    static func saveReport(toSave: Report) {
        
        let store = CKRecord(recordType: "PhoneBook")
        
        //ADDIVERTITI xD
        store.setObject(txtAccN.text as CKRecordValue?, forKey: "phoAccNumber")
        store.setObject(Name.text as CKRecordValue?, forKey: "phoName")
        store.setObject(PhoneNumber.text as CKRecordValue?, forKey: "phoPhoneNumber")
        
        publicDatabase.save(store) { (saveRecord, error) in
            
            if error != nil {
                
                print("Error saving Data on CloudKit..---->" + (error?.localizedDescription)!)
                
            } else {
                
                print("Data Save it successfully")
                
            }
            
            
        }
        
        self.present(self.alert, animated: true, completion: nil)
        self.txtAccN.text = ""
        self.Name.text = ""
        self.PhoneNumber.text = ""
    }
    
}
