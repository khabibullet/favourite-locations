//
//  LocationsPresenter.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 30.12.2022.
//

import Foundation
import UIKit

protocol LocationsPresenterProtocol: AnyObject {
    func addLocationViaEditor()
    func editLocationViaEditor(location index: Int)
    
    func getLocationWithPrefixOnIndex(id: Int) -> Location
    func getNumberOfLocationsWithPrefix() -> Int
    func containsLocation(withName name: String) -> Bool
    func getLocations() -> [Location]
    
    func createLocation(newLocation: LocationAdapter)
    func removeLocation(at index: Int)
}

enum ActionOnComplete {
    case create
    case restore
    case cancel
}

class LocationsPresenter {
    unowned var locationsView: LocationsViewProtocol
    unowned var coordinator: CoordinatorProtocol!
    private let persistenceManager: PersistenceStoreManaged

    var locations: [Location]
    var searchKey = ""
    
    var locationsWithPrefix: [Location] {
        return locations.filter { $0.name.hasPrefix(searchKey) }
    }
    
    init(
        view: LocationsViewProtocol,
        model: [Location],
        persistenceManager: PersistenceStoreManaged,
        coordinator: CoordinatorProtocol
    ) {
        self.locationsView = view
        self.locations = model
        self.persistenceManager = persistenceManager
        self.coordinator = coordinator
        fetchLocations()
    }
    
    func fetchLocations() {
        persistenceManager.fetchModelEntities(entityName: Location.entityName, ofType: Location.self) { (entities) in
            self.locations.append(contentsOf: entities)
        }
    }
}

extension LocationsPresenter: LocationsPresenterProtocol {
    
    
    func getLocationWithPrefixOnIndex(id: Int) -> Location {
        return locationsWithPrefix[id]
    }
    
    func getNumberOfLocationsWithPrefix() -> Int {
        return locationsWithPrefix.count
    }
    
    func containsLocation(withName name: String) -> Bool {
        return locations.contains(where: { $0.name == name })
    }
    
    func getLocations() -> [Location] {
        return locationsWithPrefix
    }
    
    func addLocationViaEditor() {
        coordinator.launchEditor(forLocation: nil, inLocations: locations) { (action, location) in
            switch action {
            case .create:
                guard let location = location else { return }
                self.createLocation(newLocation: location)
            case .cancel, .restore:
                return
            }
        }
    }
    
    func editLocationViaEditor(location index: Int) {
        let editedLocation = getLocationWithPrefixOnIndex(id: index)
        let oldName = editedLocation.name
        coordinator.launchEditor(forLocation: editedLocation, inLocations: locations) { (action, _) in
            switch action {
            case .restore:
                if editedLocation.name == oldName {
                    self.locationsView.updateLocation(at: index)
                } else {
                    self.locations.remove(at: index)
                    self.locationsView.removeLocation(at: index)
                    let newID = self.locations.insertIndexInAccending(editedLocation)
                    self.locations.insert(editedLocation, at: newID)
                    self.locationsView.insertLocation(at: newID)
                }
                self.persistenceManager.saveContext()
            case .cancel, .create:
                return
            }
        }
    }
    
    func createLocation(newLocation: LocationAdapter) {
        let location = Location(context: persistenceManager.viewContext)
        location.name = newLocation.name
        location.latitude = newLocation.latitude
        location.longitude = newLocation.longitude
        location.comment = newLocation.comment
        persistenceManager.saveContext()
        let index = locations.insertIndexInAccending(location)
        locations.insert(location, at: index)
        locationsView.insertLocation(at: index)
    }
    
    func removeLocation(at index: Int) {
        persistenceManager.viewContext.delete(locations[index])
        locations.remove(at: index)
        locationsView.removeLocation(at: index)
        persistenceManager.saveContext()
    }
}
