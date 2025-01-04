//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Kaider on 30.11.2024.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    
    // MARK: - Types
    
    enum OnboardingPageType {
        case firstPage
        case secondPage
    }
    
    struct OnboardingPage {
        let type: OnboardingPageType
        let imageName: String
        let title: String
        let buttonTitle: String?
        let backgroundColor: UIColor
        
        init?(type: OnboardingPageType, imageName: String, title: String, buttonTitle: String? = nil, backgroundColor: UIColor = .systemBackground) {
            guard UIImage(named: imageName) != nil else {
                print("\(#file):\(#line)] \(#function) Ошибка: изображение \(imageName) не найдено в ассетах")
                return nil
            }
            
            self.type = type
            self.imageName = imageName
            self.title = title
            self.buttonTitle = buttonTitle
            self.backgroundColor = backgroundColor
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var pages: [UIViewController] = {
        return onboardingPages.map { createPage(with: $0) }
    }()
    
    private let onboardingPages: [OnboardingPage] = [
        OnboardingPage(
            type: .firstPage,
            imageName: "onboardingScreen1",
            title: "Отслеживайте только\nто, что хотите"
        ),
        OnboardingPage(
            type: .secondPage,
            imageName: "onboardingScreen2",
            title: "Даже если это\nне литры воды и йога",
            buttonTitle: "Вот это технологии!"
        )
    ].compactMap { $0 }
    
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = onboardingPages.count
        control.currentPage = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        control.currentPageIndicatorTintColor = .black
        control.pageIndicatorTintColor = .gray
        return control
    }()
    
    private lazy var wowTechnologyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вот это технологии!", for: .normal)
        button.backgroundColor = .blackYPBlack
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(wowTechnologyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        print("\(#file):\(#line)] \(#function) Ошибка: init(coder:) не реализован")
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupViews()
    }
    
    // MARK: - Private Methods
    
    private func setupViewController() {
        dataSource = self
        delegate = self
        
        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: true)
        } else {
            print("\(#file):\(#line)] \(#function) Ошибка: не удалось создать первую страницу")
        }
    }
    
    private func setupViews() {
        view.addSubview(pageControl)
        view.addSubview(wowTechnologyButton)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: wowTechnologyButton.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            wowTechnologyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            wowTechnologyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            wowTechnologyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            wowTechnologyButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func createPage(with pageData: OnboardingPage) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = pageData.backgroundColor
        
        let backgroundImageView = UIImageView()
        if let image = UIImage(named: pageData.imageName) {
            backgroundImageView.image = image
        } else {
            print("\(#file):\(#line)] \(#function) Ошибка загрузки изображения: \(pageData.imageName)")
        }
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = pageData.title
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        viewController.view.addSubview(backgroundImageView)
        viewController.view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: viewController.view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: viewController.view.centerYAnchor, constant: 50)
        ])
        
        return viewController
    }
    
    // MARK: - Actions
    
    @objc private func wowTechnologyButtonTapped() {
        UserDefaults.standard.set(true, forKey: "OnboardingCompleted")
        let tabBarController = TabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        print("\(#file):\(#line)] \(#function) Переход к главному экрану")
        present(tabBarController, animated: true)
    }
}

// MARK: - UIPageViewControllerDataSource & UIPageViewControllerDelegate

extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else {
            print("\(#file):\(#line)] \(#function) Ошибка определения текущей страницы")
            return nil
        }
        
        let previousIndex = currentIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else {
            print("\(#file):\(#line)] \(#function) Ошибка определения текущей страницы")
            return nil
        }
        
        let nextIndex = currentIndex + 1
        guard nextIndex < pages.count else {
            return nil
        }
        
        return pages[nextIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if completed,
           let visibleViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: visibleViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
