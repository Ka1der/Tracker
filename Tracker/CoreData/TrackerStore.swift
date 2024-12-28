//
//  TrackerStore.swift
//  Tracker
//
//  Created by Kaider on 28.12.2024.
//

import UIKit
import CoreData

final class TrackerStore {
    
    static let shared = TrackerCoreStore()
    private let context: NSManagedObjectContext
    private let fetchedResultsDelegate = TrackerCoreStoreFetchedResultsControllerDelegate()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.title, ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "categoryTitle",
            cacheName: nil
        )
        controller.delegate = fetchedResultsDelegate
        
        do {
            try controller.performFetch()
            print("\(#file):\(#line)] \(#function) Загрузка прошла успешно")
        } catch {
            print("\(#file):\(#line)] \(#function) Ошибка загрузки: \(error)")
        }
        
        return controller
    }()
    
    private init() {
        self.context = PersistentContainer.shared.viewContext
    }
}
