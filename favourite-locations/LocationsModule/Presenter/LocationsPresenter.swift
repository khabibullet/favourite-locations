//
//  LocationsPresenter.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 30.12.2022.
//

import Foundation
import UIKit

protocol LocationsPresenterProtocol: AnyObject {
    var coordinator: CoordinatorProtocol! { get set }
    var view: LocationsViewProtocol! { get }
    func getLocationWithPrefixOnIndex(id: Int) -> Location
    func getNumberOfLocationsWithPrefix() -> Int
    func containsLocation(withName name: String) -> Bool
    func createLocation(name: String, coordinates: (latitude: Double, longitude: Double), comment: String?)
    func restoreLocation(name: String, coordinates: (latitude: Double, longitude: Double), comment: String?)
    func removeLocation(byName name: String)
    func removeLocation(at index: Int)
    func replaceLocation(oldName: String, name: String, coordinates: (latitude: Double, longitude: Double), comment: String?)
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
    
    func containsLocation(withName name: String) -> Bool {
        return locations.contains(where: { $0.name == name })
    }
    
    func createLocation(name: String, coordinates: (latitude: Double, longitude: Double), comment: String?) {
        let location = Location(context: persistenceManager.viewContext)
        location.name = name
        location.latitude = coordinates.latitude
        location.longitude = coordinates.longitude
        location.comment = comment
        persistenceManager.saveContext()
        let index = locations.insertIndexInAccending(location)
        locations.insert(location, at: index)
        view.insertLocation(at: index)
    }
    
    func removeLocation(byName name: String) {
        guard let index = locations.firstIndex(where: { $0.name == name }) else { return }
        removeLocation(at: index)
    }
    
    func removeLocation(at index: Int) {
        persistenceManager.viewContext.delete(locations[index])
        locations.remove(at: index)
        view.removeLocation(at: index)
        persistenceManager.saveContext()
    }
    
    func restoreLocation(name: String, coordinates: (latitude: Double, longitude: Double), comment: String?) {
        guard let index = locations.firstIndex(where: { $0.name == name }) else { return }
        let location = locations[index]
        location.latitude = coordinates.latitude
        location.longitude = coordinates.longitude
        location.comment = comment
        persistenceManager.saveContext()
        view.updateLocation(at: index)
    }
    
    func replaceLocation(oldName: String, name: String, coordinates: (latitude: Double, longitude: Double), comment: String?) {
        removeLocation(byName: oldName)
        createLocation(name: name, coordinates: coordinates, comment: comment)
    }
}
