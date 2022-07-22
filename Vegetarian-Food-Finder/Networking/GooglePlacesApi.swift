//
//  GooglePlacesApi.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/17/22.
//

import CoreLocation
import GooglePlaces
import UIKit
final class GooglePlacesApi {
    static let shared = GooglePlacesApi()
    private let client = GMSPlacesClient.shared()

    private init() {
    }

    enum PlacesError: Error {
        case faildToFind
        case faildToGetCoordinate
    }

    public func findPlaces(query: String, completion: @escaping (Result<[Place], Error>) -> Void) {
        let filter = GMSAutocompleteFilter()
        filter.type = .geocode
        client.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil) { results, error in
            guard let results = results, error == nil else {
                completion(.failure(PlacesError.faildToFind))
                return
            }
            let places: [Place] = results.compactMap({
                Place(
                    name: $0.attributedFullText.string,
                    identifier: $0.placeID
                )
            })
            completion(.success(places))
        }
    }

    public func getLocation(for place: Place, completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
        client.fetchPlace(fromPlaceID: place.identifier,
                          placeFields: .coordinate,
                          sessionToken: nil) { googlePlace, error in
            guard let googlePlace = googlePlace, error == nil else {
                completion(.failure(PlacesError.faildToGetCoordinate))
                return
            }
            let coordinate = CLLocationCoordinate2DMake(
                googlePlace.coordinate.longitude,
                googlePlace.coordinate.longitude)

            completion(.success(coordinate))
        }
    }
}
