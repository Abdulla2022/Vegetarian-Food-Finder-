//
//  ResturantViewCell.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/5/22.
//

import Contacts
import UIKit
final class RestaurantCell: UITableViewCell {
    @IBOutlet var nameOfResturant: UILabel!
    @IBOutlet var imageOfResturant: UIImageView!
    @IBOutlet var resturantAddress: UILabel!
    @IBOutlet var ratingOfResturant: UILabel!
    func configure(for restaurant: Business) {
        nameOfResturant.text = restaurant.name
        ratingOfResturant.text = "\(restaurant.rating)"
        let address = formattedAddress(selectedRestaurant: restaurant)
        resturantAddress.text = address
        imageOfResturant.load(url: restaurant.imageUrl)
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
