//
//  LocationsTrie+CoreDataProperties.swift
//  
//
//  Created by Ирек Хабибуллин on 29.12.2022.
//
//

import Foundation
import CoreData


extension LocationsTrie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationsTrie> {
        return NSFetchRequest<LocationsTrie>(entityName: "LocationsTrie")
    }

    @NSManaged public var count: Int64
    @NSManaged public var root: TrieNode?

}
