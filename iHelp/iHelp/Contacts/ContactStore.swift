//
//  ContactStore.swift
//  iHelp
//
//  Created by Tortora Roberto on 11/07/2017.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import UIKit

class ContactStore: NSObject {
    var array:[Contact] = []
    
    
    func addContact(contact : Contact) {
        if !array.contains(contact) {
            array.append(contact)
        }
    }
    
    func createEmptyReport() {
        let contact = Contact.init(name: "Empty", number: "666666666")
        array.append(contact)
    }
    
    func removeContact(at: Int) {
        array.remove(at: at)
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
}
