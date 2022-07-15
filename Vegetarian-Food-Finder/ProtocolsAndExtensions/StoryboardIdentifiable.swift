//
//  StoryboardIdentifiable.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/6/22.
//
import Foundation
import UIKit

protocol StoryboardIdentifiable where Self: UIViewController {
    static var storyboard: UIStoryboard { get }
    static var viewController: UIViewController? { get }
}

extension StoryboardIdentifiable {
    static var storyboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }

    static var viewController: UIViewController? {
        return Self.storyboard.instantiateViewController(withIdentifier: NSStringFromClass(self))
    }
}
