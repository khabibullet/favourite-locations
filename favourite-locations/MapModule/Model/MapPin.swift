//
//  PinModel.swift
//  favourite-locations
//
//  Created by Irek Khabibullin on 8/18/22.
//

import MapKit

struct MapPin {
	let location: CLLocation
	let annotation: MKPointAnnotation
	
	init(_ title: String, _ description: String, _ latitude: Double, _ longitude: Double) {
		self.location = CLLocation(latitude: latitude, longitude: longitude)
		self.annotation = MKPointAnnotation()
		self.annotation.title = title
		self.annotation.subtitle = description
		self.annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
	}
}
