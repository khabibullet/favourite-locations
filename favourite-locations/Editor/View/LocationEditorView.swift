//
//  AddNodeViewController.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 29.12.2022.
//

import UIKit
import SnapKit
import CoreData

protocol LocationsEditorProtocol {
    func configureInitialState()
}

class LocationEditorView: UIViewController, LocationsEditorProtocol {
    
    var presenter: LocationEditorPresenterProtocol!
    
    var oldName: String?
    
    var coordinates: (latitude: Double, longitude: Double)? {
        didSet {
            guard let coordinates = coordinates else { return }
            coordinatesTextView.text = Location.coordinatesString(coordinates.latitude, coordinates.longitude)
        }
    }
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Edit location"
        label.textColor = .black
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 18.0)
        return label
    }()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .white
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = UIColor(named: "mint-light")
        return view
    }()
    
    let contentView: UIView = {
        return UIView()
    }()
    
    let nameTextField: CustomTextField = {
        let field = CustomTextField()
        field.backgroundColor = .white
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
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapLocateButton), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 2, right: 5)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return button
    }()
    
    let topHStack: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .white
        stack.layer.cornerRadius = 10
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 15
        return stack
    }()
    
    let nameAmbiguityErrorLabel = ErrorLabel(text: "Please, enter name.")
    let nameBusyErrorLabel = ErrorLabel(text: "Location with this name already exists.")
    let coordinatesAmbiguityErrorLabel = ErrorLabel(text: "Please, set coordinates.")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        scrollView.delegate = self
        coordinatesTextView.delegate = self
        commentTextView.delegate = self
        commentTextView.layoutManager.delegate = self
        
        topHStack.addArrangedSubview(coordinatesTextView)
        topHStack.addArrangedSubview(locateButton)
        vStack.addArrangedSubview(nameTextField)
        vStack.addArrangedSubview(nameAmbiguityErrorLabel)
        vStack.addArrangedSubview(nameBusyErrorLabel)
        vStack.addArrangedSubview(topHStack)
        vStack.addArrangedSubview(coordinatesAmbiguityErrorLabel)
        vStack.addArrangedSubview(commentTextView)
        contentView.addSubview(vStack)
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        scrollView.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        configureNavigationBar()
        setConstraints()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide.snp.edges)
            $0.width.equalTo(view.snp.width)
        }
        
        vStack.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(50)
            $0.width.equalToSuperview().dividedBy(1.5)
            $0.centerX.equalToSuperview()
        }
    }
    
    func configureNavigationBar() {
        navigationItem.titleView = titleLabel
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSaveButton))
    }
    
    var activeSubview: UIView?
    var keyboardHeight: CGFloat?
    
    func manageContentOffset() {
        guard let activeSubview = activeSubview, let keyboardHeight = keyboardHeight else { return }
        let bottomY = activeSubview.frame.maxY
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
    
    func configureInitialState() {
        guard let location = presenter.getLocation() else {
            titleLabel.text = "Add location"
            return
        }
        oldName = location.name
        coordinates = (location.latitude, location.longitude)
        nameTextField.text = location.name
        commentTextView.text = location.comment
        coordinatesTextView.hidePlaceholder()
        commentTextView.hidePlaceholder()
    }
    
    @objc func didTapSaveButton() {
        let location = Location()
        presenter.complete(resultAction: .create, location: location)
    }
    
    @objc func didTapCancelButton() {
        presenter.complete(resultAction: .cancel, location: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapLocateButton() {
        presenter.coordinatesInputInitiated { coordinates in
            guard let coordinates = coordinates else { return }
            self.coordinates = coordinates
        }
    }
}

extension LocationEditorView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldStr: NSString = (textField.text ?? "") as NSString
        
        nameBusyErrorLabel.isHidden = true
        nameAmbiguityErrorLabel.isHidden = true
        if oldStr.length > 0 {
            nameAmbiguityErrorLabel.isHidden = true
        }
        
        let newStr: NSString =  oldStr.replacingCharacters(in: range, with: string) as NSString
        return newStr.length <= 30
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeSubview = textField
    }
}

extension LocationEditorView: UITextViewDelegate {
    
    
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

extension LocationEditorView: NSLayoutManagerDelegate {
    
    func layoutManager(_ layoutManager: NSLayoutManager, didCompleteLayoutFor textContainer: NSTextContainer?, atEnd layoutFinishedFlag: Bool) {
        manageContentOffset()
    }
    
}
