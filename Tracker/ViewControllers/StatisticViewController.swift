//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Kaider on 24.01.2025.
//

import Foundation

import UIKit

final class StatisticViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Статистика"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private func createMetricView(value: String, description: String) -> UIView {
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 16
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 34, weight: .bold)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.font = .systemFont(ofSize: 12, weight: .medium)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0.99, green: 0.3, blue: 0.29, alpha: 1).cgColor,
            UIColor(red: 0.27, green: 0.9, blue: 0.62, alpha: 1).cgColor,
            UIColor(red: 0, green: 0.48, blue: 0.98, alpha: 1).cgColor
        ]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        container.addSubview(valueLabel)
        container.addSubview(descriptionLabel)
        
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.systemGray4.cgColor
        
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 90),
            
            valueLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            valueLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            
            descriptionLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),
            descriptionLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12)
        ])
        
        return container
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        
        let metrics = [
            ("6", "Лучший период"),
            ("2", "Идеальные дни"),
            ("5", "Трекеров завершено"),
            ("4", "Среднее значение")
        ]
        
        metrics.forEach { value, description in
            stackView.addArrangedSubview(createMetricView(value: value, description: description))
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
