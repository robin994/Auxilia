//
//  ClinicalFolderViewController.swift
//  iHelp
//
//  Created by Korniychuk Alina on 15/07/17.
//  Copyright © 2017 The Round Table. All rights reserved.
//
import UIKit
import Foundation
class ClinicalFolderViewController: UITableViewController {
    
   
    @IBOutlet weak var labelAltezza: UIView!
    @IBOutlet weak var labelDataDiNascita: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
     /*   let users = PersistanceManager.fetchDataUserProfile()
        if users.first?.isSet == false {
            if let viewController: UIViewController  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeView") {
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        }*/
}
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    /*    let users = PersistanceManager.fetchDataUserProfile()
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1.0;
        imageView.layer.masksToBounds = true;
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.layer.borderColor = UIColor.gray.cgColor;
        imageView.image = UIImage(data: (users.first?.userPhoto!.subdata(with: NSMakeRange(0, (users.first?.userPhoto?.length)!)))!)
        nameField.text = users.first?.name
        surnameField.text = users.first?.surname
        addressField.text = users.first?.address*/
    }
    
    
}
