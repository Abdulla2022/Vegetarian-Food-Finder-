//
//  ScoreCalculatore.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/21/22.
//

import Foundation

/// A class that is responsible for the calculation of the total score of each restaurant
final class ScoreCalculator {
    let restaurantsList: [Business]
    init(
        restaurantsList: [Business]
    ) {
        self.restaurantsList = restaurantsList
    }

    /// computed property that represents the number of restaurants
    private var length: Double {
        Double(restaurantsList.count)
    }

    /// computed property that returns double representing the average of the distances of the restaurants
    private var distanceAvg: Double {
        let totalDistances = restaurantsList.reduce(0) { total, restaurant in
            total + restaurant.distance
        }
        return totalDistances / length
    }

    /// computed property that returns double representing the average of the prices of the restaurants
    private var priceAvg: Double {
        let totalPrices = restaurantsList.reduce(0) { total, restaurant in
            total + restaurant.priceValue
        }
        return totalPrices / length
    }

    /// computed property that returns double representing the average of the ratings of the restaurants
    private var ratingAvg: Double {
        let totalRating = restaurantsList.reduce(0) { total, restaurant in
            total + restaurant.rating
        }
        return totalRating / length
    }

    /// computed property that returns double representing the standard deviation value of the distances of the restaurants
    private var distanceStdv: Double {
        let distanceSigmas = restaurantsList.map { restaurant in
            pow(restaurant.distance - distanceAvg, 2.0)
        }
        let sum = distanceSigmas.reduce(0, +)
        return sqrt(sum / length)
    }

    /// computed property that returns double representing the standard deviation value of the prices of the restaurants
    private var priceStdv: Double {
        let priceSigmas = restaurantsList.map { restaurant in
            pow(restaurant.priceValue - priceAvg, 2.0)
        }
        let sum = priceSigmas.reduce(0, +)
        return sqrt(sum / length)
    }

    /// computed property that returns double representing the standard deviation value of the ratings of the restaurants
    private var ratingStdv: Double {
        let ratingSigmas = restaurantsList.map { restaurant in
            pow(restaurant.rating - ratingAvg, 2.0)
        }
        let sum = ratingSigmas.reduce(0, +)
        return sqrt(sum / length)
    }

    /**
      calculate the z scores for each dimension and then uses the calculated z scores to get  the total score for each restaurant

     - parameter  priceWeight: A double value provided by the user.
     - parameter ratingWeight: A double value provided by the user..
     - parameter distacneWeight: A double value provided by the user..
     */
    func calculateScoreRestaurant(
        priceWeight: Double,
        ratingWeight: Double,
        distanceWeight: Double
    ) -> [RestaurantScore] {
        var scoreList = restaurantsList.map { restaurnt -> RestaurantScore in
            let pricezScore = (restaurnt.priceValue - priceAvg) / priceStdv
            let ratigzScore = (restaurnt.rating - ratingAvg) / ratingAvg
            let distanccezScore = (restaurnt.distance - distanceAvg) / distanceStdv
            let priceScore = pricezScore * Double(priceWeight)
            let ratingScore = ratigzScore * Double(ratingWeight)
            let distanceScore = distanccezScore * Double(distanceWeight)
            let totalzScore = priceScore + ratingScore + distanceScore
            return RestaurantScore(
                priceZScore: priceScore,
                distanceZScore: distanceScore,
                ratingZScore: ratingScore,
                totalZScore: totalzScore,
                restaurnt: restaurnt
            )
        }
        scoreList.sort { scoreA, scoreB in
            scoreA.totalZScore > scoreB.totalZScore
        }
        return scoreList
    }
}
