//
//  LocationTableCell.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 02.01.2023.
//

import UIKit
import SnapKit

class LocationTableCell: UITableViewCell {
    static let id = "LocationCell"
    weak var delegate: LocationTableCellDelegate?
    
    var location: Location? {
        didSet {
            guard let location = location else { return }
            title.text = location.name
            comment.text = location.comment
            coordinatesLabel.text = location.coordinates
        }
    }
    
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let arrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrow-down"), for: .normal)
        button.setImage(UIImage(named: "arrow-up"), for: .selected)
        button.isSelected = false
        button.imageView?.contentMode = .scaleAspectFit
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    let comment: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    let hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 10
        return stack
    }()
    
    let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = 10
        stack.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.backgroundColor = .white
        stack.layer.cornerRadius = 10
        stack.backgroundColor = UIColor(named: "mint-extra-light")
        return stack
    }()
    
    let coordinatesImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "location-contour")?.withRenderingMode(.alwaysTemplate))
        view.tintColor = .lightGray
        return view
    }()
    
    let coordinatesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    let coordinatesContainer: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        view.isHidden = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = .white
        
        hStack.addArrangedSubview(title)
        hStack.addArrangedSubview(arrowButton)
        let hStackGesture = UITapGestureRecognizer(target: self, action: #selector(didTapArrow))
        hStack.addGestureRecognizer(hStackGesture)
        
        coordinatesContainer.addSubview(coordinatesLabel)
        coordinatesContainer.addSubview(coordinatesImageView)

        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapLocateButton))
        coordinatesContainer.addGestureRecognizer(gesture)
        
        vStack.addArrangedSubview(hStack)
        vStack.addArrangedSubview(coordinatesContainer)
        vStack.addArrangedSubview(comment)
        

        contentView.addSubview(vStack)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        vStack.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.bottom.equalToSuperview().inset(5).priority(999)
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
        arrowButton.snp.makeConstraints {
            $0.trailing.equalTo(vStack.snp.trailing).inset(10)
        }
        coordinatesImageView.snp.makeConstraints {
            $0.width.equalTo(20)
            $0.height.equalTo(20)
            $0.top.equalToSuperview().inset(5)
            $0.trailing.equalToSuperview().inset(5)
            $0.leading.equalTo(coordinatesLabel.snp.trailing).offset(10)
        }
        coordinatesLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(5)
            $0.leading.equalToSuperview().inset(5)
        }
    }
    
    func switchDetailsAppearance() {
        if self.arrowButton.isSelected {
            collapseCell()
        } else {
            expandCell()
        }
    }
    
    func expandCell() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.01, options: .curveEaseIn) {
            self.coordinatesContainer.isHidden = false
            self.comment.isHidden = false
            self.coordinatesContainer.alpha = 1.0
            self.comment.alpha = 1.0
            self.arrowButton.isSelected = true
            self.contentView.layoutIfNeeded()
        }
    }
    
    func collapseCell() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.01, options: .curveEaseIn) {
            self.coordinatesContainer.isHidden = true
            self.comment.isHidden = true
            self.coordinatesContainer.alpha = 0.0
            self.comment.alpha = 0.0
            self.arrowButton.isSelected = false
            self.contentView.layoutIfNeeded()
        }
    }
    
    func prepareToDisplay() {
        if self.arrowButton.isSelected {
            collapseCell()
        }
    }
    
    @objc func didTapArrow() {
        delegate?.locationCellArrowButtonTapped(cell: self)
    }
    
    @objc func didTapLocateButton() {
        guard let location = location else { return }
        delegate?.locationCellLocateButtonTapped(location: location)
    }

}
