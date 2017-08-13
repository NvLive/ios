//
//  MainViewController.swift
//  NLive
//
//  Created by EVGENY ANTROPOV on 13/08/2017.
//  Copyright © 2017 Eugene Antropov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var streamHeightConstraint: NSLayoutConstraint!
    
    override open var childViewControllerForStatusBarStyle: UIViewController? {
        return self.childViewControllers.filter { $0 is UINavigationController }.first
    }
}
