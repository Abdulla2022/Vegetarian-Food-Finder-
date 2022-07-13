//
//  ApiManger.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/7/22.
//
import UIKit

final class YelpApi {
    private let ApiUrl = "https://api.yelp.com/v3"
    private let apiKey = "_fWbIvhY5n5FFDT2iiUnJ2BKwupqLzTbqd7kFco46l6cioKrn2-VnnIU_97bEEJG5Tp-XeHsdcSYWTXV0tO4vFTzq61DbeLrbcA1d0g6wjQ46AzI2gnV3iuCvtHFYnYx"

    private enum serviceError: Error {
        case invalidStatusCode
    }

    func searchVeggiBusinessesInSF() async throws -> [Business] {
        let apiPath = "/businesses/search?location=SF&categories=vegetarian"
        let url = URL(string: ApiUrl + apiPath)
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw serviceError.invalidStatusCode
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dataResults = try decoder.decode(SearchResults.self, from: data)
        return dataResults.businesses
    }
}
