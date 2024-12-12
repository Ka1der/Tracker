//
//  NewCategoryController.swift
//  Tracker
//
//  Created by Kaider on 12.12.2024.
//

import UIKit

final class NewCategoryController: UIViewController {
    
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
           label.font = .systemFont(ofSize: 12, weight: .medium)
           label.textColor = .gray
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
           view.backgroundColor = .white
           
           view.addSubview(titleLabel)
           view.addSubview(placeholderImageView)
           view.addSubview(placeholderLabel)
           view.addSubview(addCategoryButton)
           
           NSLayoutConstraint.activate([
               titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
               titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               
               placeholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               placeholderImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
               placeholderImageView.widthAnchor.constraint(equalToConstant: 80),
               placeholderImageView.heightAnchor.constraint(equalToConstant: 80),
               
               placeholderLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8),
               placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               
               addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
               addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
               addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
               addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
           ])
       }
       
       // MARK: - Actions
       
       @objc private func addCategoryButtonTapped() {
           print("\(#file):\(#line)] \(#function) Нажата кнопка добавления категории")
       }
   }
