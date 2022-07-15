//
//  SearchBarCell.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/12/22.
//
import UIKit

class SearchBarCell: UITableViewCell {
    @IBOutlet var restaurantNameLabel: UILabel!
    @IBOutlet var restaurantAddressLabel: UILabel!
    @IBOutlet weak var restaurantCategory: UILabel!
    @IBOutlet weak var resturantReviewCount: UILabel!
    @IBOutlet var restaurantRating: UILabel!
    @IBOutlet var restaurantImage: UIImageView!
    
     func configure(for restaurant:Business) {
        restaurantNameLabel.text = restaurant.name
        restaurantRating.text = "\(restaurant.rating)"
        let address = restaurant.location.address1
        let state = restaurant.location.state
        let city = restaurant.location.city
        let zipCode = restaurant.location.zipCode
        let country = restaurant.location.country
        restaurantAddressLabel.text = "\(address),\(city),\(zipCode),\(state),\(country)"
        restaurantImage.load(url: restaurant.imageUrl)
        resturantReviewCount.text = "\(restaurant.reviewCount)"
    }
}
