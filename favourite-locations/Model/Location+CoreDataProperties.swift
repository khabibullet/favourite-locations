//
//  Location+CoreDataProperties.swift
//  
//
//  Created by Ирек Хабибуллин on 29.12.2022.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var comment: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var node: TrieNode?

}
