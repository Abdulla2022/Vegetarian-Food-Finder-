//
//  HomeViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/5/22.
//
import CoreLocation
import Parse
import UIKit

final class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RestaurantCellDelegate, StoryboardIdentifiable {
    private let resturantCell = "RestaurantCell"
    private let segueFromHomeToRecommedned = "segueFromHomeToRecommendView"
    private let segueFromToSearch = "segueFromToSearch"
    @IBOutlet var tableView: UITableView!
    var restaurantsList: [Business] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        getResturantsData { restaurantsData in
            self.restaurantsList = restaurantsData
        }
    }
    
    @IBAction func didTapSearch(_ sender: Any) {
        performSegue(withIdentifier: segueFromToSearch, sender: self)
    }
    
    @IBAction func didTapRecommendARestaurant(_ sender: Any) {
        performSegue(withIdentifier: segueFromHomeToRecommedned, sender: self)
    }
    
    @IBAction func didTapLogOut(_ sender: Any) {
        PFUser.logOut()
        view.window?.rootViewController = LoginViewController.viewController
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: resturantCell, for: indexPath) as! RestaurantCell
        let thisrestaurant = restaurantsList[indexPath.row]
        cell.configure(for: thisrestaurant)
        return cell
    }
    
    func didTapOnce(cell: RestaurantCell) {
        let detailsVC: DetailsViewController = RecommendViewController.storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        let indexPath = tableView.indexPathForSelectedRow!
        let selectedRestaurant = restaurantsList[indexPath.row]
        detailsVC.selectedRestaurant = selectedRestaurant
        present(detailsVC, animated: true)
    }
    
    func didTapTwice(cell: RestaurantCell) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueFromHomeToRecommedned {
            let recommendVc = segue.destination as? RecommendViewController
            recommendVc?.restaurantsList = restaurantsList
        } else if segue.identifier == segueFromToSearch {
            let navVc = segue.destination as? UINavigationController
            let searchVc = navVc?.topViewController as? SearchViewController
            searchVc?.restaurantList = restaurantsList
        }
    }
}
