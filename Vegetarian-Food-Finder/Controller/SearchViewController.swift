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
        let scopeString = searchController.searchBar.scopeButtonTitles![searchController.searchBar.selectedScopeButtonIndex]
        return filterForTextSearch(searchText: searchController.searchBar.text ?? "", scopeButtonText: scopeString)
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
        searchController.searchBar.scopeButtonTitles = ["All", "Top Rated", "Affordable", "Near by"]
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueFromSearchToDetails {
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedRestaurant = activeRestaurantsList[indexPath.row]
            let detailsVc = segue.destination as? DetailsViewController
            detailsVc?.selectedRestaurant = selectedRestaurant
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        tableView.reloadData()
    }

    func filterForTextSearch(searchText: String, scopeButtonText: String = "All") -> [Business] {
        if searchText == "" {
            return filterWithScopeButton(searchFilteredBusiness: restaurantList, scopeButton: Self.FilterType(rawValue: scopeButtonText) ?? .all)
        }
        let searchFilteredBusiness = restaurantList.filter { business in
            business.name.lowercased().contains(searchText.lowercased())
        }
        return filterWithScopeButton(searchFilteredBusiness: searchFilteredBusiness, scopeButton: SearchViewController.FilterType(rawValue: scopeButtonText) ?? .all)
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        tableView.reloadData()
    }

    enum FilterType: String {
        case all = "All"
        case topRated = "Top Rated"
        case nearBy = "Near by"
        case affordable = "Affordable"
    }

    func filterWithScopeButton(searchFilteredBusiness: [Business], scopeButton: FilterType) -> [Business] {
        switch scopeButton {
        case FilterType.all:
            return searchFilteredBusiness
        case .topRated:
            return filterTopRatedBusiness(businessess: searchFilteredBusiness)
        case .nearBy:
            return filterNearByBusiness(businessess: searchFilteredBusiness)
        case .affordable:
            return filterAffordableBusiness(businessess: searchFilteredBusiness)
        }
    }

    func filterTopRatedBusiness(businessess: [Business]) -> [Business] {
        return businessess.filter { business in
            business.rating >= 4.0
        }
    }

    func filterNearByBusiness(businessess: [Business]) -> [Business] {
        return businessess.filter { business in
            business.distance <= 1500
        }
    }

    func filterAffordableBusiness(businessess: [Business]) -> [Business] {
        return businessess.filter { business in
            business.priceValue <= 2
        }
    }
}
