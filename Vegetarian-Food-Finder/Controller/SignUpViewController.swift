//
//  SignUpViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/5/22.
//
import Parse
import UIKit

final class SignUpViewController: UIViewController {
    
    @IBOutlet weak var signUpPassword: UITextField!
    @IBOutlet weak var signUpEmail: UITextField!
    @IBOutlet weak var signUpUserName: UITextField!
    
    @IBAction func didTapSignUp(_ sender: UIButton) {
        let newUser = PFUser()
        newUser.username = signUpUserName.text
        newUser.email = signUpEmail.text
        newUser.password = signUpPassword.text
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            guard success else{
                print(error?.localizedDescription)
                return
            }
            print("User Registered successfully")
            let storyBoard =  UIStoryboard(name: "Main", bundle: nil)
            let tabBarController = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController
            self.view.window?.rootViewController = tabBarController
        }
    }
}

