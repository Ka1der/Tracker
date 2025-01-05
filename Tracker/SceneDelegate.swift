//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Kaider on 24.11.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            print("\(#file):\(#line)] \(#function) Ошибка: не удалось получить windowScene")
            return
        }
        
        let isOnboardingCompleted = UserDefaults.standard.bool(forKey: "OnboardingCompleted")
        print("\(#file):\(#line)] \(#function) Статус онбординга: \(isOnboardingCompleted)")
        
        window = UIWindow(windowScene: windowScene)
        
        if isOnboardingCompleted {
            window?.rootViewController = TabBarController()
            print("\(#file):\(#line)] \(#function) Показываем главный экран")
        } else {
            window?.rootViewController = OnboardingViewController()
            print("\(#file):\(#line)] \(#function) Показываем онбординг")
        }
        
        window?.makeKeyAndVisible()
    }
}
