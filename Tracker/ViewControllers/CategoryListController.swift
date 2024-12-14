//
//  CategoryListController.swift
//  Tracker
//
//  Created by Kaider on 14.12.2024.
//

import UIKit

final class CategoryListController: UIViewController {
    
    var categories: [String] = ["Важное"] // Пока добавим только одну категорию для примера
    private var hasCategories: Bool = true
    weak var delegate: CategoryListControllerDelegate?
    private var selectedCategory: String?
    
    // MARK: - UI Elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "trackerPlaceholder")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно\nобъединить по смыслу"
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor(named: "backgroundGray")
        table.layer.cornerRadius = 16
        table.separatorStyle = .none
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        updateUI()
        tableView.reloadData()
        print("\(#file):\(#line)] \(#function) Загружено категорий: \(categories.count)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let numberOfRows = categories.count
        let rowHeight: CGFloat = 75
        let totalHeight = CGFloat(numberOfRows) * rowHeight
        tableView.frame.size.height = totalHeight
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(placeholderImageView)
        view.addSubview(placeholderLabel)
        view.addSubview(addCategoryButton)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            // Констрейнты для titleLabel
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Констрейнты для tableView
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Констрейнты для placeholderImageView
            placeholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderImageView.widthAnchor.constraint(equalToConstant: 80),
            placeholderImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Констрейнты для placeholderLabel
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8),
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Констрейнты для addCategoryButton
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        let numberOfRows = categories.count
        let rowHeight: CGFloat = 75 // Высота каждой ячейки
        let totalHeight = CGFloat(numberOfRows) * rowHeight
        tableView.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
    }
    
    private func updateUI() {
        hasCategories = !categories.isEmpty
        placeholderImageView.isHidden = hasCategories
        placeholderLabel.isHidden = hasCategories
        tableView.isHidden = !hasCategories
        
        if categories.count >= 2 {
            tableView.separatorStyle = .singleLine
        } else {
            tableView.separatorStyle = .none
        }
        print("\(#file):\(#line)] \(#function) Обновление UI. Есть категории: \(hasCategories)")
    }
    
    // MARK: - Actions
    
    @objc private func addCategoryButtonTapped() {
        let categoryNameController = CategoryNameController()
        let navigationController = UINavigationController(rootViewController: categoryNameController)
        navigationController.modalPresentationStyle = .automatic
        print("\(#file):\(#line)] \(#function) Переход к экрану создания новой категории")
        present(navigationController, animated: true)
    }
}

extension CategoryListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]
        cell.backgroundColor = .white
        cell.contentView.backgroundColor = UIColor(named: "backgroundGray")
        cell.selectionStyle = .none
        cell.contentView.layoutMargins = UIEdgeInsets(top: 15, left: 16, bottom: 15, right: 16)
        cell.preservesSuperviewLayoutMargins = false
        
        if let textLabel = cell.textLabel {
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                textLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                textLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                textLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16)
            ])
        }
        let heightConstraint = cell.contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 75)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true
        if indexPath.row == categories.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        print("\(#file):\(#line)] \(#function) Настроена ячейка категории: \(categories[indexPath.row]) для строки \(indexPath.row)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]
        delegate?.didSelectCategory(selectedCategory)
        delegate?.didUpdateCategories(categories)
        print("\(#file):\(#line)] \(#function) Выбрана категория: \(selectedCategory)")
        dismiss(animated: true)
    }
}

