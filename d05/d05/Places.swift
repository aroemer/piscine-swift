//
//  Places.swift
//  d05
//
//  Created by Audrey ROEMER on 4/2/18.
//  Copyright © 2018 Audrey ROEMER. All rights reserved.
//

import UIKit
import MapKit

struct Place {
    var locationName: String
    var locationDesc: String
    var coordinate: CLLocationCoordinate2D
    var color: UIColor
    
    static var places: [Place] = [
        Place(locationName: "42", locationDesc: "My School", coordinate: CLLocationCoordinate2D(latitude: 48.896649, longitude:2.318350), color: .orange),
        Place(locationName: "Home", locationDesc: "is where Floppy lives", coordinate: CLLocationCoordinate2D(latitude: 48.914326, longitude: 2.324946), color: .cyan),
        Place(locationName: "42US", locationDesc: "My other school", coordinate: CLLocationCoordinate2D(latitude: 37.548700, longitude: -122.058975), color: .magenta)
    ]
    
}


    



