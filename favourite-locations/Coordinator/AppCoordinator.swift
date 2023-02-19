//
//  LocationsCoordinator.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 30.12.2022.
//

import UIKit
import MapKit

protocol CoordinatorProtocol: AnyObject {
    func start()
    func launchEditor(
        forLocation location: Location?,
        inLocations locations: [Location],
        withCompletion completion: @escaping (ActionOnComplete, LocationAdapter?) -> Void
    )
    func showMapInEditMode(completion: @escaping (Double, Double) -> Void)
    func showSingleLocation(location: Location)
}

class AppCoordinator: NSObject {
    let tabBarController: UITabBarController
    var locationsPresenter: LocationsPresenterProtocol!
    var mapPresenter: MapPresenterProtocol!
    var locationNavigationController: UINavigationController!
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
}


extension AppCoordinator: CoordinatorProtocol {
    
    func launchEditor(
        forLocation location: Location?,
        inLocations locations: [Location],
        withCompletion completion: @escaping (ActionOnComplete, LocationAdapter?) -> Void
    ) {
        let (editor, _) = ModuleBuilder.buildEditorModule(
            forLocation: location,
            inLocations: locations,
            withCompletion: completion,
            coordinator: self
        )
        editor.configureInitialState()
        guard let editor = editor as? UIViewController else { return }
        locationNavigationController.pushViewController(editor, animated: true)
    }
    
    func start() {
        let (locationsView, locationsPresenter) = ModuleBuilder.buildLocationsModule(coordinator: self)
        let (mapView, mapPresenter) = ModuleBuilder.buildMapModule(coordinator: self)
        
        guard
            let mapView = mapView as? UIViewController,
            let locationsView = locationsView as? UIViewController
        else { return }
        
        let navController = UINavigationController(rootViewController: locationsView)
        
        tabBarController.delegate = self
        tabBarController.setViewControllers([navController, mapView], animated: true)
        
        self.locationsPresenter = locationsPresenter
        self.mapPresenter = mapPresenter
        self.locationNavigationController = navController
    }
    
    func showMapInEditMode(completion: @escaping (Double, Double) -> Void) {
        let mapView = MapViewController()
        mapView.completion = completion
        mapView.setupEditMode()
        locationNavigationController.pushViewController(mapView, animated: true)
    }
    
    func showSingleLocation(location: Location) {
        let annotation = CustomAnnotation(location: location)
        mapPresenter.setAnnotation(pin: annotation)
        tabBarController.selectedIndex = 1
    }
}

extension AppCoordinator: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard viewController is MapViewController else { return true }
        let locations = locationsPresenter.getLocations()
        let annotations = locations.map({ CustomAnnotation(location: $0) })
        mapPresenter.setAnnotations(pins: annotations)

        return true
    }
    
}
