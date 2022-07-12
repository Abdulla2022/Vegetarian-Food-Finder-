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
    
    func searchVeggiBusinessesInSF() async throws -> [Business] {
        let apiPath = "/businesses/search?location=SF&categories=vegetarian"
        let url = URL(string: ApiUrl + apiPath)
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        do{
            let(data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let jsonString = String(data: data, encoding: .utf8){
            }
            let dataResults = try decoder.decode(SearchResults.self, from: data)
            return dataResults.businesses
        }catch {
            print(error)
            return []
        }
    }
}
