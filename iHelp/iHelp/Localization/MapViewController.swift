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
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    
    
    @IBOutlet weak var openMap: UIButton!
    @IBOutlet weak var map: MKMapView!
    
    var locationManager = CLLocationManager()
    var altitudine2:CLLocationDistance = 0.0
    var velocita2:CLLocationSpeed = 0.0
    var latitudine2:CLLocationDegrees = 0.0
    var longitudine2:CLLocationDegrees = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        openMap.layer.masksToBounds = true
        openMap.layer.cornerRadius = 20
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    /*
     Azione del pulsante click
     */
    @IBAction func openMappe(_ sender: Any) {
        let alert = UIAlertController(title: "Proced?", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default) {
           UIAlertAction in
            NSLog("OK Pressed")
            self.openExternalMap(self.latitudine2, self.longitudine2)
        }
        
         let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
           NSLog("Cancel Pressed")
         }
         alert.addAction(okAction)
         alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    //il metodo apre l'applicazione maps con i parametri passati
    func openExternalMap(_ latit: Double, _ longit: Double){
        let latitude: CLLocationDegrees = latit
        let longitude: CLLocationDegrees = longit
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Trova il tuo caro"
        mapItem.openInMaps(launchOptions: options)
    }
    
    /*
     geolocalizza la mappa su dove sei
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("......................wwwwwww")
        //let userLocation:CLLocation = locations[0] as CLLocation
        let userLocation = CLLocation(latitude: self.latitudine2, longitude: self.longitudine2)
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01,0.01)
        
        //se al posto dei parametri, inserisco i valori di latitudine e longitudine, punta direttamente alla posizione indicata
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.latitudine2, self.longitudine2)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        map.setRegion(region, animated: true)
        
        //estraggo le informazioni
        let altitudine = userLocation.altitude
        let velocita = userLocation.speed
        let latitudine = self.latitudine2
        let longitudine = self.longitudine2
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: self.latitudine2, longitude: self.longitudine2)
        self.map.addAnnotation(annotation)
        
        self.setVelocita(velocita)
        self.setAltitudine(altitudine)
        self.setLongitudine(longitudine)
        self.setLatitudine(latitudine)
        print("\(getLatitudine())")
        print("\(getLongitudine())")
        print("\(getAltitudine())")
        print("\(getVelocita())")
        self.map.showsUserLocation = true
        locationManager.stopUpdatingLocation()
    }
    
    /*
     settaggio dei dati di locazione attuali (live)
     */
    func setLatitudine(_ lati: CLLocationDegrees){
        self.latitudine2 = lati
    }
    func setLongitudine(_ long: CLLocationDegrees){
        self.longitudine2 = long
    }
    func setAltitudine(_ alt: CLLocationDistance ){
        self.altitudine2 = alt
    }
    func setVelocita(_ velo: CLLocationSpeed){
        self.velocita2 = velo
    }
    
    /*
     metodi getter dei dati di localizzazione attuali (live)
     */
    func getLatitudine() -> CLLocationDegrees{
        return latitudine2
    }
    func getLongitudine()-> CLLocationDegrees{
        return longitudine2
    }
    func getAltitudine() -> CLLocationDistance{
        return altitudine2
    }
    func getVelocita() -> CLLocationSpeed{
        return velocita2
    }
    
}

