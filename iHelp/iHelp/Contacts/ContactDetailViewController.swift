//
//  ContactDetailViewController.swift
//  iHelp
//
//  Created by Tortora Roberto on 11/07/2017.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        imageView.clipsToBounds = true
        imageView.layer.borderWidth=1.0;
        imageView.layer.masksToBounds = true;
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.layer.borderColor = UIColor.gray.cgColor;
        if currentContact.contact.imageData != nil {
            imageView.image = UIImage(data: currentContact.contact.imageData!)
        }
        self.nameField.text = "\(currentContact.name) \(currentContact.surname)"
        self.cellphoneField.text = currentContact.contact.phoneNumbers.first!.value.stringValue
    }

    @IBOutlet weak var tableView: UITableView!
    var currentContact: Contact!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var cellphoneField: UILabel!
}
