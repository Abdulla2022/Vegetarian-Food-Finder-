//
//  ParsePost.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/24/22.
//

import Foundation
import Parse

class ParsePost: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "ParsePost"
    }

    public var id: String

    init(id: String) {
        self.id = id
        super.init()
    }
}
