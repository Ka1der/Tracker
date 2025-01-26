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
    
    private lazy var placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "NothingNotFound")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Анализировать пока нечего"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func createMetricView(value: String, description: String) -> UIView {
        let container = GradientContainerView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 16
        container.clipsToBounds = true
        container.translatesAutoresizingMaskIntoConstraints = false

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 34, weight: .bold)
        valueLabel.textColor = .black
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.font = .systemFont(ofSize: 12, weight: .medium)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(valueLabel)
        container.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 90),

            valueLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            valueLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),

            descriptionLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),
            descriptionLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12)
        ])

        return container
    }
    
    final class GradientContainerView: UIView {
        private let gradientLayer = CAGradientLayer()

        override init(frame: CGRect) {
            super.init(frame: frame)
            setupGradient()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupGradient()
        }

        private func setupGradient() {
            gradientLayer.colors = [
                UIColor(red: 0.99, green: 0.3, blue: 0.29, alpha: 1).cgColor,
                UIColor(red: 0.27, green: 0.9, blue: 0.62, alpha: 1).cgColor,
                UIColor(red: 0, green: 0.48, blue: 0.98, alpha: 1).cgColor
            ]
            gradientLayer.locations = [0, 0.5, 1]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            layer.insertSublayer(gradientLayer, at: 0)
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            gradientLayer.frame = bounds
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        stackView.arrangedSubviews.forEach { view in
            if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
                gradientLayer.frame = view.bounds
            }
        }
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        view.addSubview(placeholderImageView)
        view.addSubview(placeholderLabel)
        
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
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            placeholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderImageView.widthAnchor.constraint(equalToConstant: 80),
            placeholderImageView.heightAnchor.constraint(equalToConstant: 80),
            
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8),
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        updatePlaceholderVisibility(!metrics.isEmpty)
    }
    
    private func updatePlaceholderVisibility(_ hasData: Bool) {
        placeholderImageView.isHidden = hasData
        placeholderLabel.isHidden = hasData
    }
}
