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
    
    var heartRate:Double = 0.0
    
      private func dataTypesToRead() -> Set<HKObjectType> {
     
        let heightType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
        let weightType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        let rateType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        let readDataTypes: Set<HKObjectType> = [heightType, weightType, rateType]
     
        return readDataTypes
     }
    
    
    
    func authorizeHealthKit(_ completion: ((_ success: Bool, _ error: NSError?) -> Void)!) {
      
          let readDataTypes: Set<HKObjectType> = self.dataTypesToRead()
        
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
        
        let wheelchairCharacteristic = HKCharacteristicType.characteristicType(
            forIdentifier: HKCharacteristicTypeIdentifier.wheelchairUse)
        
        let dataTypesToRead = NSSet(objects:
                                    dateOfBirthCharacteristic,
                                    biologicalSexCharacteristic,
                                    bloodTypeCharacteristic,
                                    skinTypeCharacteristic,
                                    wheelchairCharacteristic
            
        )
        
        healthKitStore.requestAuthorization(toShare: nil,
                                            read: dataTypesToRead as? Set<HKObjectType>,
                                            completion: { (success, error) -> Void in
                                                if success {
                                                    print("success authorization1")
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
        healthKitStore.requestAuthorization(toShare: healthDataToWrite, read: readDataTypes) { (success, error) -> Void in
            if( completion != nil ) {
                
                //todo nsjnxj
              //  completion(success: success, error: error as! NSError)
                print("success authorization2")
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
    
    func readProfile() -> ( age:String?,  biologicalsex:String?, bloodtype:String?, skin:String?, chairUse:String?)
    {

        var age:String?
        //   let year = Calendar.iso8601.ordinality(of: .year, in: .era, for: now)!
        print("readProfile: \n\n\n\n")
        
        //per usare la data
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        print(year ?? 1900)
        print(month ?? 1)
        print(day ?? 1)
     
        //per accedere alla data di nascita
        var dateOfBirth: Date?
        
        do {
            
            dateOfBirth = try healthKitStore.dateOfBirth()
            
            //let now = Date()
            
            let ageComponents: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: dateOfBirth!
            )
            print("ecco")
            age = "\(ageComponents.day!)/\(ageComponents.month!)/\(ageComponents.year!)"
            print("ecco2")
            
            print("\n\n\n\n anno di nascita \(age!)")
            
        } catch let error as NSError{
            print("errore1:  \(error)")
            print("Error reading Birthday: \(error.code)")

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
        let skinLiteral = HKFitzpatrickSkinTypeLiteral(skin?.skinType)
        
        var bloodType:HKBloodTypeObject?
        do {
            bloodType = try healthKitStore.bloodType()
            print("blood: \(String(describing: bloodType!.bloodType.rawValue))")
            
        } catch {
            print("errore3:  \(error)")
        }
        
      
        let lettera:String? = bloodTypeLiteral(bloodType?.bloodType)
        print("\n\n blood letter: \(lettera!)\n\n")
        
        //read wheelchairCharacteristic
        var wheelchair:HKWheelchairUseObject?
        do {
            wheelchair = try healthKitStore.wheelchairUse()
            print("wheelchair: \(String(describing: wheelchair!.wheelchairUse.rawValue))")
            
        } catch {
            print("errore2:  \(error)")
        }
        let chairuse:HKWheelchairUse? = wheelchair?.wheelchairUse
        let chairuseLiteral = wheelchairUseLiteral(chairuse)
        
        // 4. Return the information read in a tuple
        //  print("\n\n\n readprofile1: \(age) \(biologicalSex) \(blood) \n\n")
        let sexType:String? = biologicalSexLiteral(bi)
        print("\n\n biologicalsex: \(sexType!)")
        
        
        return (age, sexType, lettera, skinLiteral, chairuseLiteral)
    }
    func wheelchairUseLiteral(_ wheelchair:HKWheelchairUse?)->String
    {
        var wheelchairText = "kUnknownString";
        
        if  wheelchair != nil {
            
            switch( wheelchair! )
            {
            case .notSet:
                wheelchairText = "Not set"
            case .yes:
                wheelchairText = "Yes"
            case .no:
                wheelchairText = "Not"
            default:
                break;
            }
            
        }
        return wheelchairText;
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
            }
            
        }
        return bloodTypeText;
    }
    
    func HKFitzpatrickSkinTypeLiteral(_ bloodType:HKFitzpatrickSkinType?)->String
    {
        
        var fitzpatrickSkin = "UnknownString";
        print("bloodType: \(bloodType!)\n\n")
        
        if bloodType != nil {
            switch( bloodType! ) {
            case .notSet:
            fitzpatrickSkin = "not set"
            case .I:
            fitzpatrickSkin = "Type I"
            case .II:
            fitzpatrickSkin = "Type II"
            case .III:
            fitzpatrickSkin = "Type III"
            case .IV:
            fitzpatrickSkin = "Type IV"
            case .V:
            fitzpatrickSkin = "Type V"
            case .VI:
            fitzpatrickSkin = "Type VI"
        }
            
        }
        return fitzpatrickSkin;
    }
    func getWeight(_ sampleType: HKSampleType , completion: ((HKSample?, NSError?) -> Void)!) {
        
        // Predicate for the height query
        let distantPastHeight = Date.distantPast as Date
        let currentDate = Date()
        let lastHeightPredicate = HKQuery.predicateForSamples(withStart: distantPastHeight, end: currentDate, options: HKQueryOptions())
        
        // Get the single most recent height
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        // Query HealthKit for the last Height entry.
        let weightQuery = HKSampleQuery(sampleType: sampleType, predicate: lastHeightPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { (sampleQuery, results, error ) -> Void in
            
            
            if let queryError = error {
                completion(nil, queryError as NSError)
                return
            }
            
            // Set the first HKQuantitySample in results as the most recent height.
            let lastWeight = results!.first
            
            if completion != nil {
                completion(lastWeight, nil)
            }
        }
        
        // Time to execute the query.
        self.healthKitStore.execute(weightQuery)
    }
    let heartRateUnit:HKUnit = HKUnit(from: "count/min")
    let heartRateType:HKQuantityType   = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
    var heartRateQuery:HKSampleQuery?
    var heartRateString: String = "0"
    
    
    /*Method to get todays heart rate - this only reads data from health kit. */
    func getTodaysHeartRates()->(Double?){
        //predicate
        print("getTodaysHeartRates")
        
        
     //   let calendar = NSCalendar.current
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)
        let date = NSDate()
        let components = NSDateComponents()
        
     //   let components = calendar.dateComponents([.year, .month, .day], from: date as Date)
        
      //  let year =  components.year
      //  let month = components.month
      //  let day = components.day
        
     //   let startDate:Date = components.date!
        //  let endDate:Date? = calendar.dateByAddingUnit(.day, value: 1, toDate: startDate, options: [])
      
        //let endDate:Date? = calendar.date(byAdding: .day, value: 1, to: date)
        print("getTodaysHeartRates5")
        let startDate = calendar?.date(from: components as DateComponents)

        
        let endDate = calendar?.date(byAdding: .day, value: 1, to: startDate!, options: [])
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate as! Date, end: nil, options: [])
        
        //descriptor
        let sortDescriptors = [
            NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        ]
        print("getTodaysHeartRates2")
        
     /*   let query = HKAnchoredObjectQuery(type: heartRateType, predicate: predicate, anchor: nil, limit: Int(HKObjectQueryNoLimit)) {
            (query, samples, deletedObjects, anchor, error) -> Void in
            print(".....\n")
            self.printHeartRateInfo(results: samples)
            
        }
        
        query.updateHandler = { (query, samples, deletedObjects, anchor, error) -> Void in
            print("111....\n")
            self.printHeartRateInfo(results: samples)
        }*/
        
        heartRateQuery = HKSampleQuery(sampleType: heartRateType,
                                       predicate: predicate,
                                       limit: 1,
                                       sortDescriptors: sortDescriptors)
        { query, results, error in
            guard (results as? [HKQuantitySample]) != nil else {
                fatalError("An error occured fetching the user's tracked food. In your app, try to handle this error gracefully. The error was: \(String(describing: error?.localizedDescription))");
            }
           // self.printHeartRateInfo(results: results)
            
            let c: Int = (results?.count)!
            if(c==0){
                print("non c'è nnt")
            }else{
                print("stampo tutti i dati del battito\n\n")
                guard let currData:HKQuantitySample = results![0] as? HKQuantitySample else { return }
                self.heartRate = currData.quantity.doubleValue(for: self.heartRateUnit)
                print("Heart Rate: \(self.heartRate)\n")
            }

           
            
             if(self.heartRate == 0.0){
                 self.heartRateString = "Not set"
              }else{
            self.heartRateString = String(format:"%f", self.heartRate)
            }
            print("getTodaysHeartRates1")

        }
        self.healthKitStore.execute(heartRateQuery!)
        NSLog("battito: \(self.heartRate)")
        return (self.heartRate)
        
    }//eom
    
    /*used only for testing, prints heart rate info */
    private func printHeartRateInfo(results:[HKSample]?)
    {
       
        let c: Int = (results?.count)!
        if(c==0){
            print("non c'è nnt")
        }else{
            print("stampo tutti i dati del battito\n\n")
        }
        for iter in 0..<c
        {
            guard let currData:HKQuantitySample = results![iter] as? HKQuantitySample else { return }
            
            print("[\(iter)]")
            print("Heart Rate: \(currData.quantity.doubleValue(for: heartRateUnit))\n")
            print("quantityType: \(currData.quantityType)\n")
            print("Start Date: \(currData.startDate)\n")
            print("End Date: \(currData.endDate)\n")
            print("Metadata: \(String(describing: currData.metadata))\n")
            print("UUID: \(currData.uuid)\n")
            print("Source: \(currData.sourceRevision)\n")
            print("Device: \(String(describing: currData.device))\n")
            print("---------------------------------\n")
        }//eofl
    }//eom
    

}
