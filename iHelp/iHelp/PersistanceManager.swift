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
    static let reportHistoryEntity = "ReportsHistory"
    static let userProfileEntity = "UserProfile"
    
    static func getContext() -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
    
    static func setEmptyProfile() {
        let context = getContext()
        PersistanceManager.removeUserProfile()
        let userProfile = NSEntityDescription.insertNewObject(forEntityName: userProfileEntity, into: context) as! UserProfile
        userProfile.isSet = false
        userProfile.address = "address"
        userProfile.name = "name"
        userProfile.surname = "surname"
        userProfile.userPhoto = UIImageJPEGRepresentation(#imageLiteral(resourceName: "empty_avatar.jpg"), 80)! as NSData
        NSLog(userProfile.description)
        NSLog("Save EMPTY User")
    }
    
    static func setUserProfile(name: String, surname: String, address: String, image: UIImage ) {
        let context = getContext()
        PersistanceManager.removeUserProfile()
        let userProfile = NSEntityDescription.insertNewObject(forEntityName: userProfileEntity, into: context) as! UserProfile
        userProfile.isSet = true
        userProfile.address = address
        userProfile.name = name
        userProfile.surname = surname
        userProfile.userPhoto = UIImageJPEGRepresentation(image, 80)! as NSData
        NSLog("Save new User")
    }
    
    static func removeUserProfile() {
        let users = PersistanceManager.fetchDataUserProfile()
        let context = getContext()
        for user in users {
            context.delete(user)
        }
        NSLog("Removed User")

    }
    
    static func fetchDataUserProfile() -> [UserProfile] {
        var users = [UserProfile]()
        
        let context = getContext()
        
        let fetchRequest = NSFetchRequest<UserProfile>(entityName: userProfileEntity)
        
        do {
            try users = context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Error in \(error.code)")
        }
        NSLog("Fetched data User")

        return users
    }
    
    
    
    static func newReportHistory(toAdd: Report) {
        let context = getContext()
        
        let report = NSEntityDescription.insertNewObject(forEntityName: reportHistoryEntity, into: context) as! ReportsHistory
        report.contactIdentifier = toAdd.phoneNumber
        report.creationDate = toAdd.date as NSDate
        report.message = toAdd.message
        report.isMine = toAdd.isMine
        report.name = toAdd.name
     
    }
    
    static func removeReportHistory(toRemove: Report) {
        let context = getContext()
        let datas: [ReportsHistory] = fetchDataReportHistory()
        for data in datas {
            if (data.contactIdentifier == toRemove.phoneNumber) {
                context.delete(data)
            }
        }
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
            NSLog("Error in \(error.code)")
        }
    }
    
    static func resetCoreData(_ navigationController: UINavigationController?) {
        let reportFR = NSFetchRequest<NSFetchRequestResult>(entityName: reportHistoryEntity)
        let emergencyContactFR = NSFetchRequest<NSFetchRequestResult>(entityName: emergencyContactEntity)
        let userProfileFR = NSFetchRequest<NSFetchRequestResult>(entityName: userProfileEntity)
        let deleteRequestRFR = NSBatchDeleteRequest(fetchRequest: reportFR)
        let deleteRequestECFR = NSBatchDeleteRequest(fetchRequest: emergencyContactFR)
        let deleteRequestUPFR = NSBatchDeleteRequest(fetchRequest: userProfileFR)
        
        // get reference to the persistent container
        let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        
        // perform the delete
        do {
            if !PersistanceManager.fetchDataReportHistory().isEmpty {
                NSLog("Clearing report data")
                try persistentContainer.viewContext.execute(deleteRequestRFR)
            }
            if !PersistanceManager.fetchDataEmergencyContact().isEmpty {
                NSLog("Clearing emergency contacts data")
                try persistentContainer.viewContext.execute(deleteRequestECFR)
            }
            if !PersistanceManager.fetchDataUserProfile().isEmpty {
                NSLog("Clearing user data")
                try persistentContainer.viewContext.execute(deleteRequestUPFR)
            }
            self.saveContext()
            
            if let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeView") {
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        } catch let error as NSError {
            print(error)
        }

    }
}
