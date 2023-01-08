//
//  ModuleBuilder.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 30.12.2022.
//

import UIKit

protocol Builder {
    
}

class ModuleBuilder: Builder {
    static func buildLocationsModule() -> LocationsPresenterProtocol {
        
        let dataModelName = "LocationsDataModel"
        let persistenceManager = PersistenceManager(dataModelName: dataModelName)
        let view = LocationsViewController()
        let model: [Location] = []
        let presenter = LocationsPresenter(view: view, model: model, persistenceManager: persistenceManager)
        view.presenter = presenter
        return presenter
    }
    
    static func buildMapModule() -> MapPresenterProtocol {
        
        let view = MapViewController()
        let model: [MapPin] = []
        let presenter = MapPresenter(view: view, model: model)
        view.presenter = presenter
        return presenter
    }
    
    static func buildCoordinator(locationsPresenter: LocationsPresenterProtocol, mapPresenter: MapPresenterProtocol) -> CoordinatorProtocol {
        let tabBarController = UITabBarController()
        if let locationsView = locationsPresenter.view as? UIViewController {
            let navigationController = UINavigationController(rootViewController: locationsView)
            tabBarController.addChild(navigationController)
        }
        if let mapView = mapPresenter.view as? UIViewController {
            tabBarController.addChild(mapView)
        }
        let coordinator = LocationsCoordinator(locationsPresenter: locationsPresenter, mapPresenter: mapPresenter, tabBarController: tabBarController)
        locationsPresenter.coordinator = coordinator
        mapPresenter.coordinator = coordinator
        return coordinator
    }
}
