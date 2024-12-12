//
//  NavigationBarViewController.swift
//  Tracker
//
//  Created by Kaider on 30.11.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Properties
    
    var filteredCategories: [TrackerCategory] = []
    private var selectedCell: TrackerCell?
    var categories: [TrackerCategory] = []
    var currentDate: Date = Date()
    var completedTrackers: [TrackerRecord] = []
    
    private let dateFormatter: DateFormatter = {
         let formatter = DateFormatter()
         formatter.dateFormat = "dd.MM.yy"
         formatter.locale = Locale(identifier: "ru")
         return formatter
     }()
    
    // MARK: - UI Elements
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "plusButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = UIFont(name: "SFPro-Bold", size: 34) ?? UIFont.systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = .clear
        return searchBar
    }()
    
    private lazy var placeholderStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isHidden = true
        return stack
    } ()
    
    private lazy var placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "trackerPlaceholder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.textColor = .label
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ru_RU")
        picker.calendar.firstWeekday = 2
        picker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        picker.tintColor = .blue
 
        if let textLabel = picker.subviews.first?.subviews.first as? UILabel {
            textLabel.font = .systemFont(ofSize: 17)
        }
        return picker
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.identifier)
        collectionView.register(
            SupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header"
        )
        collectionView.register(
            SupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: "footer"
        )
        return collectionView
    }()
    
     // MARK: - Lifecycle
    
    override func viewDidLoad() {
         super.viewDidLoad()
         setupViews()
         setupNavigationBar()
         setupPlaceholder()
         setupCollectionView()
         updatePlaceholderVisibility()
     }
     
     // MARK: - Setup Methods
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        placeholderStack.addArrangedSubview(placeholderImageView)
        placeholderStack.addArrangedSubview(placeholderLabel)
        view.addSubview(placeholderStack)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        let addButton = UIButton(frame: CGRect(x: 6, y: 0, width: 42, height: 42))
        addButton.setImage(UIImage(named: "plusButton"), for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        let addBarButton = UIBarButtonItem(customView: addButton)
        let dateBarButton = UIBarButtonItem(customView: datePicker)
        navigationItem.leftBarButtonItem = addBarButton
        navigationItem.rightBarButtonItem = dateBarButton
        print("\(#file):\(#line)] \(#function) Настроен NavigationBar с DatePicker")
    }

    private func setupPlaceholder() {
        
        placeholderStack.isHidden = false
        
        NSLayoutConstraint.activate([
            placeholderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderImageView.widthAnchor.constraint(equalToConstant: 80),
            placeholderImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setupCollectionView() {
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func addButtonTapped() {
        let newTrackerController = NewTrackerController()
        newTrackerController.delegate = self
        let navigationController = UINavigationController(rootViewController: newTrackerController)
        navigationController.modalPresentationStyle = .automatic
        present(navigationController, animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        let formattedDate = dateFormatter.string(from: sender.date)
        print("\(#file):\(#line)] \(#function) Выбрана дата: \(formattedDate)")
        
        filteredCategories = filterTrackersByDate(currentDate)
        collectionView.reloadData()
        updatePlaceholderVisibility()
    }
    
    // MARK: - Private Methods
    
    private func updatePlaceholderVisibility() {
        let hasVisibleTrackers = !filteredCategories.isEmpty
        
        placeholderStack.isHidden = hasVisibleTrackers
        collectionView.isHidden = !hasVisibleTrackers
        
        print("\(#file):\(#line)] \(#function) Всего трекеров: \(categories.count), Видимых трекеров: \(filteredCategories.count)")
    }
    
    private func isFutureDate(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let checkDate = calendar.startOfDay(for: date)
        return checkDate > today
    }
    
    private func setupDatePickerFormat() {
           datePicker.locale = Locale(identifier: "ru_RU")
           var calendar = Calendar.current
           calendar.locale = Locale(identifier: "ru_RU")
           datePicker.calendar = calendar
       }
    
    private func filterTrackersByDate(_ date: Date) -> [TrackerCategory] {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let adjustedWeekday = WeekDay(rawValue: weekday == 1 ? 7 : weekday - 1) ?? .monday
        
        print("\(#file):\(#line)] \(#function) Фильтрация для даты: \(date), день недели: \(adjustedWeekday.shortName)")
        
        let filteredCategories = categories.compactMap { category in
            let filteredTrackers = category.trackers.filter { tracker in
                let shouldDisplay = tracker.scheldue.contains(adjustedWeekday)
                print("\(#file):\(#line)] \(#function) Трекер '\(tracker.title)': расписание [\(tracker.scheldue.map { $0.shortName }.joined(separator: ", "))], отображать: \(shouldDisplay)")
                return shouldDisplay
            }
            
            return filteredTrackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: filteredTrackers)
        }
        
        print("\(#file):\(#line)] \(#function) Найдено категорий после фильтрации: \(filteredCategories.count)")
        return filteredCategories
    }
    
    // MARK: - TrackerManagement
    
    func addTrackerRecord(_ tracker: Tracker, date: Date) {
        let record = TrackerRecord(id: tracker.id, date: date)
        completedTrackers.append(record)
        collectionView.reloadData()
    }
    
    func removeTrackerRecord(_ tracker: Tracker, date: Date) {
        completedTrackers.removeAll { record in
            record.id == tracker.id && Calendar.current.isDate(record.date, inSameDayAs: date)
        }
        collectionView.reloadData()
    }
    
    func isTrackerCompleted(_ tracker: Tracker, date: Date) -> Bool {
        completedTrackers.contains { record in
            record.id == tracker.id && Calendar.current.isDate(record.date, inSameDayAs: date)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension TrackersViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell?.titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        let cell = collectionView.cellForItem(at: indexPath) as? TrackerCell
        cell?.titleLabel.font = .boldSystemFont(ofSize: 17)
        selectedCell = cell
        print("\(#file):\(#line)] \(#function) Выделена ячейка: \(indexPath.item)")
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] suggestedActions in
            let pinAction = UIAction(title: "Закрепить", image: UIImage(systemName: "pin")) { [weak self] _ in
                print("\(#file):\(#line)] \(#function) Закрепить трекер")
            }
            
            let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { [weak self] _ in
                print("\(#file):\(#line)] \(#function) Редактировать трекер")
            }
            
            let deleteAction = UIAction(
                title: "Удалить",
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { [weak self] _ in
                guard let self = self else { return }
                let alert = UIAlertController(
                    title: "Удалить трекер?",
                    message: "Эта операция не может быть отменена",
                    preferredStyle: .alert
                )
                
                alert.addAction(UIAlertAction(title: "Отменить", style: .cancel))
                alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
                    self?.deleteTracker(at: indexPath)
                })
                
                self.present(alert, animated: true)
            }
            
            return UIMenu(title: "", children: [pinAction, editAction, deleteAction])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? TrackerCell {
            cell.titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        }
        selectedCell = nil
        print("\(#file):\(#line)] \(#function) Снято выделение с ячейки: \(indexPath.item)")
    }
    
    func countCompletedDays(for tracker: Tracker) -> Int {
        completedTrackers.filter { $0.id == tracker.id }.count
    }
}

// MARK: - NewHabitControllerDelegate

extension TrackersViewController: NewHabitControllerDelegate {
    func didCreateTracker(_ tracker: Tracker, category: String) {
        if let index = categories.firstIndex(where: { $0.title == category }) {
            var updatedCategory = categories[index]
            var updatedTrackers = updatedCategory.trackers
            updatedTrackers.append(tracker)
            categories[index] = TrackerCategory(title: category, trackers: updatedTrackers)
        } else {
            categories.append(TrackerCategory(title: category, trackers: [tracker]))
        }
        filteredCategories = filterTrackersByDate(currentDate)
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.updatePlaceholderVisibility()
            print("\(#file):\(#line)] \(#function) Трекер добавлен. Всего категорий: \(self.categories.count), Отфильтрованных: \(self.filteredCategories.count)")
        }
    }
}

extension TrackersViewController {
    
    func addTracker(_ tracker: Tracker, to categoryTitle: String) {
        if let categoryIndex = categories.firstIndex(where: { $0.title == categoryTitle }) {
            var updatedTrackers = categories[categoryIndex].trackers
            updatedTrackers.append(tracker)
            categories[categoryIndex] = TrackerCategory(title: categoryTitle, trackers: updatedTrackers)
            print("\(#file):\(#line)] \(#function) Добавлен трекер \(tracker.title) в категорию \(categoryTitle)")
        } else {
            let newCategory = TrackerCategory(title: categoryTitle, trackers: [tracker])
            categories.append(newCategory)
            
            print("\(#file):\(#line)] \(#function) Создана новая категория \(categoryTitle) с трекером \(tracker.title)")
        }
        
        collectionView.reloadData()
        updatePlaceholderVisibility()
    }
    
    func deleteTracker(at indexPath: IndexPath) {
        let categoryIndex = indexPath.section
        let trackerIndex = indexPath.item
        
        guard categoryIndex < categories.count,
              trackerIndex < categories[categoryIndex].trackers.count else {
            print("\(#file):\(#line)] \(#function) Ошибка: некорректный индекс для удаления")
            return
        }
        
        let tracker = categories[categoryIndex].trackers[trackerIndex]
        completedTrackers.removeAll { $0.id == tracker.id }
        var updatedTrackers = categories[categoryIndex].trackers
        updatedTrackers.remove(at: trackerIndex)
        
        if updatedTrackers.isEmpty {
            categories.remove(at: categoryIndex)
            print("\(#file):\(#line)] \(#function) Удалена пустая категория")
        } else {
            categories[categoryIndex] = TrackerCategory(title: categories[categoryIndex].title, trackers: updatedTrackers)
        }
        
        print("\(#file):\(#line)] \(#function) Удален трекер: \(tracker.title)")
        
        collectionView.reloadData()
        updatePlaceholderVisibility()
    }
}
