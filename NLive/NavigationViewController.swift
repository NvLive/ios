//
//  NavigationViewController.swift
//  NLive
//
//  Created by EVGENY ANTROPOV on 13/08/2017.
//  Copyright © 2017 Eugene Antropov. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {
    var streamViewController: StreamViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        streamViewController = self.storyboard?.instantiateViewController(withIdentifier: "StreamViewController") as? StreamViewController
        if let streamViewController = streamViewController {
//            addChildViewController(streamViewController)
            //view.addSubview(streamViewController.view)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        streamViewController?.didMove(toParentViewController: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        streamViewController?.didMove(toParentViewController: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

