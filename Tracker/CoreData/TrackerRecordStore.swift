//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Kaider on 28.12.2024.
//

import CoreData
import Foundation

final class TrackerRecordStore: NSObject {
    
    // MARK: - Properties
    
    private let context: NSManagedObjectContext
    
    // MARK: - Init
    
    convenience override init() {
        let context = PersistentContainer.shared.viewContext
        self.init(context: context)
        print("\(#file):\(#line)] \(#function) TrackerRecordStore инициализирован с дефолтным контекстом")
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        print("\(#file):\(#line)] \(#function) TrackerRecordStore инициализирован с переданным контекстом")
    }
    
    // MARK: - Methods
    
    func addNewRecord(_ record: TrackerRecord) throws {
        let recordCoreData = TrackerRecordCoreData(context: context)
        recordCoreData.id = record.id
        recordCoreData.date = record.date
        
        do {
            try context.save()
            print("\(#file):\(#line)] \(#function) Сохранена запись для трекера ID: \(record.id)")
        } catch {
            print("\(#file):\(#line)] \(#function) Ошибка сохранения записи: \(error)")
            throw error
        }
    }
    
    func fetchRecords() throws -> [TrackerRecord] {
        let request = TrackerRecordCoreData.fetchRequest()
        
        do {
            let recordsCoreData = try context.fetch(request)
            return try recordsCoreData.map { try record(from: $0) }
        } catch {
            print("\(#file):\(#line)] \(#function) Ошибка загрузки записей: \(error)")
            throw error
        }
    }
    
    private func record(from recordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard let id = recordCoreData.id,
              let date = recordCoreData.date else {
            throw TrackerRecordStoreError.decodingErrorInvalidData
        }
        
        return TrackerRecord(
            id: id,
            date: date
        )
    }
}

// MARK: - Errors

enum TrackerRecordStoreError: Error {
    case decodingErrorInvalidData
}

