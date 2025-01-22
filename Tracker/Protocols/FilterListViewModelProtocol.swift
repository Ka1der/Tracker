//
//  FilterListViewModelProtocol.swift
//  Tracker
//
//  Created by Kaider on 22.01.2025.
//

import Foundation

protocol FilterListViewModelProtocol {
    var onFilterChanged: ((FilterType) -> Void)? { get set }
    var selectedFilter: FilterType { get }
    var filters: [FilterType] { get }
    func selectFilter(_ filter: FilterType)
}
