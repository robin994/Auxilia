//
//  HealthKitManager.swift
//  iHelp
//
//  Created by Korniychuk Alina on 15/07/17.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitManager {
    
    let healthKitStore: HKHealthStore = HKHealthStore()
    
    
    func authorizeHealthKit(_ completion: ((_ success: Bool, _ error: NSError?) -> Void)!) {
      
        // State the health data type(s) we want to read from HealthKit.
        let healthDataToRead = Set(arrayLiteral:HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!)
  
        let healthStore: HKHealthStore? = {
            if HKHealthStore.isHealthDataAvailable() {
                return HKHealthStore()
            } else {
                return nil
            }
        }()
        
        let dateOfBirthCharacteristic = HKCharacteristicType.characteristicType(
            forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)
        
        let biologicalSexCharacteristic = HKCharacteristicType.characteristicType(
            forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)
        
        let bloodTypeCharacteristic = HKCharacteristicType.characteristicType(
            forIdentifier: HKCharacteristicTypeIdentifier.bloodType)
        
        let skinTypeCharacteristic = HKCharacteristicType.characteristicType(
            forIdentifier: HKCharacteristicTypeIdentifier.fitzpatrickSkinType)
        
        
        let dataTypesToRead = NSSet(objects:
            dateOfBirthCharacteristic,
                                    biologicalSexCharacteristic,
                                    bloodTypeCharacteristic,
                                    skinTypeCharacteristic
            
            
        )
        
        healthKitStore.requestAuthorization(toShare: nil,
                                            read: dataTypesToRead as! Set<HKObjectType>,
                                            completion: { (success, error) -> Void in
                                                if success {
                                                    print("success authorization")
                                                } else {
                                                    print(error!)
                                                }
        })
        // State the health data type(s) we want to write from HealthKit.
        let healthDataToWrite = Set(arrayLiteral: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!)
        
        // Just in case OneHourWalker makes its way to an iPad...
        if !HKHealthStore.isHealthDataAvailable() {
            print("Can't access HealthKit.")
            // self.view.makeToast("Can't access HealthKit.", duration: 0.5, position: "bottom")
            
        }
        
        // Request authorization to read and/or write the specific data.
        healthKitStore.requestAuthorization(toShare: healthDataToWrite, read: healthDataToRead) { (success, error) -> Void in
            if( completion != nil ) {
                
                //todo nsjnxj
              //  completion(success: success, error: error as! NSError)
            }
        }
        
    }
    
    
    func getHeight(_ sampleType: HKSampleType , completion: ((HKSample?, NSError?) -> Void)!) {
        
        // Predicate for the height query
        let distantPastHeight = Date.distantPast as Date
        let currentDate = Date()
        let lastHeightPredicate = HKQuery.predicateForSamples(withStart: distantPastHeight, end: currentDate, options: HKQueryOptions())
        
        // Get the single most recent height
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        // Query HealthKit for the last Height entry.
        let heightQuery = HKSampleQuery(sampleType: sampleType, predicate: lastHeightPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { (sampleQuery, results, error ) -> Void in
            
            
            if let queryError = error {
                completion(nil, queryError as NSError)
                return
            }
            
            // Set the first HKQuantitySample in results as the most recent height.
            let lastHeight = results!.first
            
            if completion != nil {
                completion(lastHeight, nil)
            }
        }
        
        // Time to execute the query.
        self.healthKitStore.execute(heightQuery)
    }
    
    func readProfile() -> ( age:Int?,  biologicalsex:HKBiologicalSex?, bloodtype:HKBloodType?)
    {
        var error:NSError?
        var age:Int?
        //   let year = Calendar.iso8601.ordinality(of: .year, in: .era, for: now)!
        print("readProfile: \n\n\n\n")
        
        //per usare la data
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        print(year)
        print(month)
        print(day)
        
        
        
        
        //per accedere alla data di nascita
        var dateOfBirth: Date?
        
        do {
            
            dateOfBirth = try healthKitStore.dateOfBirth()
            
            let now = Date()
            
            let ageComponents: DateComponents = Calendar.current.dateComponents([.year], from: dateOfBirth!, to: now)
            
            let userAge: Int = ageComponents.year!
            
            print("\n\n\n\n annoooo \(userAge)")
            
        } catch {
            print("errore1:  \(error)")
        }
        
        
        
        
        
        //   let fullNameArr = data.componentsSeparatedByString(".")
        
        //  var firstName: String = fullNameArr[0]
        //   var lastName: String = fullNameArr[1]
        
        
        
        
        if error != nil {
            print("Error reading Birthday: \(String(describing: error))")
        }
        
        
        
        // 2. Read biological sex
        var biologicalSex:HKBiologicalSexObject?
        do {
            biologicalSex = try healthKitStore.biologicalSex()
            print("sex: \(String(describing: biologicalSex!.biologicalSex.rawValue))")
            
        } catch {
            print("errore2:  \(error)")
        }
        let bi:HKBiologicalSex? = biologicalSex?.biologicalSex
        
        // 3. Read blood type
        
        var skin:HKFitzpatrickSkinTypeObject?
        do {
            skin = try healthKitStore.fitzpatrickSkinType()
            print("skin: \(String(describing: skin!.skinType.rawValue))")
            
        } catch {
            print("errore3:  \(error)")
        }
        
        var bloodType:HKBloodTypeObject?
        do {
            bloodType = try healthKitStore.bloodType()
            print("blood: \(String(describing: bloodType!.bloodType.rawValue))")
            
        } catch {
            print("errore3:  \(error)")
        }
        
        let blood: HKBloodType? = bloodType?.bloodType
        
        let lettera:String? = bloodTypeLiteral(bloodType?.bloodType)
        print("\n\n blood letter: \(lettera!)\n\n")
        
        
        // 4. Return the information read in a tuple
        //  print("\n\n\n readprofile1: \(age) \(biologicalSex) \(blood) \n\n")
        let a:String? = biologicalSexLiteral(bi)
        print("\n\n biologicalsex: \(a!)")
        return (age, bi, blood)
    }
    func biologicalSexLiteral(_ biologicalSex:HKBiologicalSex?)->String
    {
        var biologicalSexText = "kUnknownString";
        
        if  biologicalSex != nil {
            
            switch( biologicalSex! )
            {
            case .female:
                biologicalSexText = "Female"
            case .male:
                biologicalSexText = "Male"
            default:
                break;
            }
            
        }
        return biologicalSexText;
    }
    func bloodTypeLiteral(_ bloodType:HKBloodType?)->String
    {
        
        var bloodTypeText = "kUnknownString";
        print("bloodType: \(bloodType!)\n\n")
        
        if bloodType != nil {
            
            switch( bloodType! ) {
                
            case .notSet:
                bloodTypeText = "not set"
            case .aPositive:
                bloodTypeText = "A+"
            case .aNegative:
                bloodTypeText = "A-"
            case .bPositive:
                bloodTypeText = "B+"
            case .bNegative:
                bloodTypeText = "B-"
            case .abPositive:
                bloodTypeText = "AB+"
                
            case .abNegative:
                bloodTypeText = "AB-"
            case .oPositive:
                bloodTypeText = "O+"
            case .oNegative:
                bloodTypeText = "O-"
            default:
                break;
            }
            
        }
        return bloodTypeText;
    }
    
}
