//
//  detailsCell.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/27/22.
//

import UIKit

final class DetailsCell: UITableViewCell {
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var createdDateLabel: UILabel!
    @IBOutlet var reviewTextLabel: UILabel!

    func configureReview(for restaurant: BusinessReview) {
        userNameLabel.text = restaurant.user.name
        createdDateLabel.text = restaurant.timeCreated
        reviewTextLabel.text = restaurant.text
    }
}
