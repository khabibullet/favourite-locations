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
            coordinates.text = location.coordinates
            comment.text = location.comment
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
        button.addTarget(self, action: #selector(didTapArrow), for: .touchUpInside)
        button.isSelected = false
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    let coordinates: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.isHidden = true
        return label
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
        stack.alignment = .fill
        stack.spacing = 10
        stack.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.backgroundColor = UIColor(named: "mint-extra-light")
        stack.layer.cornerRadius = 10
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        hStack.addArrangedSubview(title)
        hStack.addArrangedSubview(arrowButton)
        
        vStack.addArrangedSubview(hStack)
        vStack.addArrangedSubview(coordinates)
        vStack.addArrangedSubview(comment)

        contentView.addSubview(vStack)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        vStack.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.verticalEdges.equalToSuperview().inset(5)
        }
    }
    
    func switchDetailsAppearance() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.01, options: .curveEaseIn) {
            if self.arrowButton.isSelected {
                self.coordinates.alpha = 0.0
                self.comment.alpha = 0.0
                self.coordinates.isHidden = true
                self.comment.isHidden = true
                self.arrowButton.isSelected = false
            } else {
                self.coordinates.isHidden = false
                self.comment.isHidden = false
                self.coordinates.alpha = 1.0
                self.comment.alpha = 1.0
                self.arrowButton.isSelected = true
            }
            self.contentView.layoutIfNeeded()
        }
    }
    
    @objc func didTapArrow() {
        delegate?.locationCellArrowButtonTapped(cell: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
