//
//  ViewController.swift
//  Jany_Ertveldt_multec_werkstuk2
//
//  Created by Jany Ertveldt on 27/04/18.
//  Copyright © 2018 Jany Ertveldt. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
import MapKit

class ViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {
    var opgehaaldeStations:[Station] = []
    var locationManager = CLLocationManager()
    var location : CLLocation!
    @IBOutlet weak var mijnMapview: MKMapView!
    
//    https://stackoverflow.com/questions/39920792/deleting-all-data-in-a-core-data-entity-in-swift-3
    @IBAction func btnRefreshCoreData(_ sender: UIBarButtonItem) {
        print("refresh core data")
        
        
        print(self.opgehaaldeStations[0].naam!)
        print(self.opgehaaldeStations[1].naam!)
        print(self.opgehaaldeStations[2].naam!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Vragen aan de gebruiker voor toegang tot locatie
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else{
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let url = URL(string: "https://api.jcdecaux.com/vls/v1/stations?apiKey=6d5071ed0d0b3b68462ad73df43fd9e5479b03d6&contract=Bruxelles-Capitale")
        let urlRequest = URLRequest(url: url!)
        
        let session = URLSession(configuration:
            URLSessionConfiguration.default)
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for errors
            guard error == nil else {
                print("error calling GET")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            print(responseData);
            
            do {
                guard let villoData =
                    try JSONSerialization.jsonObject(
                        with: responseData, options: [])
                        as? [AnyObject] else{
                            print("JSONSerialization failed")
                            return
                }
                //Aantal stations van villo, het zijn er 348
                //print((jsonVillo?.count)!)
                for villoStation in villoData {
                    
                    let station = NSEntityDescription.insertNewObject(forEntityName: "Station", into: managedContext) as! Station
                    station.naam = villoStation["name"] as? String
                    print("Dit is de stationsnaam: \(station.naam!)")
                    do {
                        try managedContext.save()
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                    
                  
                    
//                    //Naam van het station
//                    let nameStationJSON = villoStation["name"] as? String
//                    print(nameStationJSON!)
//
//                    //Coördinaten locatie van het station
//                    let coordinatesVilloStation = villoStation["position"] as? [String:AnyObject]
//                    let latitude = coordinatesVilloStation!["lat"] as? Double
//                    let longitude = coordinatesVilloStation!["lng"] as? Double
//                    print(latitude!)
//                    print(longitude!)
//
//                    //Annotation op coordinaten locatie van het station plaatsen
//                    let annotation = MKPointAnnotation()
//                    annotation.title = villoStation["name"] as? String
//                    annotation.coordinate = CLLocationCoordinate2D(latitude: latitude! , longitude: longitude! )
//                    self.mijnMapview.addAnnotation(annotation)
                    
                }
                let stationFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
                do {
                    self.opgehaaldeStations = try managedContext.fetch(stationFetch) as! [Station]
                    print ("uit coredata")
                    print(self.opgehaaldeStations[0].naam!)
                    print(self.opgehaaldeStations[1].naam!)
                    print(self.opgehaaldeStations[2].naam!)
                }
                catch {
                    fatalError("Failed to fetch stations: \(error)")
                }
                DispatchQueue.main.async {
                   //Hier moet je zetten voor de annotations weer te geven
                    }
                
            }
            catch {
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapview: MKMapView, didUpdate userLocation: MKUserLocation){
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let center = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center,span: span)
        mapview.setRegion(region,animated: true)
    }


}

