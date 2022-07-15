//
//  UIViewController+Alert.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/14/22.
//
import Foundation
import UIKit

extension UIViewController {
    func showOkActionAlert(withTitle title: String, andMessage message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
