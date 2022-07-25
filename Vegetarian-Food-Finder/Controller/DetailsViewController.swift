//
//  DetailsViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/12/22.
//

import UIKit

class DetailsViewController: UIViewController {
    // will use optional (?) instead of forced unwrapping (!) later
    var selectedRestaurant: Business?
    private let detailsCell = "detailsCell"
    @IBOutlet var nameOfResturant: UILabel!
    @IBOutlet var imageOfResturant: UIImageView!
    @IBOutlet var resturantAddress: UILabel!
    @IBOutlet var ratingOfResturant: UILabel!
    @IBOutlet var reviewCountOfRestaurant: UILabel!

    @IBOutlet var category: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureRestaurnat()
    }

    @IBAction func didTapLike(_ sender: Any) {
    }

    private func configureRestaurnat() {
        nameOfResturant.text = selectedRestaurant?.name
        ratingOfResturant.text = "\(selectedRestaurant?.rating)"
        let address = selectedRestaurant?.location.address1
        let state = selectedRestaurant?.location.state
        let city = selectedRestaurant?.location.city
        let zipCode = selectedRestaurant?.location.zipCode
        let country = selectedRestaurant?.location.country
        resturantAddress.text = "\(address),\(city),\(zipCode),\(state),\(country)"
        imageOfResturant.load(url: selectedRestaurant!.imageUrl)
        reviewCountOfRestaurant.text = "\(selectedRestaurant?.reviewCount)"
        category.text = selectedRestaurant?.categories?[1].title
    }
}
