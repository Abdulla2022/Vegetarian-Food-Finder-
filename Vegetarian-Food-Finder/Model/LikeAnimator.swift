//
//  LikeAnimator.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/24/22.
//

import Foundation
import UIKit
final class LikeAnimator {
    let container: UIView
    let layoutConstraint: NSLayoutConstraint
    init(container: UIView, layoutConstraint: NSLayoutConstraint) {
        self.container = container
        self.layoutConstraint = layoutConstraint
    }

    func animate(completion: @escaping () -> Void
    ) {
        layoutConstraint.constant = 50
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .curveLinear) { [weak self] in
            self?.container.layoutIfNeeded()
        } completion: { [weak self] _ in
            self?.layoutConstraint.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self?.container.layoutIfNeeded()
                completion()
            })
        }
    }
}
