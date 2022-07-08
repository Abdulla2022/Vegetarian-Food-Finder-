//
//  ApiManger.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/7/22.
//

import UIKit

final class ApiManger {
    
    private class ApiConstant {
        static let ApiUrl = "https://api.yelp.com/v3/businesses/search?location=SF&categories=vegetarian"
        static let apiKey = "_fWbIvhY5n5FFDT2iiUnJ2BKwupqLzTbqd7kFco46l6cioKrn2-VnnIU_97bEEJG5Tp-XeHsdcSYWTXV0tO4vFTzq61DbeLrbcA1d0g6wjQ46AzI2gnV3iuCvtHFYnYx"
    }
    
    func makeBusinessRequest() {
        let apikey = Constants.apiKey
        let url = URL(string: ApiConstant.ApiUrl)
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print(err.localizedDescription)
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                print(">>>>>", json, #line, "<<<<<<<<<")
            } catch {
                print("caught")
            }
        }
        .resume()
    }
}
