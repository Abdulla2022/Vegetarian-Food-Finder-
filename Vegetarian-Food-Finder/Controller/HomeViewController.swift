//
//  HomeViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/5/22.
//
import UIKit
import Parse
class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func DidTapLogOut(_ sender: Any) {
        PFUser.logOut()
        self.view.window?.rootViewController = segues.loginViewController
    }
}
