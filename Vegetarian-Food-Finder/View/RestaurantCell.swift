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

    public var restaurant: Business! {
        didSet {
            configureForRestaurants()
        }
    }

    private func configureForRestaurants() {
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

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
