//
//  ModuleBuilder.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 30.12.2022.
//

import UIKit

protocol Builder {
    
}

class ModuleBuilder: Builder {
    static func buildLocationsModule() -> (LocationsViewProtocol, LocationsPresenterProtocol) {
        
        let dataModelName = "LocationsDataModel"
        let persistenceManager = PersistenceManager(dataModelName: dataModelName)
        
        let model: [Location] = []
        let view = LocationsViewController()
        let presenter = LocationsPresenter(view: view, model: model, persistenceManager: persistenceManager)
        
        view.presenter = presenter
        
        return (view, presenter)
    }
    
    static func buildMapModule() -> (MapViewProtocol, MapPresenterProtocol) {
        
        let model: [MapPin] = []
        let view = MapViewController()
        let presenter = MapPresenter(view: view, model: model)
        
        view.presenter = presenter
        
        return (view, presenter)
    }
    
    static func buildEditorModule(
        forLocation location: Location?,
        inLocations locations: [Location],
        withCompletion completion: @escaping ((ActionOnComplete, Location?) -> Void)
    ) -> (LocationsEditorProtocol, LocationEditorPresenterProtocol) {
        let model = locations
        let view = LocationEditorView()
        let presenter = LocationEditorPresenter(
            view: view,
            model: model,
            entity: location,
            completion: completion
        )
        
        view.presenter = presenter
        
        return (view, presenter)
    }
}
