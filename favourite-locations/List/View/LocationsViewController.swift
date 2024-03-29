//
//  PlacesViewController.swift
//  favourite-locations
//
//  Created by Irek Khabibullin on 8/18/22.
//

import UIKit
import CoreData
import SnapKit

enum TableViewUpdate {
    case reload(cellID: Int)
    case move(prevCellID: Int, newCellID: Int)
    case insert(cellID: Int)
    case remove(cellID: Int)
    case none
}

protocol LocationsViewProtocol: AnyObject {
    func insertCell(at index: Int)
    func moveCell(at prevID: Int, to newID: Int)
    func reloadCell(at index: Int)
    func removeCell(at index: Int)
}

protocol LocationTableCellDelegate: AnyObject {
    func locationCellArrowButtonTapped(cell: LocationTableCell)
    func locationCellLocateButtonTapped(location: Location)
}

class LocationsViewController: UIViewController {
	
    var presenter: LocationsPresenterProtocol!
    
    var tableNeedsUpdate: TableViewUpdate = .none
    var prevKey = ""
    
    let locationsTable: UITableView = {
        let table = UITableView()
        table.register(LocationTableCell.self, forCellReuseIdentifier: LocationTableCell.id)
        table.separatorStyle = .none
        table.estimatedRowHeight = UITableView.automaticDimension
        table.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        table.backgroundColor = .white
        return table
    }()
    
    let searchController: UISearchController = {
        let search = UISearchController()
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search"
        search.definesPresentationContext = true
        search.hidesNavigationBarDuringPresentation = false
        search.searchBar.textField?.layer.cornerRadius = 10
        search.searchBar.textField?.borderStyle = .none
        search.searchBar.textField?.backgroundColor = .white
        search.searchBar.textField?.layer.borderColor = UIColor(named: "mint-dark")?.cgColor
        search.searchBar.textField?.layer.borderWidth = 1
        return search
    }()
    
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .gray
        spinner.style = .gray
        return spinner
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Locations"
        label.textColor = .black
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 18.0)
        return label
    }()
    
    let progressLabel: UILabel = {
        let label = UILabel()
        label.text = "Searching..."
        label.textColor = .black
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 18.0)
        return label
    }()
    
    let navigationTitleStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
    }()
    
    override func loadView() {
        super.loadView()
        view = locationsTable
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationsTable.delegate = self
        locationsTable.dataSource = self
        
        searchController.searchResultsUpdater = self
        
        navigationTitleStack.addArrangedSubview(spinner)
        navigationTitleStack.addArrangedSubview(progressLabel)
        
        configureBars()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        switch tableNeedsUpdate {
        case .reload(let cellID):
            locationsTable.beginUpdates()
            locationsTable.reloadRows(at: [IndexPath(row: cellID, section: 0)], with: .automatic)
            locationsTable.endUpdates()
        case .move(let prevCellID, let newCellID):
            locationsTable.beginUpdates()
            locationsTable.moveRow(at: IndexPath(row: newCellID, section: 0), to: IndexPath(row: prevCellID, section: 0))
            locationsTable.endUpdates()
            locationsTable.reloadRows(at: [IndexPath(row: newCellID, section: 0)], with: .automatic)
        case .insert(let cellID):
            locationsTable.beginUpdates()
            locationsTable.insertRows(at: [IndexPath(row: cellID, section: 0)], with: .automatic)
            locationsTable.endUpdates()
        case .remove(let cellID):
            locationsTable.beginUpdates()
            locationsTable.deleteRows(at: [IndexPath(row: cellID, section: 0)], with: .automatic)
            locationsTable.endUpdates()
        case .none:
            break
        }
        tableNeedsUpdate = .none
    }
    
    func configureBars() {
        guard
            let navBar = navigationController?.navigationBar,
            let tabBar = tabBarController?.tabBar
        else { return }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "add"),
            style: .plain, target: self,
            action: #selector(didTapAddButton)
        )
        navigationItem.titleView = titleLabel
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "list"), tag: 0)
        tabBarItem.imageInsets = UIEdgeInsets.init(top: 5, left: 0, bottom: -5, right: 0)
        
        
        if #available(iOS 13.0, *) {
            let appearance = UIBarAppearance()
            appearance.backgroundColor = UIColor(named: "mint-light")
            appearance.shadowColor = .clear
            
            let navBarAppearance = UINavigationBarAppearance(barAppearance: appearance)
            navBar.standardAppearance = navBarAppearance
            navBar.scrollEdgeAppearance = navBarAppearance
            
            let itemAppearance = UITabBarItemAppearance()
            itemAppearance.normal.iconColor = .white
            itemAppearance.normal.badgeBackgroundColor = UIColor(named: "mint-extra-light")
            
            let tabBarAppearance = UITabBarAppearance(barAppearance: appearance)
            tabBarAppearance.stackedLayoutAppearance = itemAppearance
            tabBarAppearance.inlineLayoutAppearance = itemAppearance
            tabBarAppearance.compactInlineLayoutAppearance = itemAppearance
        
            tabBar.standardAppearance = tabBarAppearance
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = tabBarAppearance
            }
        } else {
            navBar.backgroundColor = UIColor(named: "mint-light")
            navBar.layer.shadowColor = UIColor(named: "mint-light")?.cgColor
            
            tabBar.unselectedItemTintColor = UIColor(named: "mint-extra-light")
            tabBar.backgroundColor = UIColor(named: "mint-light")
            tabBar.layer.shadowColor = UIColor(named: "mint-light")?.cgColor
        }
    }
    
    @objc func didTapAddButton() {
        presenter.addLocationViaEditor()
    }
}

extension LocationsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let currentKey = searchController.searchBar.text ?? ""
        if prevKey == currentKey { return }
        prevKey = currentKey
        
        spinner.startAnimating()
        navigationItem.titleView = navigationTitleStack
        presenter.updateSearchResults(by: currentKey) { [weak self] in
            guard let self = self else { return }
            self.locationsTable.reloadData()
            self.navigationItem.titleView = self.titleLabel
            self.spinner.stopAnimating()
        }
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
        let action = UIContextualAction(style: .normal, title: nil) { (_, _, complete) in
            complete(true)
            self.presenter.editLocationViaEditor(location: indexPath.row)
        }
        action.backgroundColor = .white
        action.image = UIImage(named: "edit")
        return action
    }
    
    func delete(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: nil) { (_, _, complete) in
            complete(true)
            self.presenter.removeLocation(at: indexPath.row)
            self.locationsTable.deleteRows(at: [indexPath], with: .automatic)
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? LocationTableCell else { return }
        cell.prepareToDisplay()
    }
}

extension LocationsViewController: LocationsViewProtocol {
    func insertCell(at index: Int) {
        tableNeedsUpdate = .insert(cellID: index)
    }
    
    func moveCell(at prevID: Int, to newID: Int) {
        tableNeedsUpdate = .move(prevCellID: prevID, newCellID: newID)
    }
    
    func reloadCell(at index: Int) {
        tableNeedsUpdate = .reload(cellID: index)
    }
    
    func removeCell(at index: Int) {
        tableNeedsUpdate = .remove(cellID: index)
    }
}

extension LocationsViewController: LocationTableCellDelegate {
    
    func locationCellArrowButtonTapped(cell: LocationTableCell) {
        locationsTable.beginUpdates()
        cell.switchDetailsAppearance()
        locationsTable.endUpdates()
    }
    
    func locationCellLocateButtonTapped(location: Location) {
        presenter.showSingleLocation(location: location)
    }
}
