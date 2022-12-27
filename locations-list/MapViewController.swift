//
//  MapViewController.swift
//  no-storyboard-launch
//
//  Created by Alebelly Nemesis on 8/18/22.
//

import UIKit
import MapKit
import CoreLocation

protocol NavigationDelegate: AnyObject {
	func centerLocation(_ location: CLLocation, regionRadius: CLLocationDistance)
}

class MapViewController: UIViewController, NavigationDelegate, MKMapViewDelegate {

	let mapView = MKMapView()
	var locationManager: CLLocationManager!
	let trackingButton = UIButton(type: UIButton.ButtonType.system) as UIButton
	let mapAppearanceSwitch = UISegmentedControl(items: ["Standard", "Satellite", "Hybrid"])
	var userPointAnnotation = MKPointAnnotation()
	
	override func viewDidLoad() {
		super.viewDidLoad()

		configureSegmentedBar(mapAppearanceSwitch)
		configureTrackingButton(trackingButton)
		addPointAnnotationPins()
		locationManager = CLLocationManager()
		locationManager.delegate = self
		locationManager.requestAlwaysAuthorization()
		locationManager.startUpdatingLocation()
		mapView.showsUserLocation = true
		mapView.delegate = self
		view = mapView
	}
	
	override init(nibName: String?, bundle: Bundle?) {
		super.init(nibName: nibName, bundle: bundle)
		
        tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "pin-symbol"), tag: 1)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
}

extension MapViewController: CLLocationManagerDelegate {
	
	func centerLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
		let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
			latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
		
		mapView.setRegion(coordinateRegion, animated: true)
	}

	@objc func centerMapOnUserButtonClicked () {
		if let location = locationManager.location?.coordinate {
			let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 400, longitudinalMeters: 400)
			mapView.setRegion(region, animated: true)
		}
	}
}

extension MapViewController {
	
	func configureTrackingButton(_ button: UIButton) {
		mapView.addSubview(button)
		
		button.setImage(UIImage(named: "location-fill"), for: .normal)
		button.addTarget(self, action: #selector(centerMapOnUserButtonClicked), for: .touchUpInside)
		
		button.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			button.centerYAnchor.constraint(equalTo: mapAppearanceSwitch.centerYAnchor),
			button.leadingAnchor.constraint(equalTo: mapAppearanceSwitch.trailingAnchor, constant: 20)
		])
	}

	func configureSegmentedBar (_ segmentedBar: UISegmentedControl) {
		mapView.addSubview(segmentedBar)

        segmentedBar.backgroundColor = UIColor(named: "mid-cyan")
		segmentedBar.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			segmentedBar.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
			segmentedBar.bottomAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.bottomAnchor, constant: -20)
		])
		
		segmentedBar.addTarget(self, action: #selector(changeMapType(_:)), for: .valueChanged)
	}

	@objc func changeMapType(_ segmentedControl: UISegmentedControl) {
		switch segmentedControl.selectedSegmentIndex {
		case 0:
			mapView.mapType = MKMapType.standard
		case 1:
			mapView.mapType = MKMapType.satellite
		case 2:
			mapView.mapType = MKMapType.hybrid
		default:
			break
		}
	}
	
	func addPointAnnotationPins () {
		places.forEach({ mapView.addAnnotation($0.annotation) })
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation.isEqual(mapView.userLocation) {
			return nil
		}
		let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "something")
		switch annotation.title {
		case "42 Paris":
			annotationView.markerTintColor = .blue
		case "21 Moscow":
			annotationView.markerTintColor = .red
		case "21 Kazan":
			annotationView.markerTintColor = .green
		case "21 Novosibirsk":
			annotationView.markerTintColor = .purple
		default:
			break
		}
		return annotationView
	}
}
