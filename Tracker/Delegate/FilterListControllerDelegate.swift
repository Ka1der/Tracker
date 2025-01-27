//
//  FilterListControllerDelegate.swift
//  Tracker
//
//  Created by Kaider on 22.01.2025.
//

import Foundation

protocol FilterListControllerDelegate: AnyObject {
    func didSelectFilter(_ filter: FilterType)
}
