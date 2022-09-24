//
//  PinModel.swift
//  no-storyboard-launch
//
//  Created by Alebelly Nemesis on 8/18/22.
//

import MapKit

struct Pin {
	let title: String
	let description: String
	let latitude: Double
	let longitude: Double
	let location: CLLocation
	let annotation: MKPointAnnotation
	
	init(_ title: String, _ description: String, _ latitude: Double, _ longitude: Double) {
		self.title = title
		self.description = description
		self.latitude = latitude
		self.longitude = longitude
		self.location = CLLocation(latitude: latitude, longitude: longitude)
		self.annotation = MKPointAnnotation()
		self.annotation.title = title
		self.annotation.subtitle = description
		self.annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
	}
}
