//
//  LocationsPresenter.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 30.12.2022.
//

import Foundation

protocol LocationsPresenterProtocol: AnyObject {
    var coordinator: CoordinatorProtocol! { get set }
    var view: LocationsViewProtocol! { get }
    func saveManagedObjectContext()
}

class LocationsPresenter: LocationsPresenterProtocol {
    var view: LocationsViewProtocol!
    let locations: [Location]
    let persistenceManager: PersistenceStoreManaged
    weak var coordinator: CoordinatorProtocol!
    
    init(view: LocationsViewProtocol, model: [Location], persistenceManager: PersistenceStoreManaged) {
        self.view = view
        self.locations = model
        self.persistenceManager = persistenceManager
    }
    
    func saveManagedObjectContext() {
        
    }
}
