//
//  SceneDelegate.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/5/22.
//

import UIKit
import Parse
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if PFUser.current() != nil {
            window?.rootViewController = segues.homeStoryBoard.instantiateViewController(withIdentifier: "AuthenticatedViewController")
        }
    }
}
