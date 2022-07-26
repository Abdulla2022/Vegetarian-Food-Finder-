//
//  DetailsViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/12/22.
//

import Contacts
import UIKit
class DetailsViewController: UIViewController {
    var selectedRestaurant: Business?
    private let detailsCell = "detailsCell"
    @IBOutlet var nameOfResturant: UILabel!
    @IBOutlet var imageOfResturant: UIImageView!
    @IBOutlet var resturantAddress: UILabel!
    @IBOutlet var ratingOfResturant: UILabel!
    @IBOutlet var reviewCountOfRestaurant: UILabel!

    @IBOutlet var category: UILabel!

    @IBOutlet var phoneNumberLabel: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureRestaurnat()
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        imageOfResturant.addGestureRecognizer(doubleTap)
    }

    @IBOutlet var likeBtn: UIButton!

    @IBAction func didTapLike(_ sender: Any) {
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
        let size = gestureView.frame.size.width / 4
        let heart = UIImageView(image: UIImage(systemName: "heart.fill"))
        heart.frame = CGRect(
            x: (gestureView.frame.size.width - size) / 2,
            y: (gestureView.frame.size.height - size) / 2,
            width: size,
            height: size)
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
}
