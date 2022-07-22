//
//  Business.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/11/22.
//
import Foundation

struct SearchResults: Codable {
    let total: Int
    let businesses: [Business]
}

struct Business: Codable, Identifiable {
    let rating: Double
    let id: String
    let name: String
    var price: String
    let distance: Double
    let imageUrl: URL
    let reviewCount: Int
    let categories: [categories]?
    let location: Location
    let coordinates: Coordinates?
    let url: String
    let phone: String
    var priceValue: Double {
        Double(price.count)
    }
}

struct RestaurantScore {
    let priceZScore: Double
    let distanceZScore: Double
    let ratingZScore: Double
    let totalZScore: Double
    let restaurnt: Business
}

struct Coordinates: Codable {
    let latitude: Double
    let longitude: Double
}

struct Location: Codable {
    let city: String
    let country: String
    let address2: String?
    let address3: String?
    let state: String
    let address1: String
    let zipCode: String
}

struct categories: Codable {
    let alias: String
    let title: String
}
