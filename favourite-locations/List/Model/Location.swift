//
//  Location+CoreDataProperties.swift
//  
//
//  Created by Ирек Хабибуллин on 03.01.2023.
//
//

import Foundation
import CoreData

public class Location: NSManagedObject {
    static let entityName = "Location"
    
    static func coordinatesString(_ latitude: Double, _ longitude: Double) -> String {
        let northOrSouth = latitude > 0 ? "N" : "S"
        let eastOrWest = longitude > 0 ? "E" : "W"
        let coordinates = String(format: "%.2f°%@, %.2f°%@", abs(latitude), northOrSouth, abs(longitude), eastOrWest)
        return coordinates
    }
    
    var coordinates: String {
        return Location.coordinatesString(latitude, longitude)
    }
}

extension Location {
    @NSManaged public var comment: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String

}
