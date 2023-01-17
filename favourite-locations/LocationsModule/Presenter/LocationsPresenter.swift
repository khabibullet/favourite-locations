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
    func savePersistenceContext()
}

class LocationsPresenter: LocationsPresenterProtocol {
    var view: LocationsViewProtocol!
    var locations: [Location]!
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
        persistenceManager.fetchModelEntities(entityName: Location.entityName, ofType: Location.self) { (entities) in
            self.locations.append(contentsOf: entities)
            
            // Test data
            self.putTestLocations()
        }
    }
    
    
    var locationsWithPrefix: [Location] {
        return locations.filter { $0.name.hasPrefix(searchKey) }
    }
    
    func getLocationWithPrefixOnIndex(id: Int) -> Location {
        return locationsWithPrefix[id]
    }
    
    func getNumberOfLocationsWithPrefix() -> Int {
        return locationsWithPrefix.count
    }
    
    func savePersistenceContext() {
        persistenceManager.saveContext()
    }
    
    func addNewLocation() {
        
    }
}









extension LocationsPresenter {
    func putTestLocations() {
        if locations.count == 0 {
            let location1: Location = {
                let location = Location(context: self.persistenceManager.viewContext)
                location.name = "Kazan"
                location.longitude = -45.01
                location.latitude = -33.45
                // swiftlint:disable line_length
                location.comment = "The capital of Tatarstan. One of the most antient cities in Russia. There is one more sentence just to enlarge cell height."
                // swiftlint:enable line_length
                return location
            }()
            self.locations.append(contentsOf: [
                location1
            ])
        }
    }
}
