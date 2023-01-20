//
//  LocationsCoordinator.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 30.12.2022.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {
    var tabBarController: UITabBarController! { get }
}

class LocationsCoordinator: NSObject, CoordinatorProtocol {
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

extension LocationsCoordinator: UITabBarControllerDelegate {
    
}
