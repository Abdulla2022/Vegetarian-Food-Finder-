//
//  SearchViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/5/22.
//
import UIKit

final class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    let searchBarCell = "SearchBarCell"
    let segueFromSearchToDetails = "SegueFromSearchToDetails"
    @IBOutlet var tableView: UITableView!
    let searchController = UISearchController()
    var restaurantsList: [Business] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        setUpSearchController()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        setUpSearchController()
        tableView.reloadData()
    }

    func setUpSearchController() {
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
        return restaurantsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchBarCell, for: indexPath) as! SearchBarCell
        let thisRestaurant = restaurantsList[indexPath.row]
        cell.configure(for: thisRestaurant)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueFromSearchToDetails, sender: self)
    }
}
