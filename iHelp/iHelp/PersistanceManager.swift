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
    static let name = "EmergencyContact"
    
    
    static func getContext() -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
    
    
    static func newEmergencyContact(toAdd: Contact) -> EmergencyContact {
     
        let context = getContext()
 
        let contact = NSEntityDescription.insertNewObject(forEntityName: name, into: context) as! EmergencyContact
        contact.contactIdentifier = toAdd.contactKey
        contact.name = toAdd.name
        contact.number = toAdd.contact.phoneNumbers.first!.value.stringValue
        return contact
        
    }
    
    static func removeEmergencyContact(toRemove: Contact) -> Bool {
        let context = getContext()
        let datas: [EmergencyContact] = fetchData()
        for data in datas {
            if (data.contactIdentifier == toRemove.contactKey) {
                context.delete(data)
                return true
            }
        }
        return false
    }

    static func fetchData() -> [EmergencyContact] {
        var contacts = [EmergencyContact]()
        
        let context = getContext()
        
        let fetchRequest = NSFetchRequest<EmergencyContact>(entityName: name)
        
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
}
