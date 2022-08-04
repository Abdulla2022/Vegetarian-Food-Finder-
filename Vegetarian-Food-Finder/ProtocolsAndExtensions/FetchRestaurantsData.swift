//
//  fetchRestaurantsData.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/18/22.
//

import UIKit

protocol fetchRestaurantsData: AnyObject {
    func getResturantsData(completion: @escaping ([Business]) -> Void)
    func getResturantsDetails(query: String, completion: @escaping ([WeekDetails]) -> Void)
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

    func getResturantsDetails(query: String, completion: @escaping ([WeekDetails]) -> Void) {
        Task {
            do {
                let restaurantList: [WeekDetails] = try await YelpApi.searchVeggiBusinessesDetails(query: query)
                completion(restaurantList)
            } catch {
                showOkActionAlert(withTitle: "Can't get the data of details", andMessage: "the server cannot process the request")
            }
        }
    }
}
