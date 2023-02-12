//
//  LocationsCoordinator.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 30.12.2022.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {
    func start()
    func launchEditor(
        forLocation location: Location?,
        inLocations locations: [Location],
        withCompletion completion: @escaping (ActionOnComplete, Location?) -> Void
    )
    func showMapInEditMode()
    func showMapInPresentationMode()
}

class AppCoordinator {
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
        withCompletion completion: @escaping (ActionOnComplete, Location?) -> Void
    ) {
        let (editor, _) = ModuleBuilder.buildEditorModule(
            forLocation: location, inLocations: locations, withCompletion: completion
        )
        editor.configureInitialState()
        guard let editor = editor as? UIViewController else { return }
        locationNavigationController.pushViewController(editor, animated: true)
    }
    
    func start() {
        let (locationsView, locationsPresenter) = ModuleBuilder.buildLocationsModule()
        let (mapView, mapPresenter) = ModuleBuilder.buildMapModule()
        
        guard
            let mapView = mapView as? UIViewController,
            let locationsView = locationsView as? UIViewController
        else { return }
        
        let navController = UINavigationController(rootViewController: locationsView)
        
        tabBarController.setViewControllers([navController, mapView], animated: false)
        
        self.locationsPresenter = locationsPresenter
        self.mapPresenter = mapPresenter
        self.locationNavigationController = navController
    }
    
    func showMapInEditMode() {
        
    }
    
    func showMapInPresentationMode() {
        
    }
}
