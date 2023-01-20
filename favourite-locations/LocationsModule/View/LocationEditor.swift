//
//  AddNodeViewController.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 29.12.2022.
//

import UIKit
import SnapKit

enum ValidationResult {
    case success
    case error
}

enum EditMode {
    case edit
    case create
}

protocol Presentable {
    
}

class LocationEditor: UIViewController, Presentable {
    
    let presenter: LocationsPresenterProtocol
    
    let editMode: EditMode
    var oldName: String?
    
    var coordinates: (latitude: Double, longitude: Double)? {
        didSet {
            guard let coordinates = coordinates else { return }
            coordinatesTextView.text = Location.coordinatesString(coordinates.latitude, coordinates.longitude)
        }
    }
    
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
    
    let contentView: UIView = {
        return UIView()
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.textAlignment = .center
        return label
    }()
    
    let nameTextField: CustomTextField = {
        let field = CustomTextField()
        field.backgroundColor = UIColor(named: "mint-light")
        field.layer.cornerRadius = 10
        field.textAlignment = .natural
        field.font = .systemFont(ofSize: 18)
        field.textColor = .black
        field.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        return field
    }()
    
    let coordinatesTextView: CustomTextView = {
        let view = CustomTextView()
        view.placeholder = "Coordinates"
        view.backgroundColor = UIColor(named: "mint-light")
        view.isUserInteractionEnabled = false
        view.isScrollEnabled = false
        view.layer.cornerRadius = 10
        view.textAlignment = .natural
        view.font = .systemFont(ofSize: 18)
        return view
    }()
    
    let commentTextView: CustomTextView = {
        let view = CustomTextView()
        view.placeholder = "Description"
        view.backgroundColor = UIColor(named: "mint-light")
        view.layer.cornerRadius = 10
        view.textAlignment = .natural
        view.isScrollEnabled = false
        view.font = .systemFont(ofSize: 18)
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
        button.titleLabel?.font = .systemFont(ofSize: 18)
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "mint-dark")
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        return button
    }()
    
    let topHStack: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = UIColor(named: "mint-light")
        stack.layer.cornerRadius = 10
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    let bottomHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()
    
    let nameAmbiguityErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "Please, enter name."
        label.textColor = .red
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        label.isHidden = true
        return label
    }()
    
    let nameBusyErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "Location with this name already exists."
        label.textColor = .red
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        label.isHidden = true
        return label
    }()
    
    let coordinatesAmbiguityErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "Please, set coordinates."
        label.textColor = .red
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        label.isHidden = true
        return label
    }()
    
    let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 15
        return stack
    }()
    
    init(presenter: LocationsPresenterProtocol) {
        self.presenter = presenter
        self.titleLabel.text = "Add location"
        self.editMode = .create
        super.init(nibName: nil, bundle: nil)
    }
    
    init(presenter: LocationsPresenterProtocol, location: Location) {
        self.presenter = presenter
        self.nameTextField.text = location.name
        self.oldName = location.name
        self.coordinatesTextView.text = location.coordinates
        self.coordinates = (location.latitude, location.longitude)
        self.commentTextView.text = location.comment
        self.titleLabel.text = "Edit location"
        self.editMode = .edit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        coordinatesTextView.delegate = self
        commentTextView.delegate = self
        scrollView.delegate = self
        
        topHStack.addArrangedSubview(coordinatesTextView)
        topHStack.addArrangedSubview(locateButton)
        bottomHStack.addArrangedSubview(cancelButton)
        bottomHStack.addArrangedSubview(saveButton)
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(nameTextField)
        vStack.addArrangedSubview(topHStack)
        vStack.addArrangedSubview(commentTextView)
        vStack.addArrangedSubview(bottomHStack)
        vStack.addArrangedSubview(nameAmbiguityErrorLabel)
        vStack.addArrangedSubview(nameBusyErrorLabel)
        vStack.addArrangedSubview(coordinatesAmbiguityErrorLabel)
        contentView.addSubview(vStack)
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        scrollView.addGestureRecognizer(tap)
        
        setConstraints()
    }
    
    func setConstraints() {
        vStack.setCustomSpacing(35, after: titleLabel)
        vStack.setCustomSpacing(25, after: bottomHStack)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide.snp.edges)
            $0.width.equalTo(view.snp.width)
        }
        
        vStack.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(40)
            $0.width.equalToSuperview().dividedBy(1.5)
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func editLocation(name: String, coordinates: (latitude: Double, longitude: Double), comment: String?) {
        guard let oldName = oldName else { return }
        if name == oldName {
            presenter.restoreLocation(name: name, coordinates: coordinates, comment: comment)
            self.dismiss(animated: true, completion: nil)
        } else if presenter.containsLocation(withName: name) {
            nameBusyErrorLabel.isHidden = false
        } else {
            presenter.replaceLocation(oldName: oldName, name: name, coordinates: coordinates, comment: comment)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func createLocation(name: String, coordinates: (latitude: Double, longitude: Double)?, comment: String?) {
        if let coordinates = coordinates {
            if name.isEmpty {
                nameAmbiguityErrorLabel.isHidden = false
            } else if presenter.containsLocation(withName: name) {
                nameBusyErrorLabel.isHidden = false
            } else {
                presenter.createLocation(name: name, coordinates: coordinates, comment: comment)
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            coordinatesAmbiguityErrorLabel.isHidden = false
            if name.isEmpty {
                nameAmbiguityErrorLabel.isHidden = false
            } else if presenter.containsLocation(withName: name) {
                nameBusyErrorLabel.isHidden = false
            }
        }
    }
    
    @objc func didTapSaveButton() {
        guard let name = nameTextField.text else { return }
        let comment = commentTextView.isEmpty ? nil : commentTextView.text
        if editMode == .edit, let coordinates = coordinates {
            editLocation(name: name, coordinates: coordinates, comment: comment)
        } else {
            createLocation(name: name, coordinates: coordinates, comment: comment)
        }
    }
    
    @objc func didTapCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapLocateButton() {
        coordinates = (latitude: 44.12, longitude: 56.22)
    }
}

extension LocationEditor: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
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

extension LocationEditor: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
}

extension LocationEditor: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 30
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
        if newString.length > 0, textField === nameTextField {
            nameAmbiguityErrorLabel.isHidden = true
        }
        return newString.length <= maxLength
    }
}
