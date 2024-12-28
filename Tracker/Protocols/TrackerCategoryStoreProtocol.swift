//
//  TrackerCategoryStoreProtocol.swift
//  Tracker
//
//  Created by Kaider on 29.12.2024.
//

import Foundation

protocol TrackerCategoryStoreProtocol {
    func createCategory(_ category: TrackerCategory) throws
    func fetchCategories() throws -> [TrackerCategory]
}
