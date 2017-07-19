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
    @IBOutlet weak var peso: UILabel!
    @IBOutlet weak var gruppoSanguigno: UILabel!
    @IBOutlet weak var fototipo: UILabel!
    @IBOutlet weak var sediaArotelle: UILabel!
    @IBOutlet weak var ultimoBattitoRilevato: UILabel!
    let healthManager:HealthKitManager = HealthKitManager()
    var height: HKQuantitySample?
    var weight: HKQuantitySample?
    var heightString = ""
    var weightString = ""
    var clinicalFolderObject: ClinicalFolder? = nil
    var heartRate: Double = 0.0
    var data = ""
    var sex = ""
    var skin = ""
    var sedia = ""
    var blood = ""

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // We cannot access the user's HealthKit data without specific permission.
        getHealthKitPermission()
        let dati = self.healthManager.readProfile()
        print("\n \n \n \(dati.age!) \(dati.biologicalsex!) \(dati.bloodtype!)")
        data = dati.age!
        sex = dati.biologicalsex!
        skin = dati.skin!
        sedia = dati.chairUse!
        blood = dati.bloodtype!
        dataDiNascita.text = dati.age
        sesso.text = dati.biologicalsex
        fototipo.text = dati.skin
        gruppoSanguigno.text = dati.bloodtype
        sediaArotelle.text = dati.chairUse
        self.altezza.text = "Not set"
        self.peso.text = "Not set"
        
        ultimoBattitoRilevato.text = "Not set"
        DispatchQueue.main.async(execute: { () -> Void in
            self.heartRate = self.healthManager.getTodaysHeartRates()!
            print("battito ricevutoooooooooo \(self.heartRate)")
            self.ultimoBattitoRilevato.text = "\(self.heartRate)"
            print("peso \(self.weightString), altezza \(self.heightString), battito \(self.heartRate)")
            self.clinicalFolderObject = ClinicalFolder(sesso: self.sex, dataDiNascita: self.data, altezza: self.heightString, peso: self.weightString, gruppoSanguigno: self.blood, fototipo: self.skin , sediaARotelle: self.sedia, ultimoBattito: String(describing: self.heartRate))
            PersistanceManager.setClinicalFolder(clinFolder: self.clinicalFolderObject!)
            
        })
        
   
        
        
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
                print("autorizzazione ha successo")
                
                // Get the user's height and weight
                self.setHeight()
                self.setWeight()
                
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
          
            self.height = userHeight as? HKQuantitySample
            
            // The height is formatted to the user's locale.
            if let meters = self.height?.quantity.doubleValue(for: HKUnit.meter()) {
                let formatHeight = LengthFormatter()
                formatHeight.isForPersonHeightUse = true
                self.heightString = formatHeight.string(fromMeters: meters)
            }
            
            // Set the label to reflect the user's height.
            DispatchQueue.main.async(execute: { () -> Void in
                self.altezza.text = self.heightString
            })
        })
        print("\n\n\n setHeight")
        
    }
    func setWeight() {
        // Create the HKSample for Height.
        let weightSample = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)
        
        // Call HealthKitManager's getSample() method to get the user's height.
        self.healthManager.getWeight(weightSample!, completion: { (userWeight, error) -> Void in
            
            if( error != nil ) {
                print("Errore: \(error?.localizedDescription)")
                return
            }
            
            
            
            self.weight = userWeight as? HKQuantitySample
            
            // The height is formatted to the user's locale.
            if var gram = self.weight?.quantity.doubleValue(for: HKUnit.gram()) {
                gram = gram/1000
                let formatWeight = MassFormatter()
                formatWeight.isForPersonMassUse = true
                self.weightString = formatWeight.string(fromKilograms: gram)
            }
            
  
            
            // Set the label to reflect the user's height.
            DispatchQueue.main.async(execute: { () -> Void in
                self.peso.text = self.weightString
            })
         
        })
        print("\n\n\n setWeight")
        
    }
   

  
    
}
