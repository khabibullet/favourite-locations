//
//  NavigationController.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 03.01.2023.
//

import UIKit

class NavigationController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let topVC = viewControllers.first {
            return topVC.preferredStatusBarStyle
        }
        return .default
    }
    
    override var prefersStatusBarHidden: Bool {
        if let topVC = viewControllers.first {
            return topVC.prefersStatusBarHidden
        }
        return false
    }
}
