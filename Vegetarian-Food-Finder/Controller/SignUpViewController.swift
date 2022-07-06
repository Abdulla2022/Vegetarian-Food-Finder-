//
//  SignUpViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/5/22.
//
import Parse
import UIKit
class SignUpViewController: UIViewController {
    @IBOutlet weak var signUpPassword: UITextField!
    @IBOutlet weak var signUpEmail: UITextField!
    @IBOutlet weak var signUpUserName: UITextField!
    @IBAction func didTapSignUp(_ sender: Any) {
        let newUser = PFUser()
        newUser.username = signUpUserName.text
        newUser.email = signUpEmail.text
        newUser.password = signUpPassword.text
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                return;
            }
            print("User Registered successfully")
            self.view.window?.rootViewController = segues.tabBarController
        }
    }
}

