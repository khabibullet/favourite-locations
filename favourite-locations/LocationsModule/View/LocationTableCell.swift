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
    
    var cellIsExpanded = false
    
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        return label
    }()
    
    let coordinates: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    let comment: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let arrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrow-down"), for: .normal)
        button.addTarget(self, action: #selector(didTapArrow), for: .touchUpInside)
        return button
    }()
    
    let hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        return stack
    }()
    
    let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 10
        stack.layer.cornerRadius = 10
        stack.backgroundColor = UIColor(named: "mint-extra-light")
        stack.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        hStack.addArrangedSubview(title)
        hStack.addArrangedSubview(arrowButton)
        vStack.addArrangedSubview(hStack)
        vStack.addArrangedSubview(coordinates)
        vStack.addArrangedSubview(comment)
        contentView.addSubview(vStack)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        vStack.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10).priority(999)
            $0.left.equalToSuperview().inset(10)
            $0.right.equalToSuperview().inset(10)
        }
    }
    
    @objc func didTapArrow() {
        if cellIsExpanded == false {
            arrowButton.setImage(UIImage(named: "arrow-up"), for: .normal)

            cellIsExpanded = true

//            title.snp.makeConstraints {
//                $0.edges.equalToSuperview().inset(10)
//            }
        } else {
            arrowButton.setImage(UIImage(named: "arrow-down"), for: .normal)

            cellIsExpanded = false
        }
        layoutIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
