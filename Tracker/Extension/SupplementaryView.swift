//
//  SupplementaryView.swift
//  Tracker
//
//  Created by Kaider on 03.12.2024.
//

import UIKit

final class SupplementaryView: UICollectionReusableView {
    
   private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 19)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configure(with title: String, color: UIColor = .black) {
        titleLabel.text = title
        titleLabel.textColor = color
        print("\(#file):\(#line)] \(#function) Настройка заголовка: \(title), цвет: \(color)")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
