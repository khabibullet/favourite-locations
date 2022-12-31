//
//  PersistenceManager.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 29.12.2022.
//

import Foundation
import CoreData

// MARK: - Core Data stack

protocol PersistenceStoreManaged {
    var persistentContainer: NSPersistentContainer { get }
    var viewContext: NSManagedObjectContext { get }
    func saveContext()
}

class PersistenceManager: PersistenceStoreManaged {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Locations")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var viewContext = persistentContainer.viewContext
    
    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
