//
//  ContactStore.swift
//  iHelp
//
//  Created by Tortora Roberto on 11/07/2017.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import UIKit
import Contacts

class ContactStore: NSObject {
    var array:[Contact] = []
    var myContactStore: CNContactStore!
    
    
    func isInside(_ first: Contact ) -> Bool {
        for second in array {
            if (first.contact.identifier == second.contact.identifier) {
                return true
            }
        }
        return false
    }
    
    func addContact(contact : Contact) {
        NSLog("Richiesta aggiunta contatto")
        if !isInside(contact) {
            PersistanceManager.newEmergencyContact(toAdd: contact)
            array.append(contact)
            NSLog("Aggiunto contatto")
        }
    }
    
    func removeContact(at: Int) {
        if array.count >= at && at <= 0  {
            NSLog("rimosso contatto: \(array[at].name)")
            PersistanceManager.removeEmergencyContact(toRemove: array[at])
            array.remove(at: at)
            NSLog("Contatto rimosso con successo")
        } else {
            NSLog("Contatto non rimosso")
        }
    }
    
    func sortByNameCresc() {
        array = array.sorted { $0.name < $1.name }
    }
    
    func sortByNameDec() {
        array = array.sorted { $0.name > $1.name }
    }
    
    func reorder(from: Int , to: Int) {
        let foo: Contact = array[from]
        array.remove(at: from)
        array.insert(foo, at: to)
    }
    
    static func getCNContact( _ identifier: String) -> CNContact? {
        let contactStore = CNContactStore()
        
        let keysToFetch: [CNKeyDescriptor] = [
            CNContactBirthdayKey as CNKeyDescriptor,
            CNContactDatesKey as CNKeyDescriptor,
            CNContactDepartmentNameKey as CNKeyDescriptor,
            CNContactEmailAddressesKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactIdentifierKey as CNKeyDescriptor,
            CNContactImageDataAvailableKey as CNKeyDescriptor,
            CNContactImageDataKey as CNKeyDescriptor,
            CNContactInstantMessageAddressesKey as CNKeyDescriptor,
            CNContactJobTitleKey as CNKeyDescriptor,
            CNContactMiddleNameKey as CNKeyDescriptor,
            CNContactNamePrefixKey as CNKeyDescriptor,
            CNContactNameSuffixKey as CNKeyDescriptor,
            CNContactNicknameKey as CNKeyDescriptor,
            CNContactNonGregorianBirthdayKey as CNKeyDescriptor,
            CNContactNoteKey as CNKeyDescriptor,
            CNContactOrganizationNameKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor,
            CNContactPhoneticFamilyNameKey as CNKeyDescriptor,
            CNContactPhoneticGivenNameKey as CNKeyDescriptor,
            CNContactPhoneticMiddleNameKey as CNKeyDescriptor,
            CNContactPhoneticOrganizationNameKey as CNKeyDescriptor,
            CNContactPostalAddressesKey as CNKeyDescriptor,
            CNContactPreviousFamilyNameKey as CNKeyDescriptor,
            CNContactRelationsKey as CNKeyDescriptor,
            CNContactSocialProfilesKey as CNKeyDescriptor,
            CNContactThumbnailImageDataKey as CNKeyDescriptor,
            CNContactTypeKey as CNKeyDescriptor,
            CNContactUrlAddressesKey as CNKeyDescriptor,
            ]
        
        
        do {
            let cNContact = try contactStore.unifiedContact( withIdentifier: identifier, keysToFetch: keysToFetch )
            return cNContact
        } catch let error as NSError {
            NSLog("Problem getting unified contact with identifier: " + identifier)
            NSLog(error.localizedDescription)
            return nil
        }
    }
    
    func reloadSavedData() {
        NSLog("Ricarico dati dal database")
        let contacts = PersistanceManager.fetchDataEmergencyContact()
        for contact in contacts {
            self.addContact(contact: Contact(contact: ContactStore.getCNContact(contact.contactIdentifier!)!))
        }
    }
}
