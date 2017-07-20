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
    
	static func saveReport(latitudine: Double, longitudine: Double, velocity: Double, audioMessage: URL, message: String, heartRate: Double) {
        let database = CKContainer.default().publicCloudDatabase
        
        print("--------------- \(latitudine)")
        print("--------------- \(longitudine)")
        
        let clinicalFolder: ClinicalFolder = PersistanceManager.getClinicalFolder()!
        
        let height = clinicalFolder.altezza
        let weight = clinicalFolder.peso
        let sesso = clinicalFolder.sesso
        let wheelchair = clinicalFolder.sediaARotelle
        let fototipo = clinicalFolder.fototipo
        let birthday = clinicalFolder.dataDiNascita
        let bloodGroup = clinicalFolder.gruppoSanguigno
        
        let name = PersistanceManager.fetchDataUserProfile()[0].name!
        let surname = PersistanceManager.fetchDataUserProfile()[0].surname!
        let telephone = PersistanceManager.fetchDataUserProfile()[0].address!
        
        //data from vocal registration

		let fileManager = FileManager.default
		
		let dirPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
		
		let soundFileURL = dirPaths[0].appendingPathComponent("recordedAudio.caf")
		print(soundFileURL)
		let audioMessage = dirPaths[0].absoluteString + "recordedAudio.caf"
/*
		NSLog("\(audioMessage)", 0)
		let message : String = SOSViewController().getRecognizedText()
		NSLog("Messaggio preso da SOSViewController ---> \(message)", 0)
*/
		
        // DATA
        let date = NSDate()
        var calendar = NSCalendar.current
        calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date as Date)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let year = calendar.component(.year, from: date as Date)
        let month = calendar.component(.month, from: date as Date)
        let day = calendar.component(.day, from: date as Date)
        let hour = calendar.component(.hour, from: date as Date)
        let minutes = calendar.component(.minute, from: date as Date)
        let seconds = calendar.component(.second, from: date as Date)
        let creationDate2 = "\(day)\\\(month)\\\(year) \(hour):\(minutes):\(seconds)"
        

        NSLog("\\\\\\\\\\\\\\LATITUDINEEEE \(latitudine)")
        NSLog("\\\\\\\\\\\\\\LONGITUDINE \(longitudine)")
        NSLog("\\\\\\\\\\\\\\VELOCITA \(velocity)")
        
        NSLog("\n\n Sto provando a salvare\n\n")
        for contact in PersistanceManager.fetchDataEmergencyContact() {

        let store = CKRecord(recordType: "Notifiche")
        //cartella clinica
        store.setObject(bloodGroup as CKRecordValue?, forKey: "bloodGroup")
        store.setObject(birthday as CKRecordValue?, forKey: "birthday")
        store.setObject(height as CKRecordValue?, forKey: "height")
        store.setObject(weight as CKRecordValue?, forKey: "weight")
        store.setObject(sesso as CKRecordValue?, forKey: "sesso")
        store.setObject(String(heartRate) as CKRecordValue?, forKey: "heartRate")
		
		NSLog("HeartRate data saved --->\(heartRate)", 0)
		
		store.setObject(fototipo as CKRecordValue?, forKey: "fototipo")
        store.setObject(wheelchair as CKRecordValue?, forKey: "wheelchair")
		
        //dati personali
        store.setObject(name as CKRecordValue?, forKey: "name")
        store.setObject(surname as CKRecordValue?, forKey: "surname")
        store.setObject(telephone as CKRecordValue?, forKey: "telephone")
        
        //localizzazione
        store.setObject(latitudine as CKRecordValue?, forKey: "latitudine")
        store.setObject(longitudine as CKRecordValue?, forKey: "longitudine")
        store.setObject(velocity as CKRecordValue?, forKey: "velocity")
        
        //store.setObject(creationDate2 as CKRecordValue?, forKey: "creationDate")
		
		var tmpAudio = CKAsset(fileURL: soundFileURL)
		//----DA VERIFICARE IL FUNZIONAMENTO DEL CAST DA URL A STRING----
        store.setObject(tmpAudio as CKRecordValue?, forKey: "audioMessage")
        store.setObject(message as CKRecordValue?, forKey: "message")
		NSLog("Messaggio Salvato su iCloud----> \(message)", 0)
        
        NSLog("\n\n Sto provando a salvare2\n\n")
            var topicToSend = contact.number!.replacingOccurrences(of: " ", with: "")
            topicToSend = NotificationManager.checkNumber(toCheck: topicToSend)
            store.setObject(topicToSend as CKRecordValue?, forKey: "topic_id")
            
            database.save(store) { (saveRecord, error) in
                if error != nil {
                    print("Error saving Data on CloudKit..---->" + (error?.localizedDescription)!)
                } else {
                    print("Data Save it successfully")
                    NotificationManager.sendNotification(topic: topicToSend, message: message, title: "\(name) \(surname) : SOS Request")
                }
            }
        }
    }
}
