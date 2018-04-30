//
//  ViewController.swift
//  Jany_Ertveldt_multec_werkstuk2
//
//  Created by Jany Ertveldt on 27/04/18.
//  Copyright © 2018 Jany Ertveldt. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var location : CLLocation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Vragen aan de gebruiker voor toegang tot locatie
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
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
            
           
//                let coordinatesJSON = json!["coord"] as? [String: Double]
//                let latitude = coordinatesJSON!["lat"]
//                let longitude = coordinatesJSON!["lon"]
//                print(latitude!)
//                print(longitude!)
                
//                let temperatuur = json!["main"] as? [String: Double]
//                let temp = temperatuur!["temp"]
//                print(temp!)
//
//                let weathers = json!["weather"] as? [[String:Any]]
//                for weather in weathers! {
//                    print(weather["description"]!)
//                }
                
                
            do {
                let jsonVillo =
                    try JSONSerialization.jsonObject(
                        with: responseData, options: [])
                        as? [AnyObject]
                //Aantal stations van villo, het zijn er 348
                //print((jsonVillo?.count)!)
                
                for i in 0...4 {
                    let nameStationJSON = jsonVillo![i]["name"] as? String
                    print(nameStationJSON!)
                    
                    let coordinatesVilloStation = jsonVillo![i]["position"] as? [String:AnyObject]
                    let latitude = coordinatesVilloStation!["lat"] as? Double
                    let longitude = coordinatesVilloStation!["lng"] as? Double
                    print(latitude!)
                    print(longitude!)
                }
                
                DispatchQueue.main.async {
                    
                        
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


}

