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
    
    func searchBusinessess(completion: @escaping (_ result :[Business]) -> Void) {
        let apiPath = "/businesses/search?location=SF&categories=vegetarian"
        let url = URL(string: ApiUrl + apiPath)
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print(err.localizedDescription)
            }
            do {
                let dataResults = try JSONDecoder().decode(SearchResults.self, from: data!)
                completion(dataResults.businesses)
            } catch {
                print("caught",error.localizedDescription)
            }
        }
        .resume()
    }
    
}



