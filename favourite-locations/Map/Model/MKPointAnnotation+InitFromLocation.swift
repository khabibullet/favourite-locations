//
//  MKPointAnnotation+InitFromLocation.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 14.02.2023.
//

import Foundation
import MapKit

extension MKPointAnnotation {
    convenience init(location: Location) {
        self.init()
        self.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        self.title = location.name
        self.subtitle = location.comment
    }
}
