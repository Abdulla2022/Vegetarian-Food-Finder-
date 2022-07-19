//
//  AppDelegate.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/5/22.
//
import Parse
import UIKit
import GooglePlaces
@main

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let parseConfig = ParseClientConfiguration {
            $0.applicationId = "zvoiaVievmnmp0dOWeAzYJjQQjxgVkK9kMdOuVw4"
            $0.clientKey = "9r33VbVuUnIk4s2qHM2hLtLGSVPLLHbhSCMB4aRI"
            $0.server = "https://parseapi.back4app.com"
        }
        GMSPlacesClient.provideAPIKey("AIzaSyBBb-YfhhRnSoei2fMb4okYYT1fy_jWsgM")
        Parse.initialize(with: parseConfig)
        return true
    }
}
