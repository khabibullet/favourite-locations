//
//  Extension + UISearchBar.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 03.01.2023.
//

import UIKit

extension UISearchBar {
    public var textField: UITextField? {
        if #available(iOS 13, *) {
            return searchTextField
        }
        let subViews = subviews.flatMap { $0.subviews }
        guard let textField = (subViews.filter { $0 is UITextField }).first as? UITextField else { return nil }
        return textField
    }
}
