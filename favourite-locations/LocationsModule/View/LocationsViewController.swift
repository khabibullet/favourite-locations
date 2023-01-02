//
//  PlacesViewController.swift
//  favourite-locations
//
//  Created by Irek Khabibullin on 8/18/22.
//

import UIKit
import CoreData
import SnapKit

protocol LocationsViewProtocol {
    
}

class LocationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LocationsViewProtocol {
	
    weak var presenter: LocationsPresenterProtocol!
    
	let locationsTable = UITableView()
    
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.tintColor = UIColor(named: "mint-dark")
        return spinner
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Location", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(named: "mint-dark")
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
		view.addSubview(locationsTable)
        view.addSubview(addButton)
        
        locationsTable.register(UITableViewCell.self, forCellReuseIdentifier: LocationTableCell.id)
        locationsTable.delegate = self
        locationsTable.dataSource = self
        
        tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "list"), tag: 0)
        tabBarItem.imageInsets = UIEdgeInsets.init(top: 5, left: 0, bottom: -5, right: 0)
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
        
        locationsTable.frame = view.bounds
        
        addButton.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview().offset(-60)
            maker.centerX.equalToSuperview()
            maker.width.equalToSuperview().dividedBy(4)
            maker.height.equalToSuperview().dividedBy(10)
        }
	}
    
    @objc func didTap() {
        let inputVC = LocationAddViewController()
        inputVC.delegate = self
        self.present(inputVC, animated: true, completion: nil)
    }
    
    func updateTableContents() {
        locationsTable.reloadData()
    }
    
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumberOfLocationsWithPrefix()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = locationsTable.dequeueReusableCell(withIdentifier: LocationTableCell.id, for: indexPath) as? LocationTableCell else {
            return LocationTableCell()
        }
		
        let location = presenter.getLocationWithPrefixOnIndex(id: indexPath.row)
        cell.title.text = location.name
        let northOrSouth = location.latitude > 0 ? "N" : "S"
        let eastOrWest = location.longitude > 0 ? "N" : "S"
        cell.coordinates.text = String(format: "%.2f°%s %.2f°%s", abs(location.latitude), northOrSouth, abs(location.longitude), eastOrWest)
        if let comment = location.comment {
            cell.comment.text = comment
        }
		return cell
	}
	
//	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		tableView.deselectRow(at: indexPath, animated: false)
//		navigationDelegate?.centerLocation(places[indexPath.row].location, regionRadius: 1000)
//		tabBarController?.selectedIndex = 1
//	}
//
//	func setDefaultLocation() {
//		navigationDelegate?.centerLocation(places[0].location, regionRadius: 1000)
//		tabBarController?.selectedIndex = 1
//	}
}
