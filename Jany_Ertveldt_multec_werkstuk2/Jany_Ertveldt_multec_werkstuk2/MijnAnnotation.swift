//
//  MijnAnnotation.swift
//  Jany_Ertveldt_multec_werkstuk2
//
//  Created by Jany Ertveldt on 7/05/18.
//  Copyright © 2018 Jany Ertveldt. All rights reserved.
//

import MapKit

class MijnAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var beschikbareFietsen: Int64?
    
    init(title:String?, subtitle:String?,coordinate: CLLocationCoordinate2D,beschikbareFietsen:Int64?){
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.beschikbareFietsen = beschikbareFietsen
    }
    
}
