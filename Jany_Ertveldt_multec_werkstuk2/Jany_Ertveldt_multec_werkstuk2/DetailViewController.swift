//
//  DetailViewController.swift
//  Jany_Ertveldt_multec_werkstuk2
//
//  Created by Jany Ertveldt on 2/05/18.
//  Copyright © 2018 Jany Ertveldt. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var stationNaam:String?
    var aantalBeschikbareFietsen:String?
     
    @IBOutlet weak var lblStationsnaam: UILabel!
    @IBOutlet weak var lblAantalBeschikbareFietsen: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblStationsnaam.text = stationNaam
        self.lblAantalBeschikbareFietsen.text = "\(aantalBeschikbareFietsen!)"
//
//        lblAantalBeschikbareFietsen?.text = aantalBeschikbareFietsen
//
//        let taalApparaat = NSLocale.preferredLanguages[0]
//        //print(taalApparaat)
//
//        let meegekregenstationsnaam = stationNaam
//        //Splits zodat je enkel nummer en - en dan de rest hebt
//        let splitStationOpNummerArray = meegekregenstationsnaam?.components(separatedBy: "-")
//
//        //        let nummer = splitStationOpNummerArray![0]
//        //        let restNaam = splitStationOpNummerArray![1]
//        //        print("Nummer: \(nummer)")
//        //        print("Rest station: \(restNaam)")
//
//        let splitStationOpTaalArray = splitStationOpNummerArray![1].components(separatedBy: "/")
//
//
//        if taalApparaat.contains("nl") {
//            print("taal is Nederlands")
//            if splitStationOpTaalArray.count>=2{
//                let nederlands = splitStationOpTaalArray[1]
//                print("groter als 2: \(nederlands)")
//                self.lblStationsnaam.text = nederlands
//            }else{
//                let nederlands = splitStationOpTaalArray[0]
//                print("anders: \(nederlands)")
//                self.lblStationsnaam.text = nederlands
//            }
//        } else if taalApparaat.contains("fr") {
//            print("taal is Frans")
//            if splitStationOpTaalArray.count>=2{
//                let frans = splitStationOpTaalArray[0]
//                print("groter als 2: \(frans)")
//                self.lblStationsnaam.text = frans
//            }else{
//                let frans = splitStationOpTaalArray[0]
//                print("anders: \(frans)")
//                self.lblStationsnaam.text = frans
//            }
//        }else if taalApparaat.contains("en") {
//            print("taal is Engels")
//        }
//
        
        
        
        
        
        
        
        
//        let frans = spiltStationOpTaalArray[0]
//        let nederlands = spiltStationOpTaalArray[1]
//        print("Frans: \(frans)")
//        print("Nederlands: \(nederlands)")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
