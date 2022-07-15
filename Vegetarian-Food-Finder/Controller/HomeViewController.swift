//
//  HomeViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/5/22.
//
import CoreLocation
import Parse
import UIKit

final class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    @IBOutlet var tableView: UITableView!
    private var locationManager: CLLocationManager?
    private var longitudeOfUser: Double = 0.0
    private var latitudeOfUser: Double = 0.0
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
        getUserLocation()
        getResturantsData()
    }

    private func getUserLocation() {
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
    }

    private func getResturantsData() {
        Task {
            do {
                self.restaurantsList = try await YelpApi().searchVeggiBusinessesInSF()
            } catch {
                showOkActionAlert(withTitle: "Can't get the data", andMessage: "the server cannot process the request")
            }
        }
    }

    // Still working on this
    private func recommendBasedOnPrice() -> [String: String] {
        var restaurantsPrices: [String: String] = [:]
        for restaurant in restaurantsList {
            restaurantsPrices[restaurant.name] = restaurant.price
        }
        let sortedTubleArray = restaurantsPrices.sorted(by: { $0.value > $1.value })
        let sortedRestaurantsPrices = sortedTubleArray.reduce(into: [:]) { $0[$1.0] = $1.1 }
        return sortedRestaurantsPrices
    }

    private func recommendBasedOnRating() -> [String: Double] {
        var restaurantsRatings: [String: Double] = [:]
        for resturant in restaurantsList {
            restaurantsRatings[resturant.name] = resturant.rating
        }
        let sortedTubleArray = restaurantsRatings.sorted(by: { $0.value > $1.value })
        let sortedRestaurantsRatings = sortedTubleArray.reduce(into: [:]) { $0[$1.0] = $1.1 }
        return sortedRestaurantsRatings
    }

    private func distanceToRestaurant() -> [String: Double] {
        var distancesToResturants: [String: Double] = [:]
        let UserLocaiton = CLLocation(latitude: latitudeOfUser, longitude: longitudeOfUser)
        for restaurant in restaurantsList {
            let resturantLocation = CLLocation(latitude: restaurant.coordinates!.latitude, longitude: restaurant.coordinates!.longitude)
            let distance = UserLocaiton.distance(from: resturantLocation)
            distancesToResturants[restaurant.name] = distance
        }
        return distancesToResturants
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

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            latitudeOfUser = location.coordinate.latitude
            longitudeOfUser = location.coordinate.longitude
        }
    }
}
