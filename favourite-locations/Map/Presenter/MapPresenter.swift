//
//  MapPresenter.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 30.12.2022.
//

import Foundation


protocol MapPresenterProtocol: AnyObject {
    var view: MapViewProtocol! { get }
    var coordinator: CoordinatorProtocol! { get set }
    func addMapPin(completionHandler: @escaping ((Double, Double)?) -> Void)
    func cancelPinAdding()
    func didAddPin(with coordinates: (Double, Double))
}

class MapPresenter: MapPresenterProtocol {
    var view: MapViewProtocol!
    let model: [MapPin]
    weak var coordinator: CoordinatorProtocol!
    
    var returnCoordinatesToEditor: (((Double, Double)?) -> Void)?
    
    init(view: MapViewProtocol, model: [MapPin]) {
        self.view = view
        self.model = model
    }
    
    func addMapPin(completionHandler: @escaping ((Double, Double)?) -> Void) {
        returnCoordinatesToEditor = completionHandler
        view.setupEditMode()
    }
    
    func cancelPinAdding() {
        returnCoordinatesToEditor?(nil)
        returnCoordinatesToEditor = nil
    }
    
    func didAddPin(with coordinates: (Double, Double)) {
        returnCoordinatesToEditor?(coordinates)
        returnCoordinatesToEditor = nil
        coordinator.didAddPin()
    }
}
