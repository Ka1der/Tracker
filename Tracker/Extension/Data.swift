//
//  Data.swift
//  Tracker
//
//  Created by Kaider on 03.12.2024.
//

import UIKit

struct TrackerData {
    let title: String
    let emoji: String
    let color: UIColor
}

private var trackers: [TrackerData] = [
    TrackerData(title: "Учеба", emoji: "📚", color: .systemBlue),
    TrackerData(title: "Спорт", emoji: "🏃‍♂️", color: .systemGreen),
    TrackerData(title: "Чтение", emoji: "📖", color: .systemRed)
    
]
