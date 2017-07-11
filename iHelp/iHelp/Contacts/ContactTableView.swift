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

class ContactTableView: UITableViewController, CNContactPickerDelegate {
    
    var contactStore: ContactStore!
    var savedContacts: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactStore = ContactStore()
            
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Function to add new contact to the list
    @IBAction func addContact(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new contact", message: "Select the source", preferredStyle: .alert)
        let addContact = UIAlertAction(title: "Contacts", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("Contact Pressed")
            let cnPicker = CNContactPickerViewController()
            cnPicker.delegate = self
            self.present(cnPicker, animated: true, completion: nil)
        }
        let addNewContact = UIAlertAction(title: "Add new contact", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("New Contact Pressed")
            
                // DA COMPLETARE
            let cnPicker = CNContactPickerViewController()
            
            cnPicker.delegate = self
            self.present(cnPicker, animated: true, completion: nil)
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alert.addAction(addContact)
        alert.addAction(addNewContact)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        contactStore.addContact(contact: Contact.init(contact: contact))
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
