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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else{
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let stationFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
        do{
            let opgehaaldeStations = try managedContext.fetch(stationFetch) as! [Station]
            
            for station in opgehaaldeStations {
                managedContext.delete(station)
            }
            
            // Save Changes
            try managedContext.save()
            //laadVelloDataIn()
        }
        catch{
            fatalError("Failed to delete stations \(error)")
            
        }
        
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        laadVelloDataIn()
    }

    func laadVelloDataIn(){
        print("laadVelloDataIn")
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
                    
                    //Stationsnaam
                    let station = NSEntityDescription.insertNewObject(forEntityName: "Station", into: managedContext) as! Station
                    station.naam = villoStation["name"] as? String
                    
                    //Latitude en longitude
                    let coordinatesVilloStation = villoStation["position"] as? [String:AnyObject]
                    station.latitude = (coordinatesVilloStation!["lat"] as? Double)!
                    station.longitude = (coordinatesVilloStation!["lng"] as? Double)!
                   
                    //Aantal beschikbare fietsen
                    station.beschikbareFietsen = (villoStation["available_bikes"] as? Int16)!
                    
                    
                    print("Dit is de stationsnaam: \(station.naam!) met latitude \(station.latitude) en longitude \(station.longitude)")
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
                    //                    //Aantal fietsen per station
                    //                    let bike_stands = villoStation["bike_stands"] as? Int
                    //                     print(bike_stands!)
                    //
                    //                    //Aantal beschikbare fietsen per station
                    //                    let available_bike_stands = villoStation["available_bike_stands"] as? Int
                    //                    print(available_bike_stands!)
                    //
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
                    //Annotation op coordinaten locatie van het station plaatsen
                    for villoStationData in self.opgehaaldeStations {
                        let annotation = MKPointAnnotation()
                        annotation.title = villoStationData.naam
                        annotation.subtitle = "Aantal vrije fietsen: \(villoStationData.beschikbareFietsen)"
                        annotation.coordinate = CLLocationCoordinate2D(latitude:villoStationData.latitude , longitude: villoStationData.longitude )
                        self.mijnMapview.addAnnotation(annotation)
                        
                    }
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
    
    //Tutorial voor custom annotations
    //https://www.youtube.com/watch?v=936-KHll9Ao
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView")
       
        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "fietsmarker")
            annotationView?.image = UIImage(named: "fietsmarker")
            let calloutButton = UIButton(type: .infoDark)
            annotationView!.rightCalloutAccessoryView = calloutButton
            annotationView!.sizeToFit()
        }
        if let title = annotation.title, title == "My Location" {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "user")
             annotationView?.image = UIImage(named: "user")
        }
        
        annotationView?.canShowCallout = true
        
        return annotationView
       
    }
    
    //Tutorial voor het klikken op de annoatations
    //https://www.youtube.com/watch?v=agXeo1PApq8
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        print("Je klikte op: \((view.annotation?.title!)!)")
//
//    }
    
    //Bron voor data door te sturen naar een andere controller zonder segue 
 //   https://stackoverflow.com/questions/15270085/pass-data-between-view-controllers-without-segues
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let detailViewConroller = self.storyboard?.instantiateViewController(withIdentifier: "detailViewControllerID") as! DetailViewController
            detailViewConroller.stationNaam = (view.annotation?.title)!
            self.navigationController?.pushViewController(detailViewConroller, animated: true)
           
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let toTableViewController = segue.destination as! TableViewController
        toTableViewController.opslagStations = opgehaaldeStations
    }


}

