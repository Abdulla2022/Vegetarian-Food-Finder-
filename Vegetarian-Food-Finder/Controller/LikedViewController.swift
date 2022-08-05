//
//  LikedViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/22/22.
//

import Parse
import UIKit
// still working on this class 
final class LikedViewController: UIViewController, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    var likedRestaurantsList: [BusinessDetails] = []
    var likedRestaurnats = [LikedRestaurantPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        getlikedRestaurantList()
    }
    
    func getlikedRestaurantList() {
        for restaurnat in likedRestaurnats {
            getResturantsDetails(query: restaurnat.restaurantId) { restaurantDetails in
                self.likedRestaurantsList.append(restaurantDetails)
            }
        }
    }
    
    func getPostsFromParse() {
        let query = PFQuery(className: "LikedRestaurantPost")
        query.findObjectsInBackground { [weak self] post, _ in
            guard let self = self else { return }
            if let post = post {
                self.likedRestaurnats = post as! [LikedRestaurantPost]
            }
            self.showOkActionAlert(withTitle: "Faild", andMessage: "Faild to get the data from Parse")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedRestaurnats.count
    }
    func getResturantsDetails(query: String, completion: @escaping (BusinessDetails) -> Void) {
        Task {
            do {
                let restaurantList: BusinessDetails = try await YelpApi.searchVeggiBusinessesDetails(query: query)
                completion(restaurantList)
            } catch {
                showOkActionAlert(withTitle: "Can't get the data of details", andMessage: "the server cannot process the request")
            }
        }
    }
}
