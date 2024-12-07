//
//  NavigationBarViewController.swift
//  Tracker
//
//  Created by Kaider on 30.11.2024.
//

import UIKit

final class TrackersViewController: UIViewController  {
    
    private var selectedCell: TrackerCell?
    var categories: [TrackerCategory] = []
    var currentDate: Date = Date()
    var completedTrackers: [TrackerRecord] = []
    
    private lazy var navigationBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
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
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateButton: UIButton = {
        let button = UIButton()
        button.setTitle("14.15.20", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(named: "dataButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
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
        label.text = "Что будеем отлеживать?"
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ru_RU")
        picker.calendar.firstWeekday = 2
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigationBar()
        setupPlaceholder()
        setupCollectionView()
        setupDateFormatter()
        setupTestData()
        updatePlaceholderVisibility()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(navigationBar)
        view.addSubview(addButton)
        view.addSubview(titleLabel)
        view.addSubview(dateButton)
        view.addSubview(searchBar)
        placeholderStack.addArrangedSubview(placeholderImageView)
        placeholderStack.addArrangedSubview(placeholderLabel)
        view.addSubview(placeholderStack)
        view.addSubview(collectionView)
    }
    
    private func setupNavigationBar() {
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 88),
            
            addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            addButton.topAnchor.constraint(equalTo: navigationBar.topAnchor, constant: 8),
            
            dateButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            dateButton.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
            dateButton.heightAnchor.constraint(equalToConstant: 34),
            dateButton.widthAnchor.constraint(equalToConstant: 77),
            
            titleLabel.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 1),
            
            searchBar.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -16),
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
        ])
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
    
    @objc private func addButtonTapped() {
        print("\(#file):\(#line)] \(#function) Plus button tapped")
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        collectionView.reloadData()
        updatePlaceholderVisibility()
        print("\(#file):\(#line)] \(#function) Выбрана дата: \(sender.date)")
    }
    
    private func updatePlaceholderVisibility() {
        let hasTrackers = categories.contains { !$0.trackers.isEmpty }
        placeholderStack.isHidden = hasTrackers
        collectionView.isHidden = !hasTrackers
        
        print("\(#file):\(#line)] \(#function) Статус отображения заглушки: \(!hasTrackers)")
    }
    
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
    
    private func setupTestData() {
        let testTrackers = [
            Tracker(
                id: UUID(), title: "Учеба", color: .systemBlue, emoji: "📚", scheldue: Set([.monday, .friday, .saturday]), isPinned: false),
            Tracker(
                id: UUID(), title: "Спорт", color: .systemGreen, emoji: "🏃‍♂️", scheldue: Set([ .friday, .saturday, .tuesday]), isPinned: false),
        ]
        
        categories = [TrackerCategory(title: "Важное", trackers: testTrackers)]
        collectionView.reloadData()
       // placeholder написать скрытие
        print("\(#file):\(#line)] \(#function) Добавлены тестовые данные: \(categories.count) категорий")
    }
}

extension TrackersViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell?.titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        let cell = collectionView.cellForItem(at: indexPath) as? TrackerCell
        cell?.titleLabel.font = .boldSystemFont(ofSize: 17)
        selectedCell = cell
        print("\(#file):\(#line)] \(#function) Выделена ячейка: \(indexPath.item)")
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            let pinAction = UIAction(title: "Закрепить", image: UIImage(systemName: "pin")) { [weak self] _ in
                print("\(#file):\(#line)] \(#function) Закрепить трекер")
            }
            
            let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { [weak self] _ in
                print("\(#file):\(#line)] \(#function) Редактировать трекер")
            }
            
            let deleteAction = UIAction(title: "Удалить",
                                        image: UIImage(systemName: "trash"),
                                        attributes: .destructive) { [weak self] _ in
                print("\(#file):\(#line)] \(#function) Удалить трекер")
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
    
    private func setupDateFormatter() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        dateButton.setTitle(dateFormatter.string(from: currentDate), for: .normal)
    }
    
}
