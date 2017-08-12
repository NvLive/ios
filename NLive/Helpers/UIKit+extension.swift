//
//  UIKit+extension.swift
//  Navalny Live
//
//  Created by Eliah Snakin on 29/07/2017.
//  Copyright © 2017 Eliah Snakin. All rights reserved.
//

import UIKit

extension UINavigationController {
    override open var childViewControllerForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
}

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
}
