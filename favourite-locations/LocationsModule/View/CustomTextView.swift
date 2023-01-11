//
//  CustomTextView.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 11.01.2023.
//

import UIKit

class CustomTextView: UITextView {

    var isPlaceholderPresented = false
    var placeholderColor: UIColor = .lightGray
    
    var placeholder: String? {
        didSet {
            if text.count == 0 {
                text = placeholder
                textColor = placeholderColor
                isPlaceholderPresented = true
            }
        }
    }
}
