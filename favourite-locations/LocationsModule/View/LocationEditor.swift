//
//  AddNodeViewController.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 29.12.2022.
//

import UIKit
import SnapKit
import CoreData


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
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
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
    
    let coordinatesTextView: UITextView = {
        let view = UITextView()
        view.placeholder = "Coordinates"
        view.backgroundColor = UIColor(named: "mint-light")
        view.isUserInteractionEnabled = false
        view.isScrollEnabled = false
        view.layer.cornerRadius = 10
        view.textAlignment = .natural
        view.font = .systemFont(ofSize: 18)
        view.textColor = .lightGray
        return view
    }()
    
    let commentTextView: UITextView = {
        let view = UITextView()
        view.placeholder = "Description"
        view.backgroundColor = UIColor(named: "mint-light")
        view.layer.cornerRadius = 10
        view.textAlignment = .natural
        view.isScrollEnabled = false
        view.font = .systemFont(ofSize: 18)
        view.textContainer.maximumNumberOfLines = 100
        view.textContainer.lineBreakMode = .byWordWrapping
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
        self.coordinates = (location.latitude, location.longitude)
        self.coordinatesTextView.text = Location.coordinatesString(location.latitude, location.longitude)
        self.coordinatesTextView.hidePlaceholder()
        self.commentTextView.text = location.comment
        self.commentTextView.hidePlaceholder()
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
        scrollView.delegate = self
        coordinatesTextView.delegate = self
        commentTextView.delegate = self
        commentTextView.layoutManager.delegate = self
        
        topHStack.addArrangedSubview(coordinatesTextView)
        topHStack.addArrangedSubview(locateButton)
        bottomHStack.addArrangedSubview(cancelButton)
        bottomHStack.addArrangedSubview(saveButton)
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(nameTextField)
        vStack.addArrangedSubview(nameAmbiguityErrorLabel)
        vStack.addArrangedSubview(nameBusyErrorLabel)
        vStack.addArrangedSubview(topHStack)
        vStack.addArrangedSubview(coordinatesAmbiguityErrorLabel)
        vStack.addArrangedSubview(commentTextView)
        vStack.addArrangedSubview(bottomHStack)
        contentView.addSubview(vStack)
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        scrollView.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        setConstraints()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
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
    
    var activeSubview: UIView?
    var keyboardHeight: CGFloat?
    
    func manageContentOffset() {
        guard let activeSubview = activeSubview, let keyboardHeight = keyboardHeight else { return }
        let bottomY = activeSubview === commentTextView ? bottomHStack.frame.maxY : activeSubview.frame.maxY
        let bottom = vStack.frame.origin.y + bottomY + 10
        let visibleAreaHeight = view.frame.height - keyboardHeight
        let offset = bottom - visibleAreaHeight
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentInset = UIEdgeInsets(top: -offset, left: 0, bottom: 0, right: 0)
        }
    }
    
    @objc func kbWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let frameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        keyboardHeight = frameSize.height
        manageContentOffset()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        activeSubview = nil
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentInset = UIEdgeInsets.zero
        }
    }

    func editLocation(name: String, coordinates: (latitude: Double, longitude: Double), comment: String?) {
        guard let oldName = oldName else { return }
        if name == oldName {
            presenter.restoreLocation(name: name, coordinates: coordinates, comment: comment)
            self.dismiss(animated: true, completion: nil)
        } else if name.isEmpty {
            nameAmbiguityErrorLabel.isHidden = false
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
        let comment = commentTextView.text
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
        presenter.coordinatesInputInitiated { coordinates in
            guard let coordinates = coordinates else { return }
            self.coordinates = coordinates
        }
    }
}

extension LocationEditor: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldStr: NSString = (textField.text ?? "") as NSString
        
        nameBusyErrorLabel.isHidden = true
        nameAmbiguityErrorLabel.isHidden = true
        if oldStr.length > 0 {
            nameAmbiguityErrorLabel.isHidden = true
        }
        
        let newStr: NSString =  oldStr.replacingCharacters(in: range, with: string) as NSString
        return newStr.length <= 6
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeSubview = textField
    }
}

extension LocationEditor: UITextViewDelegate {
    
    
    func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = textView.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = !textView.text.isEmpty
        }
}
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeSubview = textView
        manageContentOffset()
    }
}

extension LocationEditor: NSLayoutManagerDelegate {
    
    func layoutManager(_ layoutManager: NSLayoutManager, didCompleteLayoutFor textContainer: NSTextContainer?, atEnd layoutFinishedFlag: Bool) {
        manageContentOffset()
    }
    
}
