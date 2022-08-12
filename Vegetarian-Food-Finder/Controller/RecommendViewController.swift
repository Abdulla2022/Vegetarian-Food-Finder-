//
//  RecommendViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/20/22.
//

import UIKit

final class RecommendViewController: UIViewController, StoryboardIdentifiable {
    var restaurantsList: [Business] = []
    var selectedRestaurant: RestaurantScore?
    @IBOutlet var reccommendBtnLabel: UIButton!
    @IBOutlet var distanceWeight: UILabel!
    @IBOutlet var ratingWeight: UILabel!
    @IBOutlet var priceWeight: UILabel!
    @IBOutlet var priceSlider: UISlider!
    @IBOutlet var ratingSlider: UISlider!
    @IBOutlet var distanceSlider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        setBtns(selectedBtn: reccommendBtnLabel)
    }

    @IBAction func priceSliderChanged(_ sender: UISlider) {
        priceWeight.text = String(format: "%.2f", sender.value)
    }

    @IBAction func ratingSliderChanged(_ sender: UISlider) {
        ratingWeight.text = String(format: "%.2f", sender.value)
    }

    @IBAction func DistanceSliderChanged(_ sender: UISlider) {
        distanceWeight.text = String(format: "%.2f", sender.value)
    }

    @IBAction func recommendPressed(_ sender: Any) {
        let calculator = ScoreCalculator(restaurantsList: restaurantsList)
        let scoreList = calculator.calculateScoreRestaurant(
            priceWeight: Double(priceSlider.value),
            ratingWeight: Double(ratingSlider.value),
            distanceWeight: Double(distanceSlider.value)
        )
        let topFiveRestaurants = scoreList.prefix(5)
        selectedRestaurant = topFiveRestaurants.randomElement()
        showDetails()
    }

    private func showDetails() {
        let detailsVC: DetailsViewController = RecommendViewController.storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailsVC.selectedRestaurant = selectedRestaurant?.restaurnt
        present(detailsVC, animated: true)
    }
}
