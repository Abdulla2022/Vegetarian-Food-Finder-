//
//  SignUpViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/5/22.
//
import Parse
import UIKit

final class SignUpViewController: UIViewController, StoryboardIdentifiable {
    @IBOutlet var signUpPassword: UITextField!
    @IBOutlet var signUpEmail: UITextField!
    @IBOutlet var signUpUserName: UITextField!

    @IBAction func didTapSignUp(_ sender: UIButton) {
        let newUser = PFUser()
        newUser.username = signUpUserName.text
        newUser.email = signUpEmail.text
        newUser.password = signUpPassword.text
        newUser.signUpInBackground { (success: Bool, _: Error?) in
            guard success else {
                self.showOkActionAlert(withTitle: "can't Signup", andMessage: "faild to SignUp")
                return
            }
            let tabBarController = SignUpViewController.storyboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController
            self.view.window?.rootViewController = tabBarController
        }
    }
}
