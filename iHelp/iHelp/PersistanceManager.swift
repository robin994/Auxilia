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
    static let topicEntity = "TopicsIscritto"
    static let clinicalFolderEntity = "ClinicalFolderData"
    
    static func getContext() -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    static func setNewTopic(toAdd: String) {
        NSLog("Richiesta inserimento topic nel DB")
        NSLog(toAdd.description)
        let context = getContext()
        if !PersistanceManager.isTopicAlreadyInside(toCheck: toAdd) {
            let topic = NSEntityDescription.insertNewObject(forEntityName: topicEntity, into: context) as! TopicsIscritto
            topic.topic = toAdd
            saveContext()
            NSLog("Topic inserito")
        }
    }
    
    static func isTopicAlreadyInside(toCheck: String) -> Bool {
        let topics = PersistanceManager.fetchRequestTopics()
        for topic in topics {
            if (topic.topic! == toCheck) {
                NSLog("Topic già presente nel DB")
                return true
            }
        }
        return false
    }
    
    static func fetchRequestTopics() -> [TopicsIscritto] {
        var topics = [TopicsIscritto]()
        let context = getContext()
        let fetchRequest = NSFetchRequest<TopicsIscritto>(entityName: topicEntity)
        
        do {
            try topics = context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Error in \(error.code)")
        }
        NSLog("Fetched data topics")
        
        return topics
    }
    
    static func removeTopic(toRemove: String) {
        let topics = PersistanceManager.fetchRequestTopics()
        let context = getContext()
        for topic in topics {
            if (topic.topic == toRemove) {
                context.delete(topic)
                NSLog("Removed topic : \(toRemove)")
                saveContext()
            }
        }
        saveContext()
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
        saveContext()
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
        NotificationManager.subscribe(address)
        saveContext()
        NSLog("Save new User")
    }
    
    static func removeUserProfile() {
        let users = PersistanceManager.fetchDataUserProfile()
        let context = getContext()
        for user in users {
            context.delete(user)
        }
        saveContext()
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
    
    
    static func setClinicalFolder(clinFolder: ClinicalFolder?) {
        let context = getContext()
        if(clinFolder != nil){
            PersistanceManager.removeClinicaFolder()
            let clinicalFolder = NSEntityDescription.insertNewObject(forEntityName: clinicalFolderEntity, into: context) as! ClinicalFolderData
            clinicalFolder.sex = clinFolder?.sesso!
            clinicalFolder.dateB = clinFolder?.dataDiNascita!
            clinicalFolder.height = clinFolder?.altezza!
            clinicalFolder.weight = clinFolder?.peso!
            clinicalFolder.bloodType = clinFolder?.gruppoSanguigno!
            clinicalFolder.skin = clinFolder?.fototipo!
            clinicalFolder.wheelchair = clinFolder?.sediaARotelle!
            clinicalFolder.heartRate = clinFolder?.ultimoBattito!
            saveContext()
        NSLog("Save new Clinical Folder")
        }else{
            NSLog("Not Save new Clinical Folder because object is nil")

        }
    }
    static func getClinicalFolder() -> ClinicalFolder? {
        NSLog(PersistanceManager.fetchDataClinicalFolder().description)
        if let report = PersistanceManager.fetchDataClinicalFolder().first {
            let clin = ClinicalFolder(sesso: report.sex!,
                                      dataDiNascita: report.dateB!,
                                      altezza: report.height!,
                                      peso: report.weight!,
                                      gruppoSanguigno: report.bloodType!,
                                      fototipo: report.skin!,
                                      sediaARotelle: report.wheelchair!,
                                      ultimoBattito: report.heartRate!)
            NSLog("RITORNO CARTELLA")
            return clin

        } else {
            NSLog("RITORNO CARTELLA VUOTA")
            return ClinicalFolder(sesso: "",
                                  dataDiNascita: "",
                                  altezza: "",
                                  peso: "",
                                  gruppoSanguigno: "",
                                  fototipo: "",
                                  sediaARotelle: "",
                                  ultimoBattito: "")
        }
        
    }
    static func removeClinicaFolder() {
        let clinicals = PersistanceManager.fetchDataClinicalFolder()
        let context = getContext()
        for clinical in clinicals {
            context.delete(clinical)
        }
        saveContext()
        NSLog("Removed User")
        
    }
    
    static func fetchDataClinicalFolder() -> [ClinicalFolderData] {
        var clin = [ClinicalFolderData]()
        
        let context = getContext()
        
        let clinicalFolder = NSFetchRequest<ClinicalFolderData>(entityName: clinicalFolderEntity)
        
        do {
            try clin = context.fetch(clinicalFolder)
        } catch let error as NSError {
            print("Error in \(error.code)")
        }
        NSLog("Fetched data User")
        
        return clin
    }

    
    
    static func newReportHistory(toAdd: Report) {
        let context = getContext()
        
        let report = NSEntityDescription.insertNewObject(forEntityName: reportHistoryEntity, into: context) as! ReportsHistory
        report.contactIdentifier = toAdd.phoneNumber
        report.creationDate = toAdd.creationDate
        report.deliveryDate = toAdd.deliveryDate as NSDate
        report.message = toAdd.message
        report.isMine = toAdd.isMine
        report.name = toAdd.name
        report.surname = toAdd.surname
        saveContext()
    }
    
    static func isReportAlreadyInside(toCheck: Report) -> Bool {
        let reports = PersistanceManager.fetchDataReportHistory()
        NSLog("Controllo uguaglianza Reports")
        for report in reports {
            if (report.contactIdentifier! == toCheck.phoneNumber && toCheck.creationDate.description == report.creationDate!.description && toCheck.message == report.message) {
                NSLog("Report già presente nel DB")
                return true
            }
        }
        NSLog("Report NON presente nel DB")
        return false
    }
    
    static func removeReportHistory(toRemove: Report) {
        let context = getContext()
        let datas: [ReportsHistory] = fetchDataReportHistory()
        for data in datas {
            if (data.contactIdentifier! == toRemove.phoneNumber && toRemove.creationDate.description == data.creationDate!.description) {
                NSLog("Report rimosso: \(data.description)")
                context.delete(data)
            }
        }
        saveContext()
    }

    static func clearAllReportHistory() {
        NSLog("------------ REQUEST DELETE REPORTS ---------")

        let context = getContext()
        let datas: [ReportsHistory] = fetchDataReportHistory()
        for data in datas {
            context.delete(data)
        }
        NSLog("DELETED ALL REPORTS HYSTORY")
        saveContext()
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
    
    static func isEmergencyContactAlreadyInside(_ toCheck: Contact) -> Bool {
        let contacts = PersistanceManager.fetchDataEmergencyContact()
        for contact in contacts {
            if (contact.number == contact.number) {
                NSLog("Contatto già presente nel DB")
                return true
            }
        }
        return false
    }

    
    static func newEmergencyContact(toAdd: Contact) {
        if isEmergencyContactAlreadyInside(toAdd) == false {
            let context = getContext()
            let contact = NSEntityDescription.insertNewObject(forEntityName: emergencyContactEntity, into: context) as! EmergencyContact
            contact.contactIdentifier = toAdd.contactKey
            contact.name = toAdd.name
            contact.number = toAdd.contact.phoneNumbers.first!.value.stringValue
            saveContext()
        }
    }
    
    static func removeEmergencyContact(toRemove: Contact) {
        let context = getContext()
        let datas: [EmergencyContact] = fetchDataEmergencyContact()
        for data in datas {
            if data.contactIdentifier == toRemove.contact.identifier {
                NSLog("Cancello: \(data.description)")
                context.delete(data)
            }
        }
        saveContext()
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
        let topicsFR = NSFetchRequest<NSFetchRequestResult>(entityName: topicEntity)
        let deleteRequestRFR = NSBatchDeleteRequest(fetchRequest: reportFR)
        let deleteRequestECFR = NSBatchDeleteRequest(fetchRequest: emergencyContactFR)
        let deleteRequestUPFR = NSBatchDeleteRequest(fetchRequest: userProfileFR)
        let deleteRequestTFR = NSBatchDeleteRequest(fetchRequest: topicsFR)
        // get reference to the persistent container
        let context = self.getContext()
        
        // perform the delete
        do {
            if !PersistanceManager.fetchDataReportHistory().isEmpty {
                NSLog("Clearing report data")
                try context.execute(deleteRequestRFR)
                self.saveContext()
            }
            if !PersistanceManager.fetchDataEmergencyContact().isEmpty {
                NSLog("Clearing emergency contacts data")
                try context.execute(deleteRequestECFR)
                self.saveContext()
            }
            if !PersistanceManager.fetchDataUserProfile().isEmpty {
                NSLog("Clearing user data")
                try context.execute(deleteRequestUPFR)
                self.saveContext()
            }
            if !PersistanceManager.fetchRequestTopics().isEmpty {
                NSLog("Clearing topics data")
                try context.execute(deleteRequestTFR)
                self.saveContext()
            }
            
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
