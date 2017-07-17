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
        let users = PersistanceManager.fetchDataUserProfile()
        if users.first?.isSet == false {
            if let viewController: UIViewController  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeView") {
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        }
        //crea immagine sfocata
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = blurredImageView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurredImageView.addSubview(blurView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let users = PersistanceManager.fetchDataUserProfile()
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1.0;
        imageView.layer.masksToBounds = true;
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.layer.borderColor = UIColor.gray.cgColor;
        
        
        imageView.image = UIImage(data: (users.first?.userPhoto!.subdata(with: NSMakeRange(0, (users.first?.userPhoto?.length)!)))!)
        blurredImageView.image = imageView.image
        
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

    @IBOutlet weak var imageViewCell: UITableViewCell!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var blurredImageView: UIImageView!
    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var surnameField: UILabel!
    @IBOutlet weak var addressField: UILabel!
}
