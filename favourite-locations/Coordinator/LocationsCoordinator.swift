//
//  LocationsCoordinator.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 30.12.2022.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {
    func addMapPin(completionHandler: @escaping ((Double, Double)?) -> Void)
    func didAddPin()
}

class LocationsCoordinator: NSObject {
    unowned var tabBarController: UITabBarController
    unowned var locationsPresenter: LocationsPresenterProtocol
    unowned var mapPresenter: MapPresenterProtocol
    unowned var editorPresenter: LocationEditorPresenterProtocol
    
    init(
        locationsPresenter: LocationsPresenterProtocol,
        mapPresenter: MapPresenterProtocol,
        editorPresenter: LocationEditorPresenterProtocol,
        tabBarController: UITabBarController
    ) {
        self.locationsPresenter = locationsPresenter
        self.mapPresenter = mapPresenter
        self.tabBarController = tabBarController
        super.init()
    }
}

extension LocationsCoordinator: CoordinatorProtocol {
    
    func addMapPin(completionHandler: @escaping ((Double, Double)?) -> Void) {
        mapPresenter.addMapPin(completionHandler: completionHandler)
        print("here")
        tabBarController.selectedIndex = 1
    }
    
    func didAddPin() {
        tabBarController.selectedIndex = 0
    }
}
