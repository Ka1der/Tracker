//
//  NewHabitController.swift
//  Tracker
//
//  Created by Kaider on 07.12.2024.
//

import UIKit

final class NewHabitController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: NewHabitControllerDelegate?
    private var schedule: Set<WeekDay> = []
    
    private let colors: [UIColor] = [
        .systemRed,
        .systemOrange,
        .systemBlue,
        .systemPurple,
        .systemGreen,
        .systemPink,
        .systemRed.withAlphaComponent(0.3),
        .systemBlue.withAlphaComponent(0.3),
        .systemGreen.withAlphaComponent(0.3),
        .systemPurple.withAlphaComponent(0.3),
        .systemOrange.withAlphaComponent(0.3),
        .systemPink.withAlphaComponent(0.3),
        .systemOrange.withAlphaComponent(0.6),
        .systemBlue.withAlphaComponent(0.6),
        .systemPurple.withAlphaComponent(0.6),
        .systemPurple.withAlphaComponent(0.6),
        .systemPurple.withAlphaComponent(0.6),
        .systemGreen.withAlphaComponent(0.6)
    ]
    
    private let emojis = ["😊", "🐱", "🎯", "🐶", "❤️", "😱",
                          "😇", "😡", "🥶", "🤔", "🌟", "🍔",
                          "🥦", "🏓", "🥇", "🎸", "🌴", "😭"]
    
    
    // MARK: - UI Elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 16
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var categoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Категория", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return button
    }()

    private lazy var scheduleButton: UIButton = {
        let button = UIButton()
        button.setTitle("Расписание", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        button.addTarget(self, action: #selector(scheduleButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 52, height: 52)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HabitEmojiCell.self, forCellWithReuseIdentifier: "EmojiCell")
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 52, height: 52)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HabitColorCell.self, forCellWithReuseIdentifier: "ColorCell")
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "Emoji"
        label.font = UIFont(name: "SFPro-Medium", size: 19)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var colorLabel: UILabel = {
        let label = UILabel()
        label.text = "Цвет"
        label.font = UIFont(name: "SFPro-Medium", size: 19)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var buttonsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        [categoryButton, scheduleButton].forEach { button in
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: button.bounds.width - 40, bottom: 0, right: 16)
        }
    }
    
    // MARK: - Setup Methods
    
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(buttonsContainerView)
        //        view.addSubview(emojiLabel)
        //        view.addSubview(emojiCollectionView)
        //        view.addSubview(colorLabel)
        //        view.addSubview(colorCollectionView)
        view.addSubview(cancelButton)
        view.addSubview(createButton)

        buttonsContainerView.addSubview(categoryButton)
        buttonsContainerView.addSubview(separatorView)
        buttonsContainerView.addSubview(scheduleButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            buttonsContainerView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            buttonsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            categoryButton.topAnchor.constraint(equalTo: buttonsContainerView.topAnchor),
            categoryButton.leadingAnchor.constraint(equalTo: buttonsContainerView.leadingAnchor),
            categoryButton.trailingAnchor.constraint(equalTo: buttonsContainerView.trailingAnchor),
            categoryButton.heightAnchor.constraint(equalToConstant: 75),
            
            separatorView.leadingAnchor.constraint(equalTo: buttonsContainerView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: buttonsContainerView.trailingAnchor, constant: -16),
            separatorView.topAnchor.constraint(equalTo: categoryButton.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            
            scheduleButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            scheduleButton.leadingAnchor.constraint(equalTo: buttonsContainerView.leadingAnchor),
            scheduleButton.trailingAnchor.constraint(equalTo: buttonsContainerView.trailingAnchor),
            scheduleButton.heightAnchor.constraint(equalToConstant: 75),
            scheduleButton.bottomAnchor.constraint(equalTo: buttonsContainerView.bottomAnchor),
            
            //            emojiLabel.topAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: 32),
            //            emojiLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            //
            //            emojiCollectionView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 16),
            //            emojiCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            //            emojiCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            //            emojiCollectionView.heightAnchor.constraint(equalToConstant: 156),
            //
            //            colorLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 16),
            //            colorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            //
            //            colorCollectionView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 16),
            //            colorCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            //            colorCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            //            colorCollectionView.heightAnchor.constraint(equalToConstant: 156),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            cancelButton.widthAnchor.constraint(equalToConstant: (view.frame.width - 56) / 2),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createButton.widthAnchor.constraint(equalToConstant: (view.frame.width - 56) / 2),
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        let chevronImage = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
          [categoryButton, scheduleButton].forEach { button in
              button.setImage(chevronImage, for: .normal)
              button.tintColor = .gray
              button.contentHorizontalAlignment = .left
              button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
              button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
              button.imageView?.contentMode = .right
              button.imageEdgeInsets = UIEdgeInsets(top: 0, left: button.bounds.width - 32, bottom: 0, right: 16)
          }
       }
    
    // MARK: - Actions
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
        print("\(#file):\(#line)] \(#function) Нажата кнопка Отменить")
    }
    
    @objc private func createButtonTapped() {
        guard let title = nameTextField.text, !title.isEmpty else {
            print("\(#file):\(#line)] \(#function) Ошибка: пустое название трекера")
            return
        }
        
        let newTracker = Tracker(
            id: UUID(),
            title: title,
            color: .systemBlue,
            emoji: "📝",
            scheldue: schedule,
            isPinned: false
        )
        
        print("\(#file):\(#line)] \(#function) Создаем трекер: название - '\(title)', расписание - [\(schedule.map { $0.shortName }.joined(separator: ", "))]")
        
        delegate?.didCreateTracker(newTracker, category: "Новая категория")
        dismiss(animated: true)
    }
    
    @objc private func scheduleButtonTapped() {
        let scheduleController = NewScheduleController()
        scheduleController.delegate = self
        print("\(#file):\(#line)] \(#function) Переход к выбору расписания")
        present(scheduleController, animated: true)
    }
}

// MARK: - NewScheduleControllerDelegate

extension NewHabitController: NewScheduleControllerDelegate {
    func didUpdateSchedule(_ schedule: Set<WeekDay>) {
        self.schedule = schedule
        print("\(#file):\(#line)] \(#function) Получено расписание: \(schedule)")
        
        let weekDays = schedule.map { $0.shortName }.joined(separator: ", ")
        scheduleButton.setTitle(schedule.isEmpty ? "Расписание" : weekDays, for: .normal)
    }
}

// MARK: - UICollectionViewDelegate & DataSource

extension NewHabitController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == emojiCollectionView {
            return emojis.count
        } else {
            return colors.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath) as! HabitEmojiCell
            cell.configure(with: emojis[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! HabitColorCell
            cell.configure(with: colors[indexPath.item])
            return cell
        }
    }
}

// MARK: - Cells

final class HabitEmojiCell: UICollectionViewCell {
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(emojiLabel)
        contentView.layer.cornerRadius = 16
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with emoji: String) {
        emojiLabel.text = emoji
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .systemGray5 : .clear
        }
    }
}

final class HabitColorCell: UICollectionViewCell {
    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configure(with color: UIColor) {
        colorView.backgroundColor = color
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.layer.borderWidth = isSelected ? 3 : 0
            contentView.layer.borderColor = colorView.backgroundColor?.withAlphaComponent(0.3).cgColor
            contentView.layer.cornerRadius = 8
        }
    }
}
