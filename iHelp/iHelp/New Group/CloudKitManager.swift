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
    
    static func saveReport(name: String, surname: String, telephone: String, latitudine: Double, longitudine: Double, message: String, velocity: Double, creationDate: String) {
        let database = CKContainer.default().publicCloudDatabase
        
        let clinicalFolder: ClinicalFolder = PersistanceManager.getClinicalFolder()!
        
        let height = clinicalFolder.altezza
        let weight = clinicalFolder.peso
        let sesso = clinicalFolder.sesso
        let wheelchair = clinicalFolder.sediaARotelle
        let fototipo = clinicalFolder.fototipo
        let heartRate = clinicalFolder.ultimoBattito
        let birthday = clinicalFolder.dataDiNascita
        let bloodGroup = clinicalFolder.gruppoSanguigno
        
        let datiUser = PersistanceManager.fetchDataUserProfile()
        //print("\n\nDATI USER \(datiUser)\n\n")
        
        NSLog("\n\n Sto provando a salvare\n\n")
        let store = CKRecord(recordType: "Notifiche")
        //cartella clinica
        store.setObject(bloodGroup as CKRecordValue?, forKey: "bloodGroup")
        store.setObject(birthday as CKRecordValue?, forKey: "birthday")
        store.setObject(height as CKRecordValue?, forKey: "height")
        store.setObject(weight as CKRecordValue?, forKey: "weight")
        store.setObject(sesso as CKRecordValue?, forKey: "sesso")
        store.setObject(heartRate as CKRecordValue?, forKey: "heartRate")
        store.setObject(fototipo as CKRecordValue?, forKey: "fototipo")
        store.setObject(wheelchair as CKRecordValue?, forKey: "wheelchair")
        
        store.setObject(name as CKRecordValue?, forKey: "name")
        store.setObject(surname as CKRecordValue?, forKey: "surname")
        store.setObject(telephone as CKRecordValue?, forKey: "telephone")
        
        //localizzazione
        store.setObject(latitudine as CKRecordValue?, forKey: "latitudine")
        store.setObject(longitudine as CKRecordValue?, forKey: "longitudine")
        store.setObject(velocity as CKRecordValue?, forKey: "velocity")
        
        //store.setObject(creationDate as CKRecordValue?, forKey: "creationDate")
        //store.setObject(audioMessage as CKRecordValue?, forKey: "audioMessage")
        store.setObject(message as CKRecordValue?, forKey: "message")
        
        NSLog("\n\n Sto provando a salvare2\n\n")
        
        database.save(store) { (saveRecord, error) in
            if error != nil {
                print("Error saving Data on CloudKit..---->" + (error?.localizedDescription)!)
            } else {
                print("Data Save it successfully")
            }
        }
    }
    
}
