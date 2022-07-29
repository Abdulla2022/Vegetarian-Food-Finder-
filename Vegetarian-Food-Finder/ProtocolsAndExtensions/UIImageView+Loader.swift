//
//  UIImageView+Loader.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/14/22.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            let session = URLSession.shared
            session.dataTask(with: url, completionHandler: { data, _, _ in
                DispatchQueue.main.async(execute: { () in
                    let image = UIImage(data: data!)
                    self?.image = image
                })
            }).resume()
        }
    }
}
