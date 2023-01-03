//
//  AddNodeViewController.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 29.12.2022.
//

import UIKit
import SnapKit

class LocationAddViewController: UIViewController, UITextFieldDelegate {

    weak var delegate: LocationsViewController?
    
    let charTextField: UITextField = {
        let field = UITextField()
        field.backgroundColor = UIColor(named: "mint-light")
        field.layer.cornerRadius = 10
        field.placeholder = "string"
        field.textAlignment = .natural
        return field
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(named: "mint-dark")
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        return button
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        charTextField.delegate = self
        view.addSubview(charTextField)
        view.addSubview(saveButton)
    }
    
    override func viewDidLayoutSubviews() {
        charTextField.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.width.equalToSuperview().dividedBy(2)
            maker.height.equalToSuperview().dividedBy(15)
        }
        
        saveButton.snp.makeConstraints { maker in
            maker.topMargin.equalTo(charTextField.snp_bottomMargin).offset(20)
            maker.height.equalToSuperview().dividedBy(10)
            maker.width.equalToSuperview().dividedBy(2)
            maker.centerX.equalToSuperview()
        }
    }
    
    @objc func didTapSaveButton() {
//        if let text = charTextField.text {
//            delegate?.didAddString(string: text)
//        }
//        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        charTextField.resignFirstResponder()
        return true
    }
    
}
