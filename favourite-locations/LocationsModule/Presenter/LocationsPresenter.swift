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
    func getLocationWithPrefixOnIndex(id: Int) -> Location
    func getNumberOfLocationsWithPrefix() -> Int
}

class LocationsPresenter: LocationsPresenterProtocol {
    var view: LocationsViewProtocol!
    var locations: [Location]
    let persistenceManager: PersistenceStoreManaged
    weak var coordinator: CoordinatorProtocol!
    var searchKey = ""
    
    init(view: LocationsViewProtocol, model: [Location], persistenceManager: PersistenceStoreManaged) {
        self.view = view
        self.locations = model
        self.persistenceManager = persistenceManager
        fetchLocations()
    }
    
    func fetchLocations() {
        persistenceManager.fetchModelEntities(entityName: Location.entityName) { [weak self] (entities) in
            self?.locations = entities
        }
    }
    
    var locationsWithPrefix: [Location] {
        return (locations as [Location]).filter { $0.name.hasPrefix(searchKey) }
    }
    
    func getLocationWithPrefixOnIndex(id: Int) -> Location {
        return locationsWithPrefix[id]
    }
    
    func getNumberOfLocationsWithPrefix() -> Int {
        return locationsWithPrefix.count
    }
}

