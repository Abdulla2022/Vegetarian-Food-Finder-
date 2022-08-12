//
//  LikedViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/22/22.
//

import Parse
import UIKit
final class LikedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let cellSpacingHeight: CGFloat = 5
    @IBOutlet var tableView: UITableView!
    let segueToDetails = "fromLikesViewTODetails"
    let restaurantCell = "LikedRestaurantCell"
    let refreshControl = UIRefreshControl()
    var likedListPFObjects = [PFObject]()
    var likedRestaurantsList: [BusinessDetails] = [] {
        didSet {
            tableView.reloadData()
            return likedRestaurantsList.reverse()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        getLikedRestauarntsFromParse()
    }

    func getlikedRestaurantListFromApi(likedrestaurants: [PFObject]) {
        for restaurnat in likedrestaurants {
            getResturantsDetails(query: restaurnat["restaurantID"] as! String) { restaurantDetails in
                guard let existingIndex = self.likedRestaurantsList.firstIndex(where: { restaurantIndex in
                    restaurantIndex.id == restaurantDetails.id
                }) else {
                    self.likedRestaurantsList.append(restaurantDetails)
                    return
                }
                self.likedRestaurantsList.remove(at: existingIndex)
                self.likedRestaurantsList.append(restaurantDetails)
            }
        }
    }

    @objc func refresh(_ sender: AnyObject) {
        getLikedRestauarntsFromParse()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }

    func getLikedRestauarntsFromParse() {
        LikedRestaurantPost.getAllLikedRestaurantByUser { parsRestaurantsObjs in
            self.likedListPFObjects = parsRestaurantsObjs
            self.getlikedRestaurantListFromApi(likedrestaurants: self.likedListPFObjects)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedRestaurantsList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: restaurantCell, for: indexPath) as! LikedRestaurantCell
        let thisrestaurant = likedRestaurantsList[indexPath.row]
        cell.backgroundColor = .white
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        cell.configure(for: thisrestaurant)
        return cell
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DetailsLikeStatus"), object: nil)
            likedRestaurantsList.remove(at: indexPath.row)
            let selectedParseObj = likedListPFObjects[indexPath.row]
            LikedRestaurantPost.deleteRestaurantLike(restaurant: selectedParseObj)
        }

        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
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
