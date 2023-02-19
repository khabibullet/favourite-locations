//
//  MapPresenter.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 30.12.2022.
//

import Foundation
import MapKit


protocol MapPresenterProtocol: AnyObject {
    var view: MapViewProtocol! { get }
    func setAnnotations(pins: [CustomAnnotation])
    func setAnnotation(pin: CustomAnnotation)
}

class MapPresenter: MapPresenterProtocol {
    
    unowned var coordinator: CoordinatorProtocol!
    unowned var view: MapViewProtocol!
    
    var model: [CustomAnnotation]
    
    init(view: MapViewProtocol, model: [CustomAnnotation], coordinator: CoordinatorProtocol) {
        self.view = view
        self.model = model
        self.coordinator = coordinator
    }
    
    func setAnnotations(pins: [CustomAnnotation]) {
        model = pins
        view.replaceAnnotations(with: model)
    }
    
    func setAnnotation(pin: CustomAnnotation) {
        view.focusOnLocation(pin: pin)
    }
}
