//
//  LoginViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/5/22.
//
import UIKit
import Parse

final class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginUserName: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    
    @IBAction func didTapSignUp(_ sender: UIButton) {
        performSegue(withIdentifier:Constants.segueToSignUp, sender: self)
    }
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        guard let userName = loginUserName.text,
              let password = loginPassword.text else {
            print("username and password must not be empty")
            return
        }
        PFUser.logInWithUsername(inBackground: userName, password: password) { [weak self](user: PFUser?, error: Error?) in
            guard error == nil else{
                print("User log in failed: \(error?.localizedDescription)")
                return;
            }
            print("User logged in successfully")
            let storyBoard =  UIStoryboard(name: "Main", bundle: nil)
            let tabBarController = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController
            self?.view.window?.rootViewController = tabBarController
        }
    }
}
