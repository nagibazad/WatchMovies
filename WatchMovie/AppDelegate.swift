//
//  AppDelegate.swift
//  WatchMovie
//
//  Created by user on 19/12/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let homeViewController = HomeViewController.instantiateViewController(from: .home())
        let homeNavigationController = MovieNavigationController(rootViewController: homeViewController)
        self.window?.rootViewController = homeNavigationController
        self.window?.makeKeyAndVisible()
        return true
    }


}

