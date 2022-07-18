//
//  HomeViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/5/22.
//
import CoreLocation
import Parse
import UIKit

final class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
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

    @IBAction func didTapRecommendCheapRestaurant(_ sender: Any) {
    }

    @IBAction func didTapRecommendFancyRestaurant(_ sender: Any) {
    }

    @IBAction func didTapLogOut(_ sender: UIButton) {
        PFUser.logOut()
        view.window?.rootViewController = LoginViewController.viewController
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.resturantCell, for: indexPath) as! RestaurantCell
        let thisrestaurant = restaurantsList[indexPath.row]
        cell.configure(for: thisrestaurant)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.segueFromHomeToDetails, sender: self)
    }
}
