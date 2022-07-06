//
//  LoginViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/5/22.
// 
import UIKit
import Parse
class LoginViewController: UIViewController {
    @IBOutlet weak var loginUserName: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    
    @IBAction func didTapSignUp(_ sender: Any) {
        performSegue(withIdentifier:segues.segueToSignUp, sender: self)
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        let username = loginPassword.text ?? ""
        let password = loginPassword.text ?? ""
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
                return;
            }
            print("User logged in successfully")
            self.view.window?.rootViewController = segues.tabBarController               }
    }
}
