//
//  UserProfileViewController.swift
//  iHelp
//
//  Created by Tortora Roberto on 14/07/2017.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import UIKit

class UserProfileViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let users = PersistanceManager.fetchDataUserProfile()
        imageView.image = UIImage(data: users.first?.userPhoto as! Data)
        nameField.text = users.first?.name
        surnameField.text = users.first?.surname
        addressField.text = users.first?.address
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

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var surnameField: UILabel!
    @IBOutlet weak var addressField: UILabel!
}
