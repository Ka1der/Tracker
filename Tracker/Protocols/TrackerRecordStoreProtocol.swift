//
//  TrackerRecordStoreProtocol.swift
//  Tracker
//
//  Created by Kaider on 29.12.2024.
//

import Foundation

protocol TrackerRecordStoreProtocol {
    func addNewRecord(_ record: TrackerRecord) throws
    func fetchRecords() throws -> [TrackerRecord]
}
