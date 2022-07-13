//
//  HomeViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/5/22.
//
import Parse
import UIKit

final class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    var restaurants: [Business] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getResturantsData()
    }

    private func getResturantsData() {
        Task {
            do {
                self.restaurants = try await YelpApi().searchVeggiBusinessesInSF()
            } catch {
                let alertController = UIAlertController(title: "Can get the data", message: "the server cannot process the request", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    @IBAction func didTapLogOut(_ sender: UIButton) {
        PFUser.logOut()
        view.window?.rootViewController = LoginViewController.viewController
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.resturantCell, for: indexPath) as! RestaurantCell
        let restaurant = restaurants[indexPath.row]
        cell.restaurant = restaurant
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.segueFromHomeToDetails, sender: self)
    }
}
