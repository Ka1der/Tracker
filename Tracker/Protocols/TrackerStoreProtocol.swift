//
//  TrackerStoreProtocol.swift
//  Tracker
//
//  Created by Kaider on 29.12.2024.
//

import Foundation

protocol TrackerStoreProtocol {
    func createTracker(_ tracker: Tracker, category: TrackerCategory) throws
    func fetchTrackers() throws -> [Tracker]
    func deleteTracker(id: UUID) throws
    func countTrackers() -> Int
}
