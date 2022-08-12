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
    @IBOutlet var imageofRestaurant: UIImageView!
    @IBOutlet var resturantAddress: UILabel!
    @IBOutlet var ratingOfResturant: UILabel!
    @IBOutlet weak var OperatingHrsLabel: UIButton!
    @IBOutlet var reviewCountOfRestaurant: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var category: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var likeBtn: UIButton!
    @IBOutlet weak var distanceToRestaurant: UILabel!
    var isLiked: Bool = false
    var likedRestaurnats = [LikedRestaurantPost]()
    var restaurantDetails: BusinessDetails?
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
        setBtns(selectedBtn: OperatingHrsLabel)
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        imageofRestaurant.addGestureRecognizer(doubleTap)
        getResturantsReviewData(query: selectedRestaurant!.id) { restaurantReviewDetails in
            self.restaurantReviewData = restaurantReviewDetails
        }
        getResturantsDetails(query: selectedRestaurant!.id) { restaurantDetails in
            self.restaurantDetails = restaurantDetails
        }
        checkLikeStatus()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NotificationCenter.default.addObserver(self, selector: #selector(likeStatus), name: Notification.Name(rawValue: "DetailsLikeStatus"), object: nil)
        tableView.reloadData()
    }
    
    @objc func likeStatus() {
        likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    func checkLikeStatus(){
        guard let restaurant = selectedRestaurant else {
            return
        }
        LikedRestaurantPost.checkIfLiked(restaurantID: restaurant.id) { likedRestaurant in
            if likedRestaurant != nil{
                self.likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                self.likeBtn.tintColor = .red
                return
            }
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
        ratingOfResturant.text = "Rating: \(restaurant.rating)"
        resturantAddress.text = formattedAddress()
        imageofRestaurant.load(url: restaurant.imageUrl)
        reviewCountOfRestaurant.text = "Review Count \(restaurant.reviewCount)"
        category.text = restaurant.categories?[1].title
        phoneNumberLabel.text = restaurant.phone
        let restaurantDistantce = (restaurant.distance)/1609.344
        let formattedDistance = String(format: " Distance : %.2fmi", restaurantDistantce)
        distanceToRestaurant.text = "\(formattedDistance)"
    }

    @IBAction func didTapLike(_ sender: Any) {
        guard let selectedRestaurant = selectedRestaurant else {
            return
        }
        LikedRestaurantPost.updateLikeRestaurant(restaurantID: selectedRestaurant.id) { isLiked in
            if isLiked {
                self.likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                self.likeBtn.tintColor = .red
                return
            }
            self.likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }

    
    @objc private func didDoubleTap(_ gesture: UITapGestureRecognizer) {
        guard let gestureView = gesture.view else {
            return
        }
        guard let selectedRestaurant = selectedRestaurant else {
            return
        }
        LikedRestaurantPost.createRestaurantLike(restaurantID: selectedRestaurant.id)
        let sideLength = gestureView.frame.size.width / 8
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

    func getResturantsReviewData(query: String, completion: @escaping ([BusinessReview]) -> Void) {
        Task {
            do {
                let restaurantReviews: [BusinessReview] = try await YelpApi.searchVeggiBusinessesReviews(query: query)
                completion(restaurantReviews)
            } catch {
                showOkActionAlert(withTitle: "Can't get the data for wreviews", andMessage: "the server cannot process the request")
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
