//
//  StringsManger.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/5/22.
//

import Foundation
import UIKit
struct segues{
    static let homeStoryBoard =  UIStoryboard(name: "Main", bundle: nil)
    static let tabBarController = homeStoryBoard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController
    static let loginViewController = homeStoryBoard.instantiateViewController(withIdentifier: "LoginViewController") as? UIViewController
    static let segueToSignUp = "SegueToSignUp"
}
