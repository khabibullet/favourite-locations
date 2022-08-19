//
//  SceneDelegate.swift
//  no-storyboard-launch
//
//  Created by Alebelly Nemesis on 8/18/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		
		let window = UIWindow(windowScene: windowScene)
		self.window = window
		
		let placesVC = PlacesViewController()
		let mapVC = MapViewController()
		placesVC.navigationDelegate = mapVC
		
		let tabBarVC = CustomTabBarController()
		tabBarVC.setViewControllers([placesVC, mapVC], animated: false)
		tabBarVC.navigationDelegate = mapVC
//		tabBarVC.defaultLocation = placesVC.places[0]
		
		window.rootViewController = tabBarVC
		window.makeKeyAndVisible()
	}

}

