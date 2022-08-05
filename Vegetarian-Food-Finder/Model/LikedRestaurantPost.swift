//
//  ParsePost.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/24/22.
//
import Foundation
import Parse

final class LikedRestaurantPost: PFObject, PFSubclassing {
    @NSManaged var restaurantId: String
    @NSManaged var author: PFUser

    static func parseClassName() -> String {
        return "LikedRestaurantPost"
    }

    class func postLikedRestaurant(
        _ restaurnt: Business,
        withCompletion completion: PFBooleanResultBlock?
    ) {
        let newPost = LikedRestaurantPost()
        newPost.restaurantId = restaurnt.id
        newPost.author = PFUser.current()!
        newPost.saveInBackground()
    }
    
    class func deletLikedRestaurant(
        _ restaurnt: Business,
        withCompletion completion: PFBooleanResultBlock?
    ) {
        let newPost = LikedRestaurantPost()
        newPost.restaurantId = restaurnt.id
        newPost.author = PFUser.current()!
        newPost.deleteInBackground()
    }
}
