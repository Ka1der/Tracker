//
//  TabBarController.swift
//  Tracker
//
//  Created by Kaider on 30.11.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    let trackerNavigationController = TrackersViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController()
        
    }
    
    func tabBarController() {
        let trackers = UINavigationController(rootViewController: trackerNavigationController)
        
        let trackerText: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        trackers.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "Trackers"),
            selectedImage: nil
        )
        trackers.tabBarItem.setTitleTextAttributes(trackerText as [NSAttributedString.Key : Any], for: .normal)
        
        let statisticVC = StatisticViewController()
        let statisticNavigationController = UINavigationController(rootViewController: statisticVC)
        
        statisticNavigationController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "Statistic"),
            selectedImage: nil
        )
        statisticNavigationController.tabBarItem.setTitleTextAttributes(trackerText as [NSAttributedString.Key : Any], for: .normal)
        
        viewControllers = [trackers, statisticNavigationController]
        
        tabBar.tintColor = UIColor(named: "tabBarTintColor")
        tabBar.backgroundColor = .white
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = UIColor.lightGray.cgColor
    }
}
