//
//  PlacesViewController.swift
//  no-storyboard-launch
//
//  Created by Alebelly Nemesis on 8/18/22.
//

import UIKit

var places: [Pin] = [
	Pin("42 Paris", "42 School Paris", 48.896564659174146, 2.3184473544617554),
	Pin("21 Moscow", "21 School Moscow", 55.797105887723944, 37.579932542997845),
	Pin("21 Kazan", "21 School Kazan", 55.78190204770252, 49.125016281629364),
	Pin("21 Novosibirsk", "21 School Novosibirsk", 54.97996176014704, 82.89746381284534)
]

class PlacesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	let placesTableView = UITableView()
	
	var navigationDelegate: NavigationDelegate?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.addSubview(placesTableView)
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		placesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "placeCell")
		placesTableView.frame = view.bounds
		placesTableView.delegate = self
		placesTableView.dataSource = self
		view.backgroundColor = .white
	}
	
	override init(nibName: String?, bundle: Bundle?) {
		super.init(nibName: nibName, bundle: bundle)
		
		tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "list.star"), tag: 0)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return places.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = placesTableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath)
		
		cell.textLabel?.text = places[indexPath.row].title
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
