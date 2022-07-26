//
//  SearchViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/5/22.
//
import UIKit

final class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    private let searchBarCell = "SearchBarCell"
    private let segueFromSearchToDetails = "SegueFromSearchToDetails"
    @IBOutlet var tableView: UITableView!
    let searchController = UISearchController()
    var restaurantList: [Business] = []
    var activeRestaurantsList: [Business] {
        filterForTextSearch(searchText: searchController.searchBar.text ?? "")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        setUpSearchController()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.reloadData()
    }

    func setUpSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.placeholder = "Search"
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeRestaurantsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchBarCell, for: indexPath) as! SearchBarCell
        let thisRestaurant = activeRestaurantsList[indexPath.row]
        cell.configure(for: thisRestaurant)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueFromSearchToDetails, sender: self)
    }

    func updateSearchResults(for searchController: UISearchController) {
        tableView.reloadData()
    }

    func filterForTextSearch(searchText: String) -> [Business] {
        if searchText == "" {
            return restaurantList
        } else {
            let filteredRestaurantsList = restaurantList.filter({ Business in
                if searchText != "" {
                    let searchTextMatch = Business.name.lowercased().contains(searchText.lowercased())
                    return searchTextMatch
                }
                return true
            })
            return filteredRestaurantsList
        }
    }
}
