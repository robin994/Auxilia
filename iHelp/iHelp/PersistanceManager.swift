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
    
    static func newEmergencyContact(toAdd: Contact) -> Contact {
        let context = getContext()
        
        let contact = NSEntityDescription.insertNewObject(forEntityName: name, into: context) as! Contact
        contact.contact = toAdd.contact
        contact.name = toAdd.name
        contact.number = toAdd.number
        contact.contactKey = toAdd.contactKey
        return contact
        
    }
    /*
    static func fetchData() -> [Contact] {
        var contacts = [Contact]()
        
        let context = getContext()
        
        let fetchRequest = NSFetchRequest<Contact>(entityName: name)
        
        do {
            try contacts = context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Error in \(error.code)")
        }
        
        return contacts
    }
    */
    static func saveContext() {
        let context = getContext()
        
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Error in \(error.code)")
        }
    }
}
