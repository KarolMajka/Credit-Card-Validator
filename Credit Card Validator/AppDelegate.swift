//
//  AppDelegate.swift
//  Credit Card Validator
//
//  Created by Karol Majka on 20/07/2017.
//  Copyright © 2017 Karol Majka. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        configureWindow()
        return true
    }

    private func configureWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let mainViewController = MainViewController()
        let navigationController = UINavigationController(rootViewController: mainViewController)
        navigationController.isNavigationBarHidden = true
        window.backgroundColor = .white
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}
