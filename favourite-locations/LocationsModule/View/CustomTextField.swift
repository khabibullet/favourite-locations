//
//  CustomTextField.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 18.01.2023.
//

import UIKit

class CustomTextField: UITextField {

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4))
    }

}
