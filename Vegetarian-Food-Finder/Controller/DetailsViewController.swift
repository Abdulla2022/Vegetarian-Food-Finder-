//
//  DetailsViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/12/22.
//

import Contacts
import Parse
import UIKit

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var selectedRestaurant: Business?
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
        getResturantsReviewData(query: selectedRestaurant!.id) { restaurant in
            self.restaurantReviewData = restaurant
        }

//        checkPostStatus()
    }

//    func checkPostStatus() {
//        let query = PFQuery(className: "ParsePost")
//        query.findObjectsInBackground { [weak self] post, _ in
//            if let post = post {
//                self?.likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//                self?.likeBtn.tintColor = .red
//            }
//            self?.showOkActionAlert(withTitle: "Faild", andMessage: "Faild to get the data from Parse")
//        }
//    }

    @IBAction func didTapLike(_ sender: Any) {
        if isLiked == true {
            likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            isLiked = false
            return
        }
        likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        likeBtn.tintColor = .red
        isLiked = true
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

    @IBAction func phoneNumberPressed(_ sender: Any) {
    }

    @objc private func didDoubleTap(_ gesture: UITapGestureRecognizer) {
        guard let gestureView = gesture.view else {
            return
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
                    self.isLiked = true
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
                showOkActionAlert(withTitle: "Can't get the data for reviews", andMessage: "the server cannot process the request")
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: detailsCell, for: indexPath) as! detailsCell
        let thisRestaurantReview = restaurantReviewData[indexPath.row]
        cell.configureReview(for: thisRestaurantReview)
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantReviewData.count
    }
}
