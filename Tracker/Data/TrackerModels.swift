//
//  TrackerModels.swift
//  Tracker
//
//  Created by Kaider on 04.12.2024.
//

import UIKit

// MARK: - Models

struct Tracker {
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let scheldue: Set<WeekDay>
    let isPinned: Bool
}

// MARK: - WeekDay

enum WeekDay: Int, CaseIterable {
    case monday = 1
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    var shortName: String {
        switch self {
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        case .sunday: return "Вс"
        }
    }
}

// MARK: - Supporting Types

struct TrackerRecord {
    let id: UUID // ID трекера
    let date: Date
}

struct TrackerCategory {
    let title: String
    let trackers: [Tracker]
}


