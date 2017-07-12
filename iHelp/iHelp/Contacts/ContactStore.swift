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
    
    
    func addContact(contact : Contact) {
        
        if !array.contains(contact) {
            PersistanceManager.newEmergencyContact(toAdd: contact)
            array.append(contact)
        }
    }
    
    func removeContact(at: Int) {
        if PersistanceManager.removeEmergencyContact(toRemove: self.array[at] )  {
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
    
    func getCNContact( _ identifier: String, keysToFetch: [CNKeyDescriptor] ) -> CNContact? {
        let contactStore = CNContactStore()
        do {
            let cNContact = try contactStore.unifiedContact( withIdentifier: identifier, keysToFetch: keysToFetch )
            return cNContact
        } catch let error as NSError {
            NSLog("Problem getting unified contact with identifier: " + identifier)
            NSLog(error.localizedDescription)
            return nil
        }
    }
    
    func reloadSavedData(_ contacts: [EmergencyContact]) {
        for contact in contacts {
            self.addContact(contact: Contact(contact: getCNContact(contact.contactIdentifier!, keysToFetch: keysToFetch)!))
        }
    }
}
