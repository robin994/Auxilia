//
//  MapViewController.swift
//  iHelp
//
//  Created by Cirillo Stefano on 14/07/17.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class ManagerLocation: NSObject {
    
    static func localizzami() {
        let locManager = CLLocationManager()
        var currentLocation: CLLocation!
        locManager.requestWhenInUseAuthorization()
        NSLog("ENTROO LOCALIZZAZIONE")
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            NSLog("ENTROO LOCALIZZAZIONE 2")
            currentLocation = locManager.location
            print("\(currentLocation.coordinate.latitude)")
            print("\(currentLocation.coordinate.longitude)")
        }
    }
}


