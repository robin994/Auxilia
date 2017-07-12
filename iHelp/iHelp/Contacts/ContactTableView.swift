//
//  ContactTableView.swift
//  iHelp
//
//  Created by Tortora Roberto on 11/07/2017.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import UIKit
import ContactsUI
import CoreData
import Contacts

class ContactTableView: UITableViewController, CNContactPickerDelegate {
    
    var contactStore: ContactStore!
    var savedContacts: [Contact] = []
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactStore = ContactStore()
        myContactStore = CNContactStore()
        let contacts: [EmergencyContact] = PersistanceManager.fetchData()
        for contact in contacts {
            contactStore.addContact(contact: Contact(contact: getCNContact(contact.contactIdentifier!, keysToFetch: keysToFetch)!))
        }
        print(contacts.description)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    //Function to add new contact to the list
    @IBAction func addContact(_ sender: UIBarButtonItem) {
        let cnPicker = CNContactPickerViewController()
        cnPicker.delegate = self
        self.present(cnPicker, animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        contactStore.addContact(contact: Contact.init(contact: contact))
        PersistanceManager.newEmergencyContact(toAdd: Contact.init(contact: contact))
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Cancel Contact Picker")
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contactStore.array.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        let currentContact = contactStore.array[indexPath.row]
        cell.contactName.text = "\(currentContact.name) \(currentContact.surname)"
        
        
        cell.imageContact.clipsToBounds = true
        cell.imageContact.layer.borderWidth=1.0;
        cell.imageContact.layer.masksToBounds = true;
        cell.imageContact.layer.cornerRadius = cell.imageContact.frame.height / 2
        cell.imageContact.layer.borderColor = UIColor.gray.cgColor;
        if currentContact.contact.imageData != nil {
            cell.imageContact.image = UIImage(data: currentContact.contact.imageData!)
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            
            PersistanceManager.removeEmergencyContact(toRemove: contactStore.array[indexPath.row] )
            contactStore.removeContact(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch segue.identifier {
        case "show"? :
            if let currentindex = tableView.indexPathForSelectedRow?.row {
                let currentContact = contactStore.array[currentindex]
                let dstView = segue.destination as! ContactDetailViewController
                dstView.currentContact = currentContact
            }
        default :
            if let currentindex = tableView.indexPathForSelectedRow?.row {
                let currentContact = contactStore.array[currentindex]
                let dstView = segue.destination as! ContactDetailViewController
                dstView.currentContact = currentContact
            }
        }

    }
    

}
