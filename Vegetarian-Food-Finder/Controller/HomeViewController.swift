//
//  HomeViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/5/22.
//

import MapKit
import Parse
import UIKit
final class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, StoryboardIdentifiable {
    @IBOutlet var reccommendBtnLabel: UIButton!
    private let resturantCell = "RestaurantCell"
    private let segueFromHomeToRecommedned = "segueFromHomeToRecommendView"
    let segueFromHomeToDetails = "SegueFromHomeToDetails"
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
        setBtns(selectedBtn: reccommendBtnLabel)
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
        cell.backgroundColor = .white
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        cell.configure(for: thisrestaurant)
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueFromHomeToDetails {
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedRestaurant = restaurantsList[indexPath.row]
            let detailsVc = segue.destination as? DetailsViewController
            detailsVc?.selectedRestaurant = selectedRestaurant
        } else if segue.identifier == segueFromHomeToRecommedned {
            let recommendVc = segue.destination as? RecommendViewController
            recommendVc?.restaurantsList = restaurantsList
        } else if segue.identifier == segueFromToSearch {
            let navVc = segue.destination as? UINavigationController
            let searchVc = navVc?.topViewController as? SearchViewController
            searchVc?.restaurantList = restaurantsList
        }
    }

    @IBAction func didTapDirections(_ sender: Any) {
        let indexPath = tableView.indexPathForSelectedRow
        guard let indexPath = indexPath else {
            return
        }
        let selectedRestaurant = restaurantsList[indexPath.row]
        guard let lat = selectedRestaurant.coordinates?.latitude,
              let lon = selectedRestaurant.coordinates?.longitude
        else {
            return
        }
        let region: CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(lat, lon)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: region, longitudinalMeters: region)
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        let placeMark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = "\(selectedRestaurant.name)"
        mapItem.openInMaps(launchOptions: options)
    }
}
