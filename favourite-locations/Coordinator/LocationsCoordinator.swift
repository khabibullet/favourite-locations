//
//  LocationsCoordinator.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 30.12.2022.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {
    var tabBarController: UITabBarController! { get }
    func addMapPin(completionHandler: @escaping ((Double, Double)?) -> Void)
    func didAddPin()
}

class LocationsCoordinator: NSObject {
    var tabBarController: UITabBarController!
    let locationsPresenter: LocationsPresenterProtocol
    let mapPresenter: MapPresenterProtocol
    
    init(locationsPresenter: LocationsPresenterProtocol, mapPresenter: MapPresenterProtocol, tabBarController: UITabBarController) {
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
