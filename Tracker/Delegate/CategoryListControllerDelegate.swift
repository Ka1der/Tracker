//
//  CategoryListControllerDelegate.swift
//  Tracker
//
//  Created by Kaider on 13.12.2024.
//

import Foundation

protocol CategoryListControllerDelegate: AnyObject {
    func didSelectCategory(_ category: String)
}
