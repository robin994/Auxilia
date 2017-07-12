//
//  PersistanceManager.swift
//  iHelp
//
//  Created by Tortora Roberto on 11/07/2017.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import UIKit
import CoreData

class PersistanceManager {
    static let emergencyContactEntity = "EmergencyContact"
    static let reportHistoryEntity = "ReportHistory"
    
    
    static func getContext() -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
    
    static func newReportHistory(toAdd: Report) {
        let context = getContext()
        
        let report = NSEntityDescription.insertNewObject(forEntityName: reportHistoryEntity, into: context) as! ReportsHistory
        report.contactIdentifier = toAdd.contact.identifier
        report.creationDate = toAdd.date as NSDate
        report.message = toAdd.message
        report.isMine = toAdd.isMine
        report.name = toAdd.name
        
    }
    
    static func removeReportHistory(toRemove: Report) -> Bool {
        let context = getContext()
        let datas: [ReportsHistory] = fetchDataReportHistory()
        for data in datas {
            if (data.contactIdentifier == toRemove.contact.identifier) {
                context.delete(data)
                return true
            }
        }
        return false
    }
    
    static func fetchDataReportHistory() -> [ReportsHistory] {
        var reports = [ReportsHistory]()
        
        let context = getContext()
        
        let fetchRequest = NSFetchRequest<ReportsHistory>(entityName: reportHistoryEntity)
        
        do {
            try reports = context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Error in \(error.code)")
        }
        
        return reports
    }

    
    static func newEmergencyContact(toAdd: Contact) {
     
        let context = getContext()
        
        let contact = NSEntityDescription.insertNewObject(forEntityName: emergencyContactEntity, into: context) as! EmergencyContact
        contact.contactIdentifier = toAdd.contactKey
        contact.name = toAdd.name
        contact.number = toAdd.contact.phoneNumbers.first!.value.stringValue
        
    }
    
    static func removeEmergencyContact(toRemove: Contact) {
        let context = getContext()
        let datas: [EmergencyContact] = fetchDataEmergencyContact()
        for data in datas {
            if data.contactIdentifier == toRemove.contact.identifier {
                //NSLog("Cancello: \(data.description)")
                context.delete(data)
            }
        }
    }

    static func fetchDataEmergencyContact() -> [EmergencyContact] {
        var contacts = [EmergencyContact]()
        
        let context = getContext()
        
        let fetchRequest = NSFetchRequest<EmergencyContact>(entityName: emergencyContactEntity)
        
        do {
            try contacts = context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Error in \(error.code)")
        }
        
        return contacts
    } 

    static func saveContext() {
        let context = getContext()
        
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Error in \(error.code)")
        }
    }
    
    static func resetCoreData() {
        let reportFR = NSFetchRequest<NSFetchRequestResult>(entityName: reportHistoryEntity)
        let emergencyContactFR = NSFetchRequest<NSFetchRequestResult>(entityName: emergencyContactEntity)
        let deleteRequestRFR = NSBatchDeleteRequest(fetchRequest: reportFR)
        let deleteRequestECFR = NSBatchDeleteRequest(fetchRequest: emergencyContactFR)
        
        // get reference to the persistent container
        let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        
        // perform the delete
        do {
            try persistentContainer.viewContext.execute(deleteRequestRFR)
            try persistentContainer.viewContext.execute(deleteRequestECFR)
        } catch let error as NSError {
            print(error)
        }

    }
}
