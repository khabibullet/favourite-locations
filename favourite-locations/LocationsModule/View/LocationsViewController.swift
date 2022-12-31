//
//  PlacesViewController.swift
//  favourite-locations
//
//  Created by Irek Khabibullin on 8/18/22.
//

import UIKit
import CoreData
import SnapKit

var places: [Pin] = [
	Pin("42 Paris", "42 School Paris", 48.896564659174146, 2.3184473544617554),
	Pin("21 Moscow", "21 School Moscow", 55.797105887723944, 37.579932542997845),
	Pin("21 Kazan", "21 School Kazan", 55.78190204770252, 49.125016281629364),
	Pin("21 Novosibirsk", "21 School Novosibirsk", 54.97996176014704, 82.89746381284534)
]

class LocationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	let placesTableView = UITableView()
    var locations: LocationsTrie?
    var strings: [String] = []
    
    let persistenceManager: PersistenceManager
	weak var navigationDelegate: NavigationDelegate?
	
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Location", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(named: "mint-dark")
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        return button
    }()
    
    init(persistenceManager: PersistenceManager) {
        self.persistenceManager = persistenceManager
        super.init(nibName: nil, bundle: nil)
        
        setStorage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    func setStorage() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationsTrie")
        fetchRequest.fetchLimit = 1
        if let locations = try? persistenceManager.viewContext.fetch(fetchRequest) as? [LocationsTrie], !locations.isEmpty {
            self.locations = locations.first
            print("locations tree fetched")
        } else {
            let locations = LocationsTrie(context: persistenceManager.viewContext)
            let root = TrieNode(context: persistenceManager.viewContext)
            root.char = nil
            root.location = nil
            root.parent = nil
            root.children = NSOrderedSet()
            locations.root = root
            locations.count = 0
            print("locations tree created")
        }
    }
    
    @objc func didTap() {
        let inputVC = AddNodeViewController()
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
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		navigationDelegate?.centerLocation(places[indexPath.row].location, regionRadius: 1000)
		tabBarController?.selectedIndex = 1
	}
	
	func setDefaultLocation() {
		navigationDelegate?.centerLocation(places[0].location, regionRadius: 1000)
		tabBarController?.selectedIndex = 1
	}
}
