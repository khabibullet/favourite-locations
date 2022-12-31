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
}

class MapPresenter: MapPresenterProtocol {
    var view: MapViewProtocol!
    let model: [MapPin]
    weak var coordinator: CoordinatorProtocol!
    
    init(view: MapViewProtocol, model: [MapPin]) {
        self.view = view
        self.model = model
    }
    
    
}
