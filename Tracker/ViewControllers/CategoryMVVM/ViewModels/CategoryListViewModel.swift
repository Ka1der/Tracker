//
//  CategoryListViewModel.swift
//  Tracker
//
//  Created by Kaider on 05.01.2025.
//

import Foundation

final class CategoryListViewModel: CategoryListViewModelProtocol {
    
    // MARK: - Types
    
    typealias UpdateHandler = ([CategoryViewModel]) -> Void
    typealias ErrorHandler = (Error) -> Void
    typealias EmptyStateHandler = (Bool) -> Void
    
    // MARK: - Properties
    
    private let trackerCategoryStore: TrackerCategoryStore
    private var categories: [TrackerCategory] = []
    private var selectedCategory: String?
    
    // MARK: - Bindings
    
    var onCategoriesUpdated: UpdateHandler?
    var onError: ErrorHandler?
    var onEmptyStateChanged: EmptyStateHandler?
    
    // MARK: - Init
    
    init(trackerCategoryStore: TrackerCategoryStore = TrackerCategoryStore(), selectedCategory: String? = nil) {
        self.trackerCategoryStore = trackerCategoryStore
        self.selectedCategory = selectedCategory
    }
    
    // MARK: - Methods
    
    func loadCategories() {
        do {
            categories = try trackerCategoryStore.fetchCategories()
            notifyUpdates()
            print("\(#file):\(#line)] \(#function) Загружено категорий: \(categories.count)")
        } catch {
            onError?(error)
            print("\(#file):\(#line)] \(#function) Ошибка загрузки категорий: \(error)")
        }
    }
    
    func deleteCategory(title: String) {
        do {
            try trackerCategoryStore.deleteCategory(title: title)
            if selectedCategory == title {
                selectedCategory = nil
            }
            loadCategories()
            print("\(#file):\(#line)] \(#function) Удалена категория: \(title)")
        } catch {
            onError?(error)
            print("\(#file):\(#line)] \(#function) Ошибка удаления категории: \(error)")
        }
    }
    
    func selectCategory(_ title: String) {
        selectedCategory = title
        notifyUpdates()
        print("\(#file):\(#line)] \(#function) Выбрана категория: \(title)")
    }
    
    func updateCategory(oldTitle: String, newTitle: String) {
        do {
            try trackerCategoryStore.updateCategory(oldTitle: oldTitle, newTitle: newTitle)
            if selectedCategory == oldTitle {
                selectedCategory = newTitle
            }
            loadCategories()
            print("\(#file):\(#line)] \(#function) Категория обновлена: \(oldTitle) -> \(newTitle)")
        } catch {
            onError?(error)
            print("\(#file):\(#line)] \(#function) Ошибка обновления категории: \(error)")
        }
    }
    
    private func notifyUpdates() {
        let viewModels = categories.map { category in
            CategoryViewModel(
                title: category.title,
                isSelected: category.title == selectedCategory
            )
        }
        onCategoriesUpdated?(viewModels)
        onEmptyStateChanged?(categories.isEmpty)
    }
}
