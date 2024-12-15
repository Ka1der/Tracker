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
        print("\(#file):\(#line)] \(#function) Настройка заголовка секции: \(title), цвет: \(color)")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16), // добавим отступ сверху
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16), // и снизу
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28) // добавим ограничение справа
        ])
    }
    
    required init?(coder: NSCoder) {
        print("\(#file):\(#line)] \(#function) Ошибка: init(coder:) не реализован")
        return nil
    }
    
    
}
