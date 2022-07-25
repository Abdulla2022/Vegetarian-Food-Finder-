//
//  ResturantViewCell.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/5/22.
//
import UIKit

protocol RestaurantCellDelegate: AnyObject {
    func didTapOnce(cell: RestaurantCell)
    func didTapTwice(cell: RestaurantCell)
}

final class RestaurantCell: UITableViewCell {
    weak var delegate: RestaurantCellDelegate?

    @IBOutlet var nameOfResturant: UILabel!
    @IBOutlet var imageOfResturant: UIImageView!
    @IBOutlet var resturantAddress: UILabel!
    @IBOutlet var ratingOfResturant: UILabel!

    @IBOutlet var likeImage: UIButton!
    @IBOutlet var likeImageViewWidthConstraint: NSLayoutConstraint!
    lazy var likeAnimator = LikeAnimator(container: contentView, layoutConstraint: likeImageViewWidthConstraint)
    lazy var doubleTapRecognizer: UITapGestureRecognizer = {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapDetected))
        tapRecognizer.numberOfTapsRequired = 2
        return tapRecognizer
    }()

    lazy var singleTapRecognizer: UITapGestureRecognizer = {
        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(singleTapDetected))
        singleTapRecognizer.numberOfTapsRequired = 1
        contentView.addGestureRecognizer(singleTapRecognizer)
        return singleTapRecognizer
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        imageOfResturant.addGestureRecognizer(doubleTapRecognizer)
    }

    @objc func singleTapDetected() {
        delegate?.didTapOnce(cell: self)
    }

    @objc func doubleTapDetected() {
        delegate?.didTapTwice(cell: self)
    }

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
