//
//  SettingViewController.swift
//  iHelp
//
//  Created by Tortora Roberto on 14/07/2017.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetAppButton(_ sender: Any) {
        let alert = UIAlertController(title: "Clear Data", message: "", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("Clear Data Pressed")
           // PersistanceManager.resetCoreData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func callSOS(_ sender: UIBarButtonItem) {
        present(SOS.callSOS(self.navigationController), animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
