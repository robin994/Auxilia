//
//  ClinicalFolderViewController.swift
//  iHelp
//
//  Created by Korniychuk Alina on 15/07/17.
//  Copyright © 2017 The Round Table. All rights reserved.
//
import UIKit
import Foundation
import HealthKit
class ClinicalFolderViewController: UITableViewController {
    
    
    
    @IBOutlet weak var sesso: UILabel!
    
    @IBOutlet weak var dataDiNascita: UILabel!
    @IBOutlet weak var altezza: UILabel!
    @IBOutlet weak var gruppoSanguigno: UILabel!
    @IBOutlet weak var fototipo: UILabel!
    @IBOutlet weak var ultimoBattitoRilevato: UILabel!
    let healthManager:HealthKitManager = HealthKitManager()
    var height: HKQuantitySample?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // We cannot access the user's HealthKit data without specific permission.
        getHealthKitPermission()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       }
    
    
    func getHealthKitPermission() {
        
        // Seek authorization in HealthKitManager.swift.
        healthManager.authorizeHealthKit { (authorized,  error) -> Void in
            if authorized {
                
                // Get and set the user's height.
                self.setHeight()
            } else {
                if error != nil {
                    print("errore")
                }
                print("Permission denied.")
            }
        }
    }
    
    func setHeight() {
        // Create the HKSample for Height.
        let heightSample = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)
        
        // Call HealthKitManager's getSample() method to get the user's height.
        self.healthManager.getHeight(heightSample!, completion: { (userHeight, error) -> Void in
            
            if( error != nil ) {
                print("Errore: \(error?.localizedDescription)")
                return
            }
            
            var heightString = ""
            
            self.height = userHeight as? HKQuantitySample
            
            // The height is formatted to the user's locale.
            if let meters = self.height?.quantity.doubleValue(for: HKUnit.meter()) {
                let formatHeight = LengthFormatter()
                formatHeight.isForPersonHeightUse = true
                heightString = formatHeight.string(fromMeters: meters)
            }
            
            // Set the label to reflect the user's height.
            DispatchQueue.main.async(execute: { () -> Void in
                self.altezza.text = heightString
                
            })
           // self.age.text = heightString
        })
        
        
    }
  
    
    
}
