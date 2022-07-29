//
//  ResturantViewCell.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/5/22.
//

import UIKit

final class RestaurantCell: UITableViewCell {
    @IBOutlet var nameOfResturant: UILabel!
    @IBOutlet var imageOfResturant: UIImageView!
    @IBOutlet var resturantAddress: UILabel!
    @IBOutlet var ratingOfResturant: UILabel!
    @IBOutlet var likeBtn: UIButton!

    func configure(for restaurant: Business) {
        nameOfResturant.text = restaurant.name
        ratingOfResturant.text = "\(restaurant.rating)"
        let address = restaurant.location.address1
        let state = restaurant.location.state
        let city = restaurant.location.city
        let zipCode = restaurant.location.zipCode
        let country = restaurant.location.country
        resturantAddress.text = "\(address),\(city),\(zipCode),\(state),\(country)"
        imageOfResturant.load(url: restaurant.imageUrl)
    }
}
