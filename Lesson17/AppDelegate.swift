//
//  AppDelegate.swift
//  Lesson17
//
//  Created by Алексей Алексеев on 02.06.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let networkService = NetworkService()
        let viewController = ViewController(networkService: networkService)
        window?.rootViewController = UINavigationController(rootViewController: viewController)
        window?.makeKeyAndVisible()
        
        return true
    }


}
