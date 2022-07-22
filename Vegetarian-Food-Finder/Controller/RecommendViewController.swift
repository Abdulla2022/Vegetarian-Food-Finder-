//
//  RecommendViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/20/22.
//

import UIKit

class RecommendViewController: UIViewController {
    let segueFromRecommendToDetails = "segueFromRecommendToDetails"
    var restaurantsList: [Business] = []
    var selectedRestaurant: RestaurantScore!
    @IBOutlet var distanceWeight: UILabel!
    @IBOutlet var ratingWeight: UILabel!
    @IBOutlet var priceWeight: UILabel!
    @IBOutlet var priceSlider: UISlider!
    @IBOutlet var ratingSlider: UISlider!
    @IBOutlet var distanceSlider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let scoreList = calculator.calculateScoreRestaurat(
            priceWeight: Double(priceSlider.value),
            ratingWeight: Double(ratingSlider.value),
            distanceWeight: Double(distanceSlider.value)
        )
        let scoreListSlice = scoreList.prefix(5)
        let topFiveRestaurants = scoreListSlice
        selectedRestaurant = topFiveRestaurants.randomElement()
    }
}
