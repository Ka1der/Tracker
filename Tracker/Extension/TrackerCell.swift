//
//  TrackerCell.swift
//  Tracker
//
//  Created by Kaider on 01.12.2024.
//

import UIKit

final class TrackerCell: UICollectionViewCell {
    
    static let identifier: String = "TrackerCell"
    
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
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var tracker: Tracker?
    private var isCompleted: Bool = false
    private var completionHandler: (() -> Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }
    
    private func setupViews() {
        contentView.addSubview(cardView)
        cardView.addSubview(emojiView)
        emojiView.addSubview(emojiLabel)
        cardView.addSubview(titleLabel)
        contentView.addSubview(completeButton)
        
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
            
            titleLabel.topAnchor.constraint(equalTo: emojiView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            
            completeButton.centerYAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            completeButton.heightAnchor.constraint(equalToConstant: 34),
            completeButton.widthAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    func configure(with tracker: Tracker) {
        titleLabel.text = tracker.title
        emojiLabel.text = tracker.emoji
        cardView.backgroundColor = tracker.color
    }
    
    func setCompletedState(_ isCompleted: Bool) {
        completeButton.setImage(
            UIImage(systemName: isCompleted ? "checkmark.circle.fill" : "plus.circle"),
            for: .normal
        )
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
    
    @objc private func completeButtonTapped() {
        completionHandler?()
        
        isCompleted.toggle()
        setCompletedState(isCompleted)
        completionHandler?()
    }
}
