//
//  LikedRestaurantCell.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 8/2/22.
//

import Contacts
import Foundation
import UIKit
final class LikedRestaurantCell: UITableViewCell {
    @IBOutlet var nameOfResturant: UILabel!
    @IBOutlet var imageOfRestaurant: UIImageView!
    @IBOutlet var resturantAddress: UILabel!
    @IBOutlet var ratingOfResturant: UILabel!
    @IBOutlet var phoneNumber: UILabel!
    func configure(for restaurant: BusinessDetails) {
        nameOfResturant.text = restaurant.name
        ratingOfResturant.text = "\(restaurant.rating)"
        phoneNumber.text = restaurant.displayPhone
        resturantAddress.text = formattedAddress(selectedRestaurant: restaurant)
        imageOfRestaurant.load(url: restaurant.imageUrl)
    }

    func formattedAddress(selectedRestaurant: BusinessDetails) -> String {
        let formatter = CNPostalAddressFormatter()
        let address = CNMutablePostalAddress()
        address.street = (selectedRestaurant.location.address1)
        address.postalCode = (selectedRestaurant.location.zipCode)
        address.city = (selectedRestaurant.location.city)
        address.country = (selectedRestaurant.location.country)
        return formatter.string(from: address)
    }
}
