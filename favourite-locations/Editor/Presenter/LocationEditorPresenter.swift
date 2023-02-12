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
    func complete(resultAction: ActionOnComplete, location: Location?)
}

class LocationEditorPresenter: LocationEditorPresenterProtocol {
    
    let editorView: LocationsEditorProtocol
    let editedLocation: Location?
    let locations: [Location]
    unowned var coordinator: CoordinatorProtocol!
    
    var editCompletion: ((ActionOnComplete, Location?) -> Void)
    
    init(
        view: LocationsEditorProtocol,
        model: [Location],
        entity: Location?,
        completion: @escaping ((ActionOnComplete, Location?) -> Void)
    ) {
        self.editorView = view
        self.locations = model
        self.editedLocation = entity
        self.editCompletion = completion
    }
    
    func getLocation() -> Location? {
        return editedLocation
    }
    
    func containsLocation(withName name: String) -> Bool {
        return locations.contains(where: { $0.name == name })
    }
    
    func complete(resultAction: ActionOnComplete, location: Location?) {
        
    }
}
