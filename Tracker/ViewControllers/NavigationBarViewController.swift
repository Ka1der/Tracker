//
//  NavigationBarViewController.swift
//  Tracker
//
//  Created by Kaider on 30.11.2024.
//

import UIKit

final class NavigationBarViewController: UIViewController  {
    
    private var selectedCell: TrackerCell?
    
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
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.identifier)
        
        collectionView.register(UICollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")
        collectionView.register(UICollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: "footer")
        
        return collectionView
    }()
    
    var trackers: [TrackerData] = [
        TrackerData(title: "Медитация", emoji: "🧘‍♂️", color: .white),
        TrackerData(title: "Спорт", emoji: "🏃‍♂️", color: .white),
        TrackerData(title: "Чтение", emoji: "📚", color: .white),
        TrackerData(title: "Сон", emoji: "😴", color: .white),
        TrackerData(title: "Английский", emoji: "📖", color: .white)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigationBar()
        setupPlaceholder()
        setupCollectionView()
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
}

extension NavigationBarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Убираем выделение с предыдущей ячейки
        selectedCell?.titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        
        // Выделяем новую ячейку
        let cell = collectionView.cellForItem(at: indexPath) as? TrackerCell
        cell?.titleLabel.font = .boldSystemFont(ofSize: 17)
        
        // Сохраняем ссылку на выделенную ячейку
        selectedCell = cell
    }
}
