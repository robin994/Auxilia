//
//  ContactTableView.swift
//  iHelp
//
//  Created by Tortora Roberto on 11/07/2017.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import UIKit
import ContactsUI
import Contacts

class ContactTableView: UITableViewController, CNContactPickerDelegate {
    
    var contactStore: ContactStore!
    var savedContacts: [Contact] = []
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactStore = ContactStore()
        //PersistanceManager.resetCoreData()
        contactStore.reloadSavedData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func callSOS(_ sender: UIBarButtonItem) {
        present(SOS.callSOS(self.navigationController), animated: true, completion: nil)
    }
    
    
    
    //Function to add new contact to the list
    @IBAction func addContact(_ sender: UIBarButtonItem) {
        let cnPicker = CNContactPickerViewController()
        cnPicker.delegate = self
        self.present(cnPicker, animated: true, completion: nil)
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
        
        
        cell.imageContact.clipsToBounds = true
        cell.imageContact.layer.borderWidth=0.5;
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

    @IBAction func iscriviti(_ sender: UIBarButtonItem) {
        NotificationManager.subscribe("Notifiche")
    }
    
    @IBAction func inviaNotifica(_ sender: UIBarButtonItem) {
        let topics = PersistanceManager.fetchRequestTopics()
        //NSLog(topics.description)
        let message = "Sono una fottuta notifica"
        let title = "Quasi finito"
        for topic in topics {
            NotificationManager.sendNotification(topic: topic.topic! as! String, message: message, title: title)
        }
    }
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
