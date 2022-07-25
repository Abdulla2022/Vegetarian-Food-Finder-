//
//  fetchRestaurantsData.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/18/22.
//

import UIKit

protocol fetchRestaurantsData: AnyObject {
    func getResturantsData(completion: @escaping ([Business]) -> Void)
    func getResturantsReviewData(query: String, completion: @escaping ([BusinessReview]) -> Void)
}

extension HomeViewController: fetchRestaurantsData {
    func getResturantsData(completion: @escaping ([Business]) -> Void) {
        Task {
            do {
                let restaurantList: [Business] = try await YelpApi.searchVeggiBusinessesInSF()
                completion(restaurantList)
            } catch {
                showOkActionAlert(withTitle: "Can't get the data", andMessage: "the server cannot process the request")
            }
        }
    }

    func getResturantsReviewData(query: String, completion: @escaping ([BusinessReview]) -> Void) {
        Task {
            do {
                let restaurantList: [BusinessReview] = try await YelpApi.searchVeggiBusinessesReviews(query: query)
                completion(restaurantList)
            } catch {
                showOkActionAlert(withTitle: "Can't get the data for reviews", andMessage: "the server cannot process the request")
            }
        }
    }
}
