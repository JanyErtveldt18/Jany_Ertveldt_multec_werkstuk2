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
    
    @IBOutlet weak var lblStationsnaam: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let taalApparaat = NSLocale.preferredLanguages[0]
        //print(taalApparaat)
        
        if taalApparaat.contains("nl") {
            print("taal is Nederlands")
        } else if taalApparaat.contains("fr") {
            print("else if taal is Frans")
        }else if taalApparaat.contains("en") {
            print("else if taal is Engels")
        }
        
        let meegekregenstationsnaam = stationNaam
        //Splits zodat je enkel nummer en - en dan de rest hebt
        let spiltStationOpNummerArray = meegekregenstationsnaam?.components(separatedBy: "-")
        
        let nummer = spiltStationOpNummerArray![0]
        let restNaam = spiltStationOpNummerArray![1]
        print("Nummer: \(nummer)")
        print("Rest station: \(restNaam)")
        
        let spiltStationOpTaalArray = spiltStationOpNummerArray![1].components(separatedBy: "/")
        if spiltStationOpTaalArray.count>=2{
            let nederlands = spiltStationOpTaalArray[1]
            print("Nederlands: \(nederlands)")
        }else{
            let nederlands = spiltStationOpTaalArray[0]
            print("Nederlands: \(nederlands)")
        }
//        let frans = spiltStationOpTaalArray[0]
//        let nederlands = spiltStationOpTaalArray[1]
//        print("Frans: \(frans)")
//        print("Nederlands: \(nederlands)")
        
        
        //print("op detailpagina")
        self.lblStationsnaam.text = stationNaam
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
