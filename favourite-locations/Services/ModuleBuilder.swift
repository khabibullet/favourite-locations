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
//        let model: [MapPin] = []
        let model: [MapPin] = [
            MapPin("42 Paris", "42 School Paris", 48.896564659174146, 2.3184473544617554),
            MapPin("21 Moscow", "21 School Moscow", 55.797105887723944, 37.579932542997845),
            MapPin("21 Kazan", "21 School Kazan", 55.78190204770252, 49.125016281629364),
            MapPin("21 Novosibirsk", "21 School Novosibirsk", 54.97996176014704, 82.89746381284534)
        ]
        let presenter = MapPresenter(view: view, model: model)
        view.presenter = presenter
        return presenter
    }
    
    static func buildCoordinator(locationsPresenter: LocationsPresenterProtocol, mapPresenter: MapPresenterProtocol) -> CoordinatorProtocol {
        let tabBarController = UITabBarController()
        tabBarController.addChild(locationsPresenter.view as! UIViewController)
        tabBarController.addChild(mapPresenter.view as! UIViewController)
        let coordinator = LocationsCoordinator(locationsPresenter: locationsPresenter, mapPresenter: mapPresenter, tabBarController: tabBarController)
        locationsPresenter.coordinator = coordinator
        mapPresenter.coordinator = coordinator
        return coordinator
    }
}
