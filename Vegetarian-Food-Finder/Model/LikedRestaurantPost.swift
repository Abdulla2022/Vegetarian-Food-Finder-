//
//  ParsePost.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/24/22.
//
import Foundation
import Parse
import ParseLiveQuery
final class LikedRestaurantPost: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        "LikedRestaurantPost"
    }

    var client: ParseLiveQuery.Client!
    var subscription: Subscription<PFObject>!

    class func updateLikeRestaurant(restaurantID: String, completion: @escaping (Bool) -> Void) {
        checkIfLiked(restaurantID: restaurantID) { likedRestaurant in
            if let likedRestaurant = likedRestaurant {
                self.deleteRestaurantLike(restaurant: likedRestaurant)
                completion(false)
                return
            }
            self.createRestaurantLike(restaurantID: restaurantID)
            completion(true)
        }
    }

    class func createRestaurantLike(restaurantID: String) {
        let newLikedRestaurant = PFObject(className: parseClassName())
        newLikedRestaurant["restaurantID"] = restaurantID
        newLikedRestaurant["user"] = PFUser.current()!
        newLikedRestaurant.saveInBackground()
    }

    class func deleteRestaurantLike(restaurant: PFObject) {
        restaurant.deleteInBackground()
    }

    class func checkIfLiked(restaurantID: String, completion: @escaping (PFObject?) -> Void) {
        let query = PFQuery(className: parseClassName())
        query.whereKey("restaurantID", equalTo: restaurantID)
        query.whereKey("user", equalTo: PFUser.current()!)
        query.findObjectsInBackground { object, error in
            if error != nil {
                completion(nil)
                return
            }
            completion(object?.first)
        }
    }

    class func getAllLikedRestaurantByUser(completion: @escaping ([PFObject]) -> Void) {
        let query = PFQuery(className: parseClassName())
        query.whereKey("user", equalTo: PFUser.current()!)
        query.findObjectsInBackground { objects, error in
            if error != nil {
                completion([])
                return
            }
            completion(objects ?? [])
        }
    }
}
