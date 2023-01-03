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
}

extension Location {
    @NSManaged public var comment: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String

}
