//
//  CustomTabBarController.swift
//  no-storyboard-launch
//
//  Created by Alebelly Nemesis on 8/18/22.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {

	var defaultLocation = Pin("42 Paris", "42 School Paris", 48.896564659174146, 2.3184473544617554).location
	weak var navigationDelegate: NavigationDelegate?
	
    override func viewDidLoad() {
        super.viewDidLoad()

		delegate = self
		configure()
    }
	
	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
		if tabBarController.selectedIndex == 1 {
			navigationDelegate?.centerLocation(defaultLocation, regionRadius: 1000)
		}
	}
}

extension CustomTabBarController {
	
	func configure() {
		tabBar.backgroundColor = UIColor(named: "mint-light")
		view.backgroundColor = .white
	}
}
