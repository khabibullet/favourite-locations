//
//  CustomAnnotation.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 18.02.2023.
//

import UIKit
import CoreLocation
import MapKit

class CustomAnnotation: MKPointAnnotation {

    static let reuseID = "Custom"
    
    override init() {
        super.init()
    }
    
    init(location: Location) {
        super.init()
        coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        title = location.name
        subtitle = location.comment
    }
}
