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
