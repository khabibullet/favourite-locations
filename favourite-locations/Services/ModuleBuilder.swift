//
//  ModuleBuilder.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 30.12.2022.
//

import UIKit
import MapKit
import CoreData

protocol Builder {
    
}

class ModuleBuilder: Builder {
    static func buildLocationsModule(coordinator: CoordinatorProtocol) -> (LocationsViewProtocol, LocationsPresenterProtocol) {
        
        let dataModelName = "LocationsDataModel"
        let persistenceManager = PersistenceManager(dataModelName: dataModelName)
        
//        createTestLocations(with: persistenceManager)
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
        
        let model: [CustomAnnotation] = []
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

func createTestLocations(with persistenceManager: PersistenceManager) {
    for _ in (0...100) {
        let str = String.random(of: 4)
        let location = Location(context: persistenceManager.viewContext)
        location.name = str
        location.latitude = 10.0
        location.longitude = 10.0
        persistenceManager.saveContext()
    }
}

extension String {
   static func random(of n: Int) -> String {
      let digits = "abcdefghijklmnopqrstuvwxyz"
      return String(Array(0..<n).map { _ in digits.randomElement()! })
   }
}
