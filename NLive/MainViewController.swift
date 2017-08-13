//
//  MainViewController.swift
//  NLive
//
//  Created by EVGENY ANTROPOV on 13/08/2017.
//  Copyright © 2017 Eugene Antropov. All rights reserved.
//

import UIKit

class MainViewController: UINavigationController {
    var navigationContoller: UINavigationController? = nil
    var streamController: StreamViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        streamController = self.storyboard?.instantiateViewController(withIdentifier: "StreamViewController") as? StreamViewController
        navigationContoller = self.storyboard?.instantiateViewController(withIdentifier: "NavigationViewController") as? UINavigationController        
        if let navigationContoller = navigationContoller {
            addChildViewController(navigationContoller)
            navigationContoller.view.frame = view.bounds
            view.addSubview(navigationContoller.view)
        }
        if let streamController = streamController {
            
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        streamController?.didMove(toParentViewController: self)
        navigationContoller?.didMove(toParentViewController: self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        streamController?.didMove(toParentViewController: nil)
        navigationContoller?.didMove(toParentViewController: nil)
    }
}
