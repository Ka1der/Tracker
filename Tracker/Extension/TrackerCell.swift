//
//  TrackerCell.swift
//  Tracker
//
//  Created by Kaider on 01.12.2024.
//

import UIKit

final class TrackerCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier: String = "TrackerCell"
    private var completedDaysCount: Int = 0
    private var currentDate: Date?
    private var tracker: Tracker?
    private var isCompleted: Bool = false
    private var completionHandler: (() -> Void)?
    
    // MARK: - UI Elements
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emojiView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.3)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var completeButton: UIButton = {
        let button = UIButton(type: .system) // Изменяем тип кнопки
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 34, weight: .medium, scale: .medium)
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: largeConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }
    
    // MARK: - Setup Methods
    
    private func setupViews() {
        contentView.addSubview(cardView)
        cardView.addSubview(emojiView)
        emojiView.addSubview(emojiLabel)
        cardView.addSubview(titleLabel)
        contentView.addSubview(completeButton)
        contentView.addSubview(counterLabel)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            emojiView.heightAnchor.constraint(equalToConstant: 24),
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor),
            
            titleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            
            completeButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 8),
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            completeButton.heightAnchor.constraint(equalToConstant: 34),
            completeButton.widthAnchor.constraint(equalToConstant: 34),
            
            counterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            counterLabel.centerYAnchor.constraint(equalTo: completeButton.centerYAnchor),
        ])
        print("\(#file):\(#line)] \(#function) Обновлено положение заголовка трекера")
        print("\(#file):\(#line)] \(#function) Размеры кнопки: frame = \(completeButton.frame), bounds = \(completeButton.bounds)")
    }
    
    // MARK: - Actions
    
    @objc private func completeButtonTapped() {
        guard let tracker = self.tracker,
              let currentDate = self.currentDate else { return }
        
        if isFutureDate(currentDate) {
            print("\(#file):\(#line)] \(#function) Нельзя отметить трекер на будущую дату")
            return
        }
        
        isCompleted.toggle()
        setCompletedState(isCompleted)
        completedDaysCount += isCompleted ? 1 : -1
        counterLabel.text = "\(completedDaysCount) дней"
        completionHandler?()
        
        print("\(#file):\(#line)] \(#function) Изменено состояние трекера: \(tracker.title), выполнено: \(isCompleted)")
    }
    
    // MARK: - Private Methods
    
    private func isFutureDate(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let selectedDate = calendar.startOfDay(for: date)
        return selectedDate > today
    }
    
    // MARK: - Public Methods
    
    func setCompletedState(_ isCompleted: Bool) {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 34, weight: .medium, scale: .medium)
        let imageName = isCompleted ? "checkmark.circle.fill" : "plus.circle.fill"
        let image = UIImage(systemName: imageName, withConfiguration: largeConfig)
        completeButton.setImage(image, for: .normal)
        
        if isCompleted {
              completeButton.alpha = 0.3
          } else {
              completeButton.alpha = 1.0
          }
        
        print("\(#file):\(#line)] \(#function) Обновлено состояние кнопки: \(isCompleted ? "выполнено" : "не выполнено")")
    }
    
    func configureCompletionHandler(
        tracker: Tracker,
        isCompleted: Bool,
        completionHandler: @escaping () -> Void
    ) {
        self.tracker = tracker
        self.isCompleted = isCompleted
        self.completionHandler = completionHandler
        setCompletedState(isCompleted)
    }
    
    func configure(with tracker: Tracker, currentDate: Date, completedDaysCount: Int, isCompleted: Bool) {
        self.tracker = tracker
        self.currentDate = currentDate
        self.completedDaysCount = completedDaysCount
        self.isCompleted = isCompleted
        
        titleLabel.text = tracker.title
        emojiLabel.text = tracker.emoji
        cardView.backgroundColor = tracker.color
        completeButton.tintColor = tracker.color
        counterLabel.text = "\(completedDaysCount) дней"
        setCompletedState(isCompleted)
        
        print("\(#file):\(#line)] \(#function) Настройка ячейки трекера: \(tracker.title), дата: \(currentDate)")
    }
}


