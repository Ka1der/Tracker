//
//  Tracker.swift
//  Tracker
//
//  Created by Kaider on 04.12.2024.
//

import UIKit

struct Tracker {
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let scheldue: Set<WeekDay>
    let isPinned: Bool
}
