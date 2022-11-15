//
//  CoreDataStack.swift
//  tawktoTest
//
//  Created by Superman on 15/11/2022.
//

import CoreData

class CoreDataStack {
    private let modelName: String

    init(modelName: String) {
        self.modelName = modelName
        self.privateMOC.parent = self.managedContext
    }

    lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    lazy var managedContext: NSManagedObjectContext = self.storeContainer.viewContext
    
    let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)

    func saveContext() {
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func synchronize() {
        do {
            try self.privateMOC.save() // We call save on the private context, which moves all of the changes into the main queue context without blocking the main queue.
            self.managedContext.performAndWait {
                do {
                    try self.managedContext.save()
                } catch {
                    print("Could not synchonize data. \(error), \(error.localizedDescription)")
                }
            }
        } catch {
            print("Could not synchonize data. \(error), \(error.localizedDescription)")
        }
    }
}
