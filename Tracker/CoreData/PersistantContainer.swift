//
//  PersistantContainer.swift
//  Tracker
//
//  Created by Kaider on 26.12.2024.
//

import Foundation
import CoreData

final class PersistantContainer {
    
    // MARK: - Singleton
    
    static let shared = PersistantContainer()
    
    // MARK: - Persistent Container
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tracker")
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
}
