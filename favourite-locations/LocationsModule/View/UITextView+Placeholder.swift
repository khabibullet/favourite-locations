//
//  UITextView+Placeholder.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 22.01.2023.
//

import UIKit

extension UITextView {
    
    public var placeholder: String? {
        get {
            var placeholderText: String?
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    public func hidePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = true
        }
    }
    
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = .lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = !self.text.isEmpty
        
        self.addSubview(placeholderLabel)
        
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            placeholderLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            placeholderLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 4)
        ])
    }
    
}
