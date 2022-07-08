//
//  HomeViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/5/22.
//
import UIKit
import Parse

final class HomeViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var restaurants: NSArray = []
    
    @IBAction func DidTapLogOut(_ sender: UIButton) {
        PFUser.logOut()
        self.view.window?.rootViewController = LoginViewController.viewController
    }
}
