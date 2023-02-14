//
//  ModuleBuilder.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 30.12.2022.
//

import UIKit
import MapKit

protocol Builder {
    
}

class ModuleBuilder: Builder {
    static func buildLocationsModule(coordinator: CoordinatorProtocol) -> (LocationsViewProtocol, LocationsPresenterProtocol) {
        
        let dataModelName = "LocationsDataModel"
        let persistenceManager = PersistenceManager(dataModelName: dataModelName)
        
        let model: [Location] = []
        let view = LocationsViewController()
        let presenter = LocationsPresenter(
            view: view,
            model: model,
            persistenceManager: persistenceManager,
            coordinator: coordinator
        )
        
        view.presenter = presenter
        
        return (view, presenter)
    }
    
    static func buildMapModule(coordinator: CoordinatorProtocol) -> (MapViewProtocol, MapPresenterProtocol) {
        
        let model: [MKPointAnnotation] = []
        let view = MapViewController()
        view.setupPresentationMode()
        let presenter = MapPresenter(view: view, model: model, coordinator: coordinator)
        
        view.presenter = presenter
        
        return (view, presenter)
    }
    
    static func buildEditorModule(
        forLocation location: Location?,
        inLocations locations: [Location],
        withCompletion completion: @escaping ((ActionOnComplete, LocationAdapter?) -> Void),
        coordinator: CoordinatorProtocol
    ) -> (LocationsEditorProtocol, LocationEditorPresenterProtocol) {
        let model = locations
        let view = LocationEditorView()
        let presenter = LocationEditorPresenter(
            view: view,
            model: model,
            entity: location,
            completion: completion,
            coordinator: coordinator
        )
        
        view.presenter = presenter
        
        return (view, presenter)
    }
}
