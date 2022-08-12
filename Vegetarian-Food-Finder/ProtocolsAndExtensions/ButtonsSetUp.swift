//
//  ButtonsSetUp.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 8/12/22.
//

import Foundation
import UIKit
extension UIViewController {
    func setBtns(selectedBtn: UIButton) {
        selectedBtn.backgroundColor = UIColor(named: "buttonBackground")
        selectedBtn.layer.cornerRadius = 8
        selectedBtn.layer.shadowColor = UIColor(named: "buttonShadow")?.cgColor
        selectedBtn.layer.shadowOpacity = 0.8
        selectedBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        selectedBtn.layer.borderWidth = 2
        selectedBtn.layer.borderColor = UIColor(named: "buttonBorder")?.cgColor
    }
}
