//
//  LocationEditorPresenter.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 28.01.2023.
//

import Foundation

protocol LocationEditorPresenterProtocol: AnyObject {
    func getLocation() -> Location?
    func containsLocation(withName name: String) -> Bool
    func updateEditedLocation(latitude: Double, longitude: Double, comment: String?)
    func cancelEditing()
    func createLocation(with adapter: LocationAdapter)
    func coordinatesSettingInitiated(completion: @escaping (Double, Double) -> Void)
}

class LocationEditorPresenter: LocationEditorPresenterProtocol {
    
    let editorView: LocationsEditorProtocol
    unowned var coordinator: CoordinatorProtocol!
    
    let editedLocation: Location?
    let locations: [Location]
    
    var editCompletion: ((ActionOnComplete, LocationAdapter?) -> Void)
    
    init(
        view: LocationsEditorProtocol,
        model: [Location],
        entity: Location?,
        completion: @escaping ((ActionOnComplete, LocationAdapter?) -> Void),
        coordinator: CoordinatorProtocol
    ) {
        self.editorView = view
        self.locations = model
        self.editedLocation = entity
        self.editCompletion = completion
        self.coordinator = coordinator
    }
    
    func getLocation() -> Location? {
        return editedLocation
    }
    
    func containsLocation(withName name: String) -> Bool {
        return locations.contains(where: { $0.name == name })
    }
    
    func updateEditedLocation(latitude: Double, longitude: Double, comment: String?) {
        guard let editedLocation = editedLocation else {
            return
        }
        editedLocation.latitude = latitude
        editedLocation.longitude = longitude
        editedLocation.comment = comment
        editCompletion(.restore, nil)
    }
    
    func cancelEditing() {
        editCompletion(.cancel, nil)
    }
    
    func createLocation(with adapter: LocationAdapter) {
        editCompletion(.create, adapter)
    }
    
    func coordinatesSettingInitiated(completion: @escaping (Double, Double) -> Void) {
        coordinator.showMapInEditMode(completion: completion)
    }
}
