//
//  TrieNode+CoreDataProperties.swift
//  
//
//  Created by Ирек Хабибуллин on 29.12.2022.
//
//

import Foundation
import CoreData


extension TrieNode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrieNode> {
        return NSFetchRequest<TrieNode>(entityName: "TrieNode")
    }

    @NSManaged public var char: String?
    @NSManaged public var children: NSOrderedSet?
    @NSManaged public var location: Location?
    @NSManaged public var parent: TrieNode?

}

// MARK: Generated accessors for children
extension TrieNode {

    @objc(insertObject:inChildrenAtIndex:)
    @NSManaged public func insertIntoChildren(_ value: TrieNode, at idx: Int)

    @objc(removeObjectFromChildrenAtIndex:)
    @NSManaged public func removeFromChildren(at idx: Int)

    @objc(insertChildren:atIndexes:)
    @NSManaged public func insertIntoChildren(_ values: [TrieNode], at indexes: NSIndexSet)

    @objc(removeChildrenAtIndexes:)
    @NSManaged public func removeFromChildren(at indexes: NSIndexSet)

    @objc(replaceObjectInChildrenAtIndex:withObject:)
    @NSManaged public func replaceChildren(at idx: Int, with value: TrieNode)

    @objc(replaceChildrenAtIndexes:withChildren:)
    @NSManaged public func replaceChildren(at indexes: NSIndexSet, with values: [TrieNode])

    @objc(addChildrenObject:)
    @NSManaged public func addToChildren(_ value: TrieNode)

    @objc(removeChildrenObject:)
    @NSManaged public func removeFromChildren(_ value: TrieNode)

    @objc(addChildren:)
    @NSManaged public func addToChildren(_ values: NSOrderedSet)

    @objc(removeChildren:)
    @NSManaged public func removeFromChildren(_ values: NSOrderedSet)

}
