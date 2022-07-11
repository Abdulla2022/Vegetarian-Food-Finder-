//
//  Business.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/11/22.
//

struct SearchResults: Codable {
    let total: Int
    let businesses: [Business]
}

struct Business: Codable, Identifiable {
    let id: String
    let name: String
    let price: String
    let distance: Double
    let imageUrl: String
    let coordinates: Coordinates
    let url: String
    let phone: String
}

struct Coordinates: Codable {
    let latitude: Double?
    let longitude: Double?
}
