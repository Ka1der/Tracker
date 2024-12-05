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
        trackers.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "Trackers"),
            selectedImage: nil
        )
        
        let statistic = UIViewController()
        statistic.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "Statistic"),
            selectedImage: nil
        )
        
        viewControllers = [trackers, statistic]
        
        tabBar.tintColor = .blue
        tabBar.backgroundColor = .white
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = UIColor.lightGray.cgColor
    }
}
