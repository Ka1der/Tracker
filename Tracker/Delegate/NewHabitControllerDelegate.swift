//
//  NewHabitControllerDelegate.swift
//  Tracker
//
//  Created by Kaider on 07.12.2024.
//
import Foundation

protocol NewHabitControllerDelegate: AnyObject {
    func didCreateTracker(_ tracker: Tracker, category: String)
}
