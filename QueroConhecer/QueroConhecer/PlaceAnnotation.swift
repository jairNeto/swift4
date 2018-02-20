//
//  PlaceAnnotation.swift
//  QueroConhecer
//
//  Created by Jair Guedes Ferreira Neto on 8/2/18.
//  Copyright © 2018 Pay Back $istemas. All rights reserved.
//

import Foundation
import MapKit


class PlaceAnnotation: NSObject, MKAnnotation {
    
    enum PlaceType {
        case place
        case poi
    }
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var type: PlaceType
    var address: String?
    
    init(coordinates: CLLocationCoordinate2D, type: PlaceType) {
        self.coordinate = coordinates
        self.type = type
    }
}
