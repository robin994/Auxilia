//
//  CloudKitManager.swift
//  iHelp
//
//  Created by Tortora Roberto on 17/07/2017.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import UIKit
import CloudKit
import Foundation

class CloudKitManager: NSObject {
    
    var alert: UIAlertController!
    let database = CKContainer.default().publicCloudDatabase
    
    func saveReport(name: String, surname: String, birthday: String, height: String, weight: String, telephone: String, sesso: String, bloodGroup: String, contactIdentifier: String, heartRate: String, fototipo: String, latitudine: Double, longitudine: Double, message: String, velocity: Double, wheelchair: String, creationDate: Date, audioMessage: CKAsset) {
        
        let store = CKRecord(recordType: "Notifiche")
        store.setObject(name as CKRecordValue?, forKey: "name")
        store.setObject(surname as CKRecordValue?, forKey: "surname")
        store.setObject(birthday as CKRecordValue?, forKey: "birthday")
        store.setObject(height as CKRecordValue?, forKey: "height")
        store.setObject(weight as CKRecordValue?, forKey: "weight")
        store.setObject(telephone as CKRecordValue?, forKey: "telephone")
        store.setObject(sesso as CKRecordValue?, forKey: "sesso")
        store.setObject(bloodGroup as CKRecordValue?, forKey: "bloodGroup")
        store.setObject(contactIdentifier as CKRecordValue?, forKey: "contactIdentifier")
        store.setObject(heartRate as CKRecordValue?, forKey: "heartRate")
        store.setObject(fototipo as CKRecordValue?, forKey: "fototipo")
        store.setObject(latitudine as CKRecordValue?, forKey: "latitudine")
        store.setObject(longitudine as CKRecordValue?, forKey: "longitudine")
        store.setObject(message as CKRecordValue?, forKey: "message")
        store.setObject(velocity as CKRecordValue?, forKey: "velocity")
        store.setObject(wheelchair as CKRecordValue?, forKey: "wheelchair")
        store.setObject(creationDate as CKRecordValue?, forKey: "creationDate")
        store.setObject(audioMessage as CKRecordValue?, forKey: "audioMessage")
        
        database.save(store) { (saveRecord, error) in
            if error != nil {
                print("Error saving Data on CloudKit..---->" + (error?.localizedDescription)!)
            } else {
                print("Data Save it successfully")
            }
        }
    }
    
}
