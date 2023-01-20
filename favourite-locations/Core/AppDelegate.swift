//
//  AppDelegate.swift
//  favourite-locations
//
//  Created by Irek Khabibullin on 8/18/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: CoordinatorProtocol?
    
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let locationsModule = ModuleBuilder.buildLocationsModule()
        let mapModule = ModuleBuilder.buildMapModule()
        self.coordinator = ModuleBuilder.buildCoordinator(locationsPresenter: locationsModule, mapPresenter: mapModule)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = coordinator?.tabBarController
        window.makeKeyAndVisible()
        self.window = window
        
		return true
	}
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        return
    }
}
