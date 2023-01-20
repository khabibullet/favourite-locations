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
    func insertLocation(at index: Int)
    func removeLocation(at index: Int)
    func updateLocation(at index: Int)
}

protocol LocationTableCellDelegate: AnyObject {
    func locationCellArrowButtonTapped(cell: LocationTableCell)
}

class LocationsViewController: UIViewController {
	
    weak var presenter: LocationsPresenterProtocol!
    
    let locationsTable: UITableView = {
        let table = UITableView()
        table.register(LocationTableCell.self, forCellReuseIdentifier: LocationTableCell.id)
        table.separatorStyle = .none
        table.estimatedRowHeight = UITableView.automaticDimension
        table.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
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
        
        setConstraints()
    }
	
    func setConstraints() {
        locationsTable.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
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
        let modalView = LocationEditor(presenter: presenter)
        if #available(iOS 13.0, *) {
            modalView.isModalInPresentation = true
        }
        present(modalView, animated: true)
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
        cell.location = presenter.getLocationWithPrefixOnIndex(id: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension LocationsViewController: UITableViewDelegate {
    
    func edit(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: nil) { (_, _, _) in
            let modalView = LocationEditor(presenter: self.presenter, location: self.presenter.getLocationWithPrefixOnIndex(id: indexPath.row))
            if #available(iOS 13.0, *) {
                modalView.isModalInPresentation = true
            }
            self.present(modalView, animated: true)
        }
        action.backgroundColor = .white
        action.image = UIImage(named: "edit")
        return action
    }
    
    func delete(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: nil) { (_, _, _) in
            self.presenter.removeLocation(at: indexPath.row)
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

    func insertLocation(at index: Int) {
        locationsTable.beginUpdates()
        locationsTable.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        locationsTable.endUpdates()
    }
    
    func removeLocation(at index: Int) {
        locationsTable.beginUpdates()
        locationsTable.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        locationsTable.endUpdates()
    }
    
    func updateLocation(at index: Int) {
        locationsTable.beginUpdates()
        locationsTable.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        locationsTable.beginUpdates()
    }
}

extension LocationsViewController: LocationTableCellDelegate {
    
    func locationCellArrowButtonTapped(cell: LocationTableCell) {
        locationsTable.beginUpdates()
        cell.switchDetailsAppearance()
        locationsTable.endUpdates()
    }
}
