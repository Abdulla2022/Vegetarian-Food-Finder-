//
//  HomeViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/5/22.
//
import UIKit
import Parse

final class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    var restaurants: [Business] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        Task{
            let dataFromApi = try await YelpApi().searchVeggiBusinessesInSF()
            self.restaurants = dataFromApi
        }
        tableView.reloadData()
    }
    
    @IBAction func didTapLogOut(_ sender: UIButton) {
        PFUser.logOut()
        self.view.window?.rootViewController = LoginViewController.viewController
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard restaurants.count != 0 else{
            return 0
        }
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.resturantCell, for: indexPath) as! RestaurantCell
        let restaurant  = restaurants[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Constants.segueFromSearchToDetails, sender: self)
    }
    
}
