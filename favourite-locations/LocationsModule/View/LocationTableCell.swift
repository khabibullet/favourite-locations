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
        label.font = UIFont.systemFont(ofSize: 24)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let coordinates: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let comment: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
//        label.sizeToFit()
        return label
    }()
    
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "mint-extra-light")
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let editButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.titleLabel?.text = "Edit"
        button.titleLabel?.textColor = .green
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.titleLabel?.text = "Delete"
        button.titleLabel?.textColor = .red
        return button
    }()
    
    let arrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrow-down"), for: .normal)
        button.addTarget(self, action: #selector(didTapArrow), for: .touchUpInside)
        button.sizeToFit()
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        container.addSubview(title)
        container.addSubview(coordinates)
        container.addSubview(arrowButton)
        container.addSubview(comment)
        container.addSubview(editButton)
        container.addSubview(deleteButton)
        contentView.addSubview(container)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        container.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        title.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.right.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(10)
        }
        
        coordinates.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(10).priority(999)
            $0.bottom.equalToSuperview().inset(10)
            $0.right.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(10)
        }
        
        arrowButton.snp.makeConstraints {
            $0.centerY.equalTo(title.snp.centerY)
            $0.right.equalToSuperview().inset(10)
        }
        
        comment.snp.makeConstraints {
            $0.top.equalTo(coordinates.snp.bottom).offset(10).priority(999)
            $0.right.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
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
