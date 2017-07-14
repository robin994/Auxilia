//
//  CreateProfileViewController.swift
//  iHelp
//
//  Created by Tortora Roberto on 13/07/2017.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import UIKit

class CreateProfileViewController: UITableViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func photoButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Update profile Photo", message: "Select source", preferredStyle: .alert)
        let photo = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("Take Photo")
            self.takePhoto(.camera)
        }
        
        let library = UIAlertAction(title: "Choose from library", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("Take Library")
            self.takePhoto(.photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        alert.addAction(photo)
        alert.addAction(library)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func takePhoto(_ sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        imageView.image = image
        dismiss(animated: true, completion: nil)
    }

    @IBAction func confirmButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Confirm?", message: "", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("Save profile")
            PersistanceManager.setUserProfile(
                name: self.nameField.text!,
                surname: self.surnameField.text!,
                address: self.addressField.text!,
                image: self.imageView.image!)
            self.openMainView()
        }
        
        let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Profile not sasved")
        }
        
        alert.addAction(confirm)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func openMainView() {
        if let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainView") {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
