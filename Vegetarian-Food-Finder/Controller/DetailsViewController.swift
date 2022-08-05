//
//  DetailsViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/12/22.
//

import Contacts
import Parse
import UIKit

final class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var selectedRestaurant: Business?
    private let detailsToDatePicker = "fromDetailsToDatePicker"
    private let detailsCell = "detailsCell"
    @IBOutlet var nameOfResturant: UILabel!
    @IBOutlet var imageOfResturant: UIImageView!
    @IBOutlet var resturantAddress: UILabel!
    @IBOutlet var ratingOfResturant: UILabel!
    @IBOutlet var reviewCountOfRestaurant: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var category: UILabel!
    @IBOutlet var phoneNumberLabel: UIButton!
    @IBOutlet var likeBtn: UIButton!
    var isLiked: Bool = false
    var likedRestaurnats = [LikedRestaurantPost]()
    var restaurantDetails:BusinessDetails?
    var restaurantReviewData: [BusinessReview] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        configureRestaurnat()
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        imageOfResturant.addGestureRecognizer(doubleTap)
        getResturantsReviewData(query: selectedRestaurant!.id) { restaurantReviewDetails in
            self.restaurantReviewData = restaurantReviewDetails
        }
        getResturantsDetails(query: selectedRestaurant!.id) { restaurantDetails in
            self.restaurantDetails = restaurantDetails
        }
    }
    
    func formattedAddress() -> String {
        let formatter = CNPostalAddressFormatter()
        let address = CNMutablePostalAddress()
        guard let restaurant = selectedRestaurant else {
            return ""
        }
        address.street = (restaurant.location.address1)
        address.postalCode = (restaurant.location.zipCode)
        address.city = (restaurant.location.city)
        address.country = (restaurant.location.country)
        return formatter.string(from: address)
    }
    
    private func configureRestaurnat() {
        guard let restaurant = selectedRestaurant else {
            return
        }
        nameOfResturant.text = restaurant.name
        ratingOfResturant.text = "\(restaurant.rating)"
        resturantAddress.text = formattedAddress()
        imageOfResturant.load(url: restaurant.imageUrl)
        reviewCountOfRestaurant.text = "\(restaurant.reviewCount)"
        category.text = restaurant.categories?[1].title
        phoneNumberLabel.setTitle("\(restaurant.phone)", for: .normal)
    }
    // stil  working on this 
    @IBAction func didTapLike(_ sender: Any) {
        let isPosted = checkPostStatus()
        guard let selectedRestaurant = selectedRestaurant else {
            return
        }
        if (isLiked == true) || (isPosted == true) {
            LikedRestaurantPost.deletLikedRestaurant(selectedRestaurant) { succeded, error in
                if succeded {
                }else {
                    self.showOkActionAlert(withTitle: "faild", andMessage: "faild to delete the liked restaurant")
                }
            }
            likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            isLiked = false
        }
            LikedRestaurantPost.postLikedRestaurant(selectedRestaurant) { succeeded, error in
                if succeeded {
                } else {
                    self.showOkActionAlert(withTitle: "faild", andMessage: "faild to post To parse after hitting the like button")
                }
            }
        likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        likeBtn.tintColor = .red
        isLiked = true
        return
    }
    
    func checkPostStatus() -> Bool{
        let query = PFQuery(className: "LikedRestaurantPost")
        query.findObjectsInBackground { [weak self] post, _ in
            self?.likedRestaurnats = post as! [LikedRestaurantPost]
        }
        for likedRestaurantObj in self.likedRestaurnats {
            if (likedRestaurantObj.restaurantId == self.selectedRestaurant?.id) &&
                (likedRestaurantObj.author == PFUser.current()) {
                return true
            }
        }
        return false
    }
    
    @objc private func didDoubleTap(_ gesture: UITapGestureRecognizer) {
        guard let gestureView = gesture.view else {
            return
        }
        guard let selectedRestaurant = selectedRestaurant else {
            return
        }
        let isPosted = checkPostStatus()
        if isPosted == false {
            LikedRestaurantPost.postLikedRestaurant(selectedRestaurant) { succeeded, error in
                if succeeded {
                    self.isLiked = true
                } else {
                    self.showOkActionAlert(withTitle: "faild", andMessage: "faild to post To parse after checking that it's not pushed")
                }
            }
        }
        let sideLength = gestureView.frame.size.width / 4
        let heart = UIImageView(image: UIImage(systemName: "heart.fill"))
        heart.frame = CGRect(
            x: (gestureView.frame.size.width - sideLength) / 2,
            y: (gestureView.frame.size.height - sideLength) / 2,
            width: sideLength,
            height: sideLength)
        heart.tintColor = .red
        gestureView.addSubview(heart)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            UIView.animate(withDuration: 1, animations: {
                heart.alpha = 0
            }, completion: { done in
                if done {
                    heart.removeFromSuperview()
                    self.likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    self.likeBtn.tintColor = .red
                }
            })
        })
    }
    
    @IBAction func phoneNumberPressed(_ sender: Any) {
    }
    
    func getResturantsReviewData(query: String, completion: @escaping ([BusinessReview]) -> Void) {
        Task {
            do {
                let restaurantReviews: [BusinessReview] = try await YelpApi.searchVeggiBusinessesReviews(query: query)
                completion(restaurantReviews)
            } catch {
                showOkActionAlert(withTitle: "Can't get the data for reviews", andMessage: "the server cannot process the request")
            }
        }
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: detailsCell, for: indexPath) as! DetailsCell
        let thisRestaurantReview = restaurantReviewData[indexPath.row]
        cell.configureReview(for: thisRestaurantReview)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantReviewData.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailsToDatePicker {
            let DatePickerVC = segue.destination as? DatePickerViewController
            if let restaurantDetails = restaurantDetails {
                DatePickerVC?.restaurantDetails = restaurantDetails
                
            }
        }
    }
}
