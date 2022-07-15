//
//  SearchViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/5/22.
//
import UIKit

final class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    @IBOutlet var tableView: UITableView!
    let searchController = UISearchController()
    var restaurantList: [Business] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    var filteredRestaurantsList: [Business] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        setUpSearchController()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        getResturantsData()
    }

    private func getResturantsData() {
        Task {
            do {
                self.restaurantList = try await YelpApi().searchVeggiBusinessesInSF()
            } catch {
                showOkActionAlert(withTitle: "Can't get the data", andMessage: "the server cannot process the request")
            }
        }
    }

    func setUpSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.placeholder = "Search"
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.scopeButtonTitles = ["All", "Near By", "Top Rated", "Affordable"]
        searchController.searchBar.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filteredRestaurantsList.count : restaurantList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.searchBarCell, for: indexPath) as! SearchBarCell
        let thisRestaurant = searchController.isActive ? filteredRestaurantsList[indexPath.row] : restaurantList[indexPath.row]
        cell.configure(for: thisRestaurant)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.segueFromSearchToDetails, sender: self)
    }

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text!
        filterForTextSearch(searchText: searchText)
    }

    func filterForTextSearch(searchText: String) {
        filteredRestaurantsList = restaurantList.filter({ Business in
            if searchController.searchBar.text != "" {
                let searchTextMatch = Business.name.lowercased().contains(searchText.lowercased())
                return searchTextMatch
            }
            return true
        })
        tableView.reloadData()
    }
}
