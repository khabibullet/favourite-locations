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

class LocationsViewController: UIViewController {
	
    weak var presenter: LocationsPresenterProtocol!
    
    let locationsTable: UITableView = {
        let table = UITableView()
        table.register(LocationTableCell.self, forCellReuseIdentifier: LocationTableCell.id)
        table.separatorStyle = .none
        table.estimatedRowHeight = UITableView.automaticDimension
        return table
    }()
    
    let searchController: UISearchController = {
        let search = UISearchController()
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search"
        search.definesPresentationContext = true
        search.hidesNavigationBarDuringPresentation = false
        search.searchBar.textField?.backgroundColor = .white
        return search
    }()
    
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.tintColor = UIColor(named: "mint-dark")
        return spinner
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Locations"
        label.textColor = UIColor(named: "mint-dark")
        label.sizeToFit()
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
		view.addSubview(locationsTable)
        
        locationsTable.delegate = self
        locationsTable.dataSource = self
        
        searchController.searchResultsUpdater = self

        configureNavigationBar()
        configureTabBar()
        configureTabBar()
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
        locationsTable.frame = view.safeAreaLayoutGuide.layoutFrame
	}
    
    func configureNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        let image = UIImage(named: "add")
        let item = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didTapAddButton))
        navigationItem.rightBarButtonItem = item
        navigationItem.titleView = titleLabel
        navigationController?.navigationBar.backgroundColor = UIColor(named: "mint-light")
        navigationController?.navigationBar.layer.shadowColor = UIColor(named: "mint-light")?.cgColor
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = UIColor(named: "mint-light")
            appearance.shadowColor = .clear
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.standardAppearance = appearance
        }
    }
    
    func configureTabBar() {
        tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "list"), tag: 0)
        tabBarItem.imageInsets = UIEdgeInsets.init(top: 5, left: 0, bottom: -5, right: 0)
        tabBarController?.tabBar.backgroundColor = UIColor(named: "mint-light")
        tabBarController?.tabBar.unselectedItemTintColor = UIColor(named: "mint-light-2")
    }
    
    @objc func didTapAddButton() {
        let modalView = LocationAddViewController(presenter: presenter)
        if #available(iOS 13.0, *) {
            modalView.isModalInPresentation = true
        }
        present(modalView, animated: true)
    }
    
    func updateTableContents() {
        locationsTable.reloadData()
    }
}

extension LocationsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension LocationsViewController: UITableViewDataSource {
    
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
        let eastOrWest = location.longitude > 0 ? "E" : "W"
        cell.coordinates.text = String(format: "%.2f??%@, %.2f??%@", abs(location.latitude), northOrSouth, abs(location.longitude), eastOrWest)
        if let comment = location.comment {
            cell.comment.text = comment
        }
        cell.selectionStyle = .none
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension LocationsViewController: UITableViewDelegate {
    
    func edit(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: nil) { (_, _, _) in
            print("editing row")
        }
        action.backgroundColor = .white
        action.image = UIImage(named: "edit")
        return action
    }
    
    func delete(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: nil) { (_, _, _) in
            print("deleting row")
        }
        action.backgroundColor = .white
        action.image = UIImage(named: "delete")
        return action
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = delete(rowIndexPathAt: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [deleteAction])
        swipe.performsFirstActionWithFullSwipe = false
        return swipe
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = edit(rowIndexPathAt: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [editAction])
        swipe.performsFirstActionWithFullSwipe = false
        return swipe
    }
}

extension LocationsViewController: LocationsViewProtocol {
    
}
