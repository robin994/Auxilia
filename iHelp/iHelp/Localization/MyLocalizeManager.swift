//
//  MyLocalizeManager.swift
//  iHelp
//
//  Created by Cirillo Stefano on 19/07/17.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import Foundation

class MyLocalizeManager: NSObject{
    var lath: Double = 0.0
    var lon: Double = 0.0
    var vel: Double = 0.0
    
    func setLat(lati: Double){
        self.lath = lati
        print("-----LATITUDINEEEE \(self.lath)")
    }
    
    func getLat() -> Double{
        return self.lath as! Double
    }
    
    func setLon(lati: Double){
        self.lath = lati
        print("-----LONGITUDINEEEE  \(self.lon)")
    }
    
    func getLon() -> Double{
        return self.lath
    }
    
    func setVel(vel: Double){
        self.vel = vel
        print("-----VELOCITAA \(self.vel)")
    }
    
    func getVel() -> Double{
        return self.vel as! Double
    }
}
