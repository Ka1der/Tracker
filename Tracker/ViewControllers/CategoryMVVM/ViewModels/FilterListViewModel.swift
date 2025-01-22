//
//  FilterListViewModel.swift
//  Tracker
//
//  Created by Kaider on 22.01.2025.
//

import Foundation

final class FilterListViewModel: FilterListViewModelProtocol {
    
    // MARK: - Properties
    
    var onFilterChanged: ((FilterType) -> Void)?
    private(set) var selectedFilter: FilterType = .todayTrackers
    let filters: [FilterType] = FilterType.allCases
    
    // MARK: - Methods
    
    func selectFilter(_ filter: FilterType) {
        selectedFilter = filter
        onFilterChanged?(filter)
        print("\(#file):\(#line)] \(#function) Выбран фильтр: \(filter.rawValue)")
    }
}
