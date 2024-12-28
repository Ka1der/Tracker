//
//  PersistantContainer.swift
//  Tracker
//
//  Created by Kaider on 26.12.2024.
//

import Foundation
import CoreData

final class PersistentContainer {
    
    // MARK: - Singleton
    
    static let shared = PersistentContainer()
    
    // MARK: - Persistent Container
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataTracker")
        container.loadPersistentStores{ description, error in
            if let error = error as NSError? {
                fatalError("Ошибка загрузки хранилища CoreData: \(error), \(error.userInfo)")
            } else {
                print("Хранилище CoreData успешно загружено")
            }
        }
        return container
    }()
    
    // MARK: - View Context
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    // MARK: - Background Context
    
    func newBackgroundContext() -> NSManagedObjectContext {
        return container.newBackgroundContext()
    }
    
    // MARK: - Save Context
 
    func saveContext(context: NSManagedObjectContext? = nil) {
        let contextToSave = context ?? viewContext
        
        guard contextToSave.hasChanges else { return }
        
        do {
            try contextToSave.save()
            print("Context успешно сохранен")
        } catch {
            let nserror = error as NSError
            print("Ошибка сохранения контекста: \(nserror), \(nserror.userInfo)")
        }
    }
}
