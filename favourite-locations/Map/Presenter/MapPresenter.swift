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
    func setAnnotations(pins: [MKPointAnnotation])
}

class MapPresenter: MapPresenterProtocol {
    
    unowned var coordinator: CoordinatorProtocol!
    unowned var view: MapViewProtocol!
    
    var model: [MKPointAnnotation]
    
    init(view: MapViewProtocol, model: [MKPointAnnotation], coordinator: CoordinatorProtocol) {
        self.view = view
        self.model = model
        self.coordinator = coordinator
    }
    
    func setAnnotations(pins: [MKPointAnnotation]) {
        model = pins
        view.replaceAnnotations(with: model)
    }
}
