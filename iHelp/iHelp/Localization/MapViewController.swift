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
    @IBOutlet weak var localizza: UIButton!
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     Azione del pulsante click
     */
    @IBAction func setLocalizzazione(_ sender: Any) {
        openExternalMap(40.294838, 29.4848)
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
        let userLocation:CLLocation = locations[0] as CLLocation
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01,0.01)
        
        //se al posto dei parametri, inserisco i valori di latitudine e longitudine, punta direttamente alla posizione indicata
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        map.setRegion(region, animated: true)
        
        //estraggo le informazioni
        var altitudine = userLocation.altitude
        var velocita = userLocation.speed
        var latitudine = userLocation.coordinate.latitude
        var longitudine = userLocation.coordinate.longitude
        
        self.setVelocita(velocita)
        self.setAltitudine(altitudine)
        self.setLongitudine(longitudine)
        self.setLatitudine(latitudine)
        print("\(getLatitudine())")
        print("\(getLongitudine())")
        print("\(getAltitudine())")
        print("\(getVelocita())")
        self.map.showsUserLocation = true
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

