//
//  Contact.swift
//  iHelp
//
//  Created by Tortora Roberto on 11/07/2017.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import UIKit
import Contacts

class Contact: NSObject {
    var name: String
    var surname: String
    var number: [CNLabeledValue<CNPhoneNumber>]
    var contactKey: String
    var contact: CNContact
    init(contact: CNContact) {
        self.name = contact.givenName
        self.surname = contact.familyName
        self.number = contact.phoneNumbers
        self.contact = contact
        self.contactKey = contact.identifier
    }
}
