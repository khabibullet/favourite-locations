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
    func fetchModelEntities<T: NSFetchRequestResult>(entityName: String, sendToPresenter: @escaping ([T]) -> ())
    func saveContext()
}

class PersistenceManager: PersistenceStoreManaged {
    
    let dataModelName: String
    
    init(dataModelName: String) {
        self.dataModelName = dataModelName
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: dataModelName)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var viewContext = persistentContainer.viewContext
    
    func fetchModelEntities<T: NSFetchRequestResult>(entityName: String, sendToPresenter: @escaping ([T]) -> ()) {
        let request = NSFetchRequest<T>(entityName: entityName)
        request.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: true)]
        do {
            let entities = try viewContext.fetch(request)
            sendToPresenter(entities)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
 
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
