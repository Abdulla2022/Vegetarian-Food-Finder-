//
//  LoginViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/5/22.
//
import CLTypingLabel
import Parse
import TextFieldEffects
import UIKit
final class LoginViewController: UIViewController, StoryboardIdentifiable, UITextFieldDelegate {
    private let segueToSignUp = "SegueToSignUp"
    @IBOutlet var loginUserName: KaedeTextField!
    @IBOutlet var loginPassword: UITextField!
    @IBOutlet var loginOutlet: UIButton!
    @IBOutlet var signUpOutlet: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setBtns(selectedBtn: signUpOutlet)
        setBtns(selectedBtn: loginOutlet)
        view.backgroundColor = UIColor(patternImage: UIImage(named: "grassBackground")!)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }

    @IBAction func didTapSignUp(_ sender: UIButton) {
        performSegue(withIdentifier: segueToSignUp, sender: self)
    }

    @IBAction func didTapLogin(_ sender: UIButton) {
        guard let userName = loginUserName.text,
              let password = loginPassword.text else {
            return
        }
        PFUser.logInWithUsername(inBackground: userName, password: password) { [weak self] (_: PFUser?, error: Error?) in
            guard error == nil else {
                self?.showOkActionAlert(withTitle: "Can not login", andMessage: "Invalid Username/Password")
                return
            }
            let tabBarController = Self.storyboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController
            self?.view.window?.rootViewController = tabBarController
        }
    }
}
