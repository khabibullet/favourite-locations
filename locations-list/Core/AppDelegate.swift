//
//  AppDelegate.swift
//  no-storyboard-launch
//
//  Created by Alebelly Nemesis on 8/18/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let placesVC = PlacesViewController()
        let mapVC = MapViewController()
        placesVC.navigationDelegate = mapVC
        
        let tabBarVC = CustomTabBarController()
        tabBarVC.setViewControllers([placesVC, mapVC], animated: false)
        tabBarVC.navigationDelegate = mapVC
        
        window.rootViewController = tabBarVC
        window.makeKeyAndVisible()
        self.window = window
        
		return true
	}
}
