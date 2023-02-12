//
//  ErrorLabel.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 12.02.2023.
//

import UIKit

class ErrorLabel: UILabel {

    init(text: String) {
        super.init(frame: .zero)
        
        self.text = text
        self.textColor = .red
        self.textAlignment = .center
        self.numberOfLines = 0
        self.font = .systemFont(ofSize: 12)
        self.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
