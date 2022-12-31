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
    
	let placesTableView = UITableView()
	
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
		view.addSubview(placesTableView)
        view.addSubview(addButton)
        
        placesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "placeCell")
        placesTableView.delegate = self
        placesTableView.dataSource = self
        
        tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "list"), tag: 0)
        tabBarItem.imageInsets = UIEdgeInsets.init(top: 5, left: 0, bottom: -5, right: 0)
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
        
		placesTableView.frame = view.bounds
        
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
	
    func didAddString(string: String) {
        strings.append(string)
        placesTableView.reloadData()
    }
    
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return strings.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = placesTableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath)
		
		cell.textLabel?.text = strings[indexPath.row]
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
