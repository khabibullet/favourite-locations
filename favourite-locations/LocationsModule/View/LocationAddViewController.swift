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
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .white
        view.isScrollEnabled = true
        view.bounces = true
        view.alwaysBounceVertical = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.scrollsToTop = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add new location"
        label.font = UIFont.systemFont(ofSize: 22)
        label.textAlignment = .center
        return label
    }()
    
    let nameTextView: CustomTextView = {
        let view = CustomTextView()
        view.placeholder = "Name"
        view.backgroundColor = UIColor(named: "mint-light")
        view.layer.cornerRadius = 10
        view.textAlignment = .natural
        view.isScrollEnabled = false
        view.font = .systemFont(ofSize: 16)
        view.textContainer.maximumNumberOfLines = 1
        return view
    }()
    
    let coordinatesTextView: CustomTextView = {
        let view = CustomTextView()
        view.placeholder = "Coordinates"
        view.backgroundColor = UIColor(named: "mint-light")
        view.isUserInteractionEnabled = false
        view.isScrollEnabled = false
        view.layer.cornerRadius = 10
        view.textAlignment = .natural
        view.font = .systemFont(ofSize: 15)
        return view
    }()
    
    let commentTextView: CustomTextView = {
        let view = CustomTextView()
        view.placeholder = "Description"
        view.backgroundColor = UIColor(named: "mint-light")
        view.layer.cornerRadius = 10
        view.textAlignment = .natural
        view.isScrollEnabled = false
        view.font = .systemFont(ofSize: 15)
        view.textContainer.maximumNumberOfLines = 100
        return view
    }()
    
    let locateButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "location-contour"), for: .normal)
        button.backgroundColor = UIColor(named: "mint-light")
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapLocateButton), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 2, right: 5)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
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
        nameTextView.delegate = self
        coordinatesTextView.delegate = self
        commentTextView.delegate = self
        scrollView.delegate = self
        
        topHStack.addArrangedSubview(coordinatesTextView)
        topHStack.addArrangedSubview(locateButton)
        bottomHStack.addArrangedSubview(cancelButton)
        bottomHStack.addArrangedSubview(saveButton)
        vStack.addArrangedSubview(nameTextView)
        vStack.addArrangedSubview(topHStack)
        vStack.addArrangedSubview(commentTextView)
        vStack.addArrangedSubview(bottomHStack)
        scrollView.addSubview(vStack)
        scrollView.addSubview(titleLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        scrollView.addGestureRecognizer(tap)
        
        view.addSubview(scrollView)
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
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func didTapSaveButton() {
        
    }
    
    @objc func didTapCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapLocateButton() {
        
    }
}

extension LocationAddViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView.text.count + (text.count - range.length) > 30 {
            guard textView !== nameTextView else { return false }
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let textView = textView as? CustomTextView else { return }
    }

    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard let textView = textView as? CustomTextView else { return }
        if textView.isPlaceholderPresented {
            textView.text = ""
            textView.textColor = .black
            textView.isPlaceholderPresented = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let textView = textView as? CustomTextView else { return }
        if textView.text.count == 0 {
            textView.isPlaceholderPresented = true
            textView.text = textView.placeholder
            textView.textColor = textView.placeholderColor
        }
    }
}

extension LocationAddViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
}
