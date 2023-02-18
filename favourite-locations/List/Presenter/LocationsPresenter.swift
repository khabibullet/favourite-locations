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
    func updateSearchResults(by newKey: String, completion: @escaping () -> Void)
    
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
    var locationsWithPrefix: [Location] {
        return locations.filter { $0.name.hasPrefix(searchPrefix) }
    }

    let searchQueue = OperationQueue()
    var searchOperation: Operation?
    var searchPrefix = ""

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
    
    func setSearchPrefix(to prefix: String) {
        searchPrefix = prefix
    }
    
    func containsLocation(withName name: String) -> Bool {
        return locations.contains(where: { $0.name == name })
    }
    
    func getLocations() -> [Location] {
        return locationsWithPrefix
    }
    
    func updateSearchResults(by newKey: String, completion: @escaping () -> Void) {
        
        searchQueue.cancelAllOperations()
        let searchOperation = BlockOperation()
        searchOperation.addExecutionBlock { [weak searchOperation] in
            sleep(2) // Synthetic delay to test time-consuming operations handling
            self.searchPrefix = newKey
            guard let operation = searchOperation, !operation.isCancelled else { return }
            OperationQueue.main.addOperation {
                completion()
            }
        }
        searchQueue.addOperation(searchOperation)
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
                    self.locationsView.reloadCell(at: index)
                } else {
                    self.locations.removeAll(where: { $0 === editedLocation })
                    self.locations.insertInAccending(editedLocation)
                    
                    if let newID = self.locationsWithPrefix.firstIndex(where: { $0 === editedLocation }) {
                        self.locationsView.moveCell(at: index, to: newID)
                    } else {
                        self.locationsView.removeCell(at: index)
                    }
                    
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
        
        locations.insertInAccending(location)
        
        if let newID = locationsWithPrefix.firstIndex(where: { $0 === location }) {
            locationsView.insertCell(at: newID)
        }
    }
    
    func removeLocation(at index: Int) {
        let locationToDelete = locationsWithPrefix[index]
        locations.removeAll(where: { $0 === locationToDelete })
        persistenceManager.viewContext.delete(locationToDelete)
        persistenceManager.saveContext()
    }
}
