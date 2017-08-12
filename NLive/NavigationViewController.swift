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
            present(streamViewController, animated: false, completion: nil)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
