//
//  FilterType.swift
//  Tracker
//
//  Created by Kaider on 22.01.2025.
//

import Foundation

enum FilterType: String, CaseIterable {
    case allTrackers = "Все трекеры"
    case todayTrackers = "Трекеры на сегодня"
    case completedTrackers = "Завершенные"
    case uncompletedTrackers = "Не завершенные"
}
