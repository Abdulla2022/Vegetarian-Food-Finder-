//
//  SignUpViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/5/22.
//
import Parse
import TextFieldEffects
import UIKit
final class SignUpViewController: UIViewController, StoryboardIdentifiable, UITextFieldDelegate {
    @IBOutlet var signUpPassword: YoshikoTextField!

    @IBOutlet var signUpEmail: YoshikoTextField!

    @IBOutlet var signUpUserName: YoshikoTextField!

    @IBOutlet var signUpOutlet: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewConstrainsts()
        setBtns(selectedBtn: signUpOutlet)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }

    func setUpViewConstrainsts() {
        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "VeganWords")
        imageView.center = view.center
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
    }

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
