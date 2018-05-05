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
    @IBOutlet weak var lblLaatstBijgewerkt: UILabel!
    
    
    //let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let url = URL(string: "https://api.jcdecaux.com/vls/v1/stations?apiKey=6d5071ed0d0b3b68462ad73df43fd9e5479b03d6&contract=Bruxelles-Capitale")
    let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    
//    https://stackoverflow.com/questions/39920792/deleting-all-data-in-a-core-data-entity-in-swift-3
    @IBAction func btnRefreshCoreData(_ sender: UIBarButtonItem) {
        print("refresh core data")
        //Annotations wissen
        let alleAnnotationsOpDeMap = mijnMapview.annotations
        mijnMapview.removeAnnotations(alleAnnotationsOpDeMap)
        
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
                try managedContext.save()
            }
             laadVelloDataIn()
        }
        catch{
            fatalError("Failed to delete stations \(error)")
            
        }
        
        updateTijdBijRefresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            maakAnnotaionsAanOpMap()
            updateTijdBijRefresh()
            print("Not first launch.")
        } else {
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            laadVelloDataIn()
            
        }

    }

    func laadVelloDataIn(){
        
        print("laadVelloDataIn")
        //Vragen aan de gebruiker voor toegang tot locatie
        
        
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
                DispatchQueue.main.async {
                for villoStation in villoData {
                    //Stationsnaam
                    let station = NSEntityDescription.insertNewObject(forEntityName: "Station", into: self.managedContext!) as! Station
                    station.naam = villoStation["name"] as? String
                    
                    //Latitude en longitude
                    let coordinatesVilloStation = villoStation["position"] as? [String:AnyObject]
                    station.latitude = (coordinatesVilloStation!["lat"] as? Double)!
                    station.longitude = (coordinatesVilloStation!["lng"] as? Double)!
                   
                    //Aantal beschikbare fietsen
                    station.beschikbareFietsen = (villoStation["available_bikes"] as? Int16)!
                    
                    
                    //print("Dit is de stationsnaam: \(station.naam!) met latitude \(station.latitude) en longitude \(station.longitude)")
                    do {
                        try self.managedContext?.save()
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                }
                }
                let stationFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
                do {
                    self.opgehaaldeStations = try self.managedContext?.fetch(stationFetch) as! [Station]
                }
                catch {
                    fatalError("Failed to fetch stations: \(error)")
                }
                
                    self.maakAnnotaionsAanOpMap()
                    self.updateTijdBijRefresh()
                
            // print(villoData)
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
    
    func maakAnnotaionsAanOpMap(){
        DispatchQueue.main.async {
            let stationFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
            let nieuweOpgehaaldeStations:[Station]
            do{
                nieuweOpgehaaldeStations = try self.managedContext?.fetch(stationFetch) as! [Station]
                //Annotation op coordinaten locatie van het station plaatsen
                for villoStationData in nieuweOpgehaaldeStations {
                    let annotation = MKPointAnnotation()
                    annotation.title = villoStationData.naam
                    annotation.subtitle = "Aantal vrije fietsen: \(villoStationData.beschikbareFietsen)"
                    annotation.coordinate = CLLocationCoordinate2D(latitude:villoStationData.latitude , longitude: villoStationData.longitude )
                    self.mijnMapview.addAnnotation(annotation)
                    }
                
            
            }
            catch{
                
            }
        }
       
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
//        if let title = annotation.title, title == "My Location" || title == "Mijn locatie" || title == "Ma position"{
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "user")
//             annotationView?.image = UIImage(named: "user")
//        }
        if annotation is MKUserLocation {
            return nil
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
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        DispatchQueue.main.async {
//            let stationFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
//            let nieuweOpgehaaldeStations:[Station]
//            do{
//                nieuweOpgehaaldeStations = try self.managedContext?.fetch(stationFetch) as! [Station]
//                let toTableViewController = segue.destination as! TableViewController
//                print(nieuweOpgehaaldeStations)
//                toTableViewController.opslagStations = nieuweOpgehaaldeStations
//            }catch{
//
//            }
//        }
//    }

    func updateTijdBijRefresh(){
        DispatchQueue.main.async {
            //Bron voor current time te tonen als men refresht
            //https://blog.apoorvmote.com/convert-date-to-string-vice-versa-in-swift/
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MM/dd/yy h:mm a"
            let now = dateformatter.string(from: NSDate() as Date)
            self.lblLaatstBijgewerkt?.text = "Laatst bijgewerkt: \(now)"
        }
    }

    @IBAction func btnGaNaarTableController(_ sender: UIBarButtonItem) {
        gaNaarTableControllerEnVulOp()
    }
    
    func gaNaarTableControllerEnVulOp(){
        DispatchQueue.main.async {
            let stationFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
            let nieuweOpgehaaldeStations:[Station]
                do{
                    nieuweOpgehaaldeStations = try self.managedContext?.fetch(stationFetch) as! [Station]
                    let tableController = self.storyboard?.instantiateViewController(withIdentifier: "tableControllerID") as! TableViewController
                    tableController.opslagStations = nieuweOpgehaaldeStations
                    self.navigationController?.pushViewController(tableController, animated: true)
                }catch{
                    
            }
        }
        
    }
    
    
    

}

