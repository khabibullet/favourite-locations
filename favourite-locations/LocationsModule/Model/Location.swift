//
//  Location+CoreDataProperties.swift
//  
//
//  Created by Ирек Хабибуллин on 31.12.2022.
//
//

import Foundation
import CoreData

class Location: NSManagedObject {
    static let entityName = "Location"
}

extension Location {
    @NSManaged public var name: String
    @NSManaged public var comment: String?
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
}
