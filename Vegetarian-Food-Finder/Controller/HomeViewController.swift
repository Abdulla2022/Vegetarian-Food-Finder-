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
        // still working on this
        // will handle error
        Task {
            restaurantsList = (try? await YelpApi.searchVeggiBusinessesInSF()) ?? []
        }
    }

    private func getStandardDevation() -> Double {
        let normalizedRestaurantData = restaurantsList
        let length = Double(normalizedRestaurantData.count)
        let avg = getAvg()
        let sumOfSquaredAvgDiffForRating = normalizedRestaurantData.map { pow($0.rating - avg, 2.0) }.reduce(0, +)
        let sumOfSquaredAvgDiffForDistance = normalizedRestaurantData.map { pow($0.distance - avg, 2.0) }.reduce(0, +)
        let sumOfSquaredAvgDiffForPrices = normalizedRestaurantData.map { pow($0.priceValue - avg, 2.0) }.reduce(0, +)
        let stdv = sqrt((sumOfSquaredAvgDiffForPrices + sumOfSquaredAvgDiffForRating + sumOfSquaredAvgDiffForDistance) / (length - 1))
        return stdv
    }

    private func getAvg() -> Double {
        let length = Double(restaurantsList.count)
        var totalDistancesOfRestaurants = 0.0
        var totalPricesOfRestaurants = 0.0
        var totalRatingsOfRrstaurant = 0.0
        for restaurnat in restaurantsList {
            totalPricesOfRestaurants += restaurnat.priceValue
            totalRatingsOfRrstaurant += restaurnat.rating
            totalDistancesOfRestaurants += restaurnat.distance
        }
        return (totalRatingsOfRrstaurant + totalPricesOfRestaurants + totalDistancesOfRestaurants) / length
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
