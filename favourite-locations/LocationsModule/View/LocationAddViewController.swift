//
//  AddNodeViewController.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 29.12.2022.
//

import UIKit
import SnapKit

protocol Presentable {
    
}

class LocationAddViewController: UIViewController, Presentable {
    
    let presenter: LocationsPresenterProtocol
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add new location"
        label.font = UIFont.systemFont(ofSize: 22)
        label.textAlignment = .center
        return label
    }()
    
    let nameTextField: UITextField = {
        let field = UITextField()
        field.backgroundColor = UIColor(named: "mint-light")
        field.layer.cornerRadius = 10
        field.placeholder = "Name"
        field.textAlignment = .natural
        return field
    }()
    
    let coordinatesTextField: UITextField = {
        let field = UITextField()
        field.backgroundColor = UIColor(named: "mint-light")
        field.placeholder = "Coordinates"
        field.isUserInteractionEnabled = false
        field.layer.cornerRadius = 10
        field.textAlignment = .natural
        return field
    }()
    
    let commentTextField: UITextField = {
        let field = UITextField()
        field.backgroundColor = UIColor(named: "mint-light")
        field.placeholder = "Description"
        field.layer.cornerRadius = 10
        field.textAlignment = .natural
        return field
    }()
    
    let locateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Locate", for: .normal)
        button.setTitleColor(UIColor(named: "mint-dark"), for: .normal)
        button.setImage(UIImage(named: "location-contour"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        button.semanticContentAttribute = .forceRightToLeft
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "mint-dark")?.cgColor
        button.addTarget(self, action: #selector(didTapLocateButton), for: .touchUpInside)
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(UIColor(named: "mint-dark"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "mint-dark")?.cgColor
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "mint-dark")
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        return button
    }()
    
    let topHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 10
        stack.backgroundColor = UIColor(named: "mint-light")
        stack.layer.cornerRadius = 10
        return stack
    }()
    
    let bottomHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()
    
    let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 15
        return stack
    }()
    
    init(presenter: LocationsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        topHStack.addArrangedSubview(coordinatesTextField)
        topHStack.addArrangedSubview(locateButton)
        bottomHStack.addArrangedSubview(cancelButton)
        bottomHStack.addArrangedSubview(saveButton)
        vStack.addArrangedSubview(nameTextField)
        vStack.addArrangedSubview(topHStack)
        vStack.addArrangedSubview(commentTextField)
        vStack.addArrangedSubview(bottomHStack)
        view.addSubview(vStack)
        view.addSubview(titleLabel)
    }
    
    override func viewDidLayoutSubviews() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.centerX.equalToSuperview()
        }
        
        vStack.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(1.5)
        }
    }
    
    @objc func didTapSaveButton() {
//        if let text = charTextField.text {
//            delegate?.didAddString(string: text)
//        }
//        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapLocateButton() {
        
    }
}

extension LocationAddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        commentTextField.resignFirstResponder()
        return true
    }
}
