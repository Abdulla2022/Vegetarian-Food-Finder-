//
//  SearchViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/5/22.
//
import UIKit

final class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController()
    var resturantList = [Resturant]()
    var filteredRestaurantsList = [Resturant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        setUpSearchController()
    }
    
    func setUpSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.placeholder = "Search"
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.scopeButtonTitles = ["All", "Near By", "Top Rated"]
        searchController.searchBar.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchController.isActive){
            return filteredRestaurantsList.count
        }
        return resturantList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.searchBarCell)!
        let thisRestaurant:Resturant!
        if (searchController.isActive){
            thisRestaurant = filteredRestaurantsList[indexPath.row]
        }else{
            thisRestaurant = resturantList[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Constants.segueFromSearchToDetails, sender: self)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
    }
}
