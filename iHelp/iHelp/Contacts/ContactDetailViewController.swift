//
//  ContactDetailViewController.swift
//  iHelp
//
//  Created by Tortora Roberto on 11/07/2017.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import UIKit

class ContactDetailViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillAppear(_ animated: Bool) {
        if currentContact.contact.imageData != nil {
            imageView.image = UIImage(data: currentContact.contact.imageData!)
        }
        self.nameField.text = currentContact.name
        self.surnameField.text = currentContact.surname
        self.cellphoneField.text = currentContact.contact.phoneNumbers.first!.value.stringValue
        self.addressField.text = currentContact.contact.postalAddresses.first?.value.country
    }

    var currentContact: Contact!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var surnameField: UILabel!
    @IBOutlet weak var cellphoneField: UILabel!
    @IBOutlet weak var addressField: UILabel!
}
