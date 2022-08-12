//
//  SearchBarCell.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/12/22.
//

import Contacts
import UIKit
final class SearchBarCell: UITableViewCell {
    @IBOutlet var restaurantNameLabel: UILabel!
    @IBOutlet var restaurantAddressLabel: UILabel!
    @IBOutlet var restaurantCategory: UILabel!
    @IBOutlet var resturantReviewCount: UILabel!
    @IBOutlet var restaurantRating: UILabel!
    @IBOutlet var restaurantImage: UIImageView!

    func configure(for restaurant: Business) {
        restaurantNameLabel.text = restaurant.name
        restaurantRating.text = "Rating: \(restaurant.rating)"
        let address = formattedAddress(selectedRestaurant: restaurant)
        restaurantAddressLabel.text = address
        restaurantImage.load(url: restaurant.imageUrl)
        resturantReviewCount.text = "Reviews \(restaurant.reviewCount)"
    }

    func formattedAddress(selectedRestaurant: Business) -> String {
        let formatter = CNPostalAddressFormatter()
        let address = CNMutablePostalAddress()
        address.street = (selectedRestaurant.location.address1)
        address.postalCode = (selectedRestaurant.location.zipCode)
        address.city = (selectedRestaurant.location.city)
        address.country = (selectedRestaurant.location.country)
        return formatter.string(from: address)
    }
}
