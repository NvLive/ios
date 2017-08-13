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
    
    @IBOutlet weak var streamBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var fadeView: UIView!
    
    override open var childViewControllerForStatusBarStyle: UIViewController? {
        return self.childViewControllers.filter { $0 is UINavigationController }.first
    }
    
    
    
    override func remoteControlReceived(with event: UIEvent?) {
        guard let event = event else { return }
        print("event" + event.description)
//        switch event.subtype {
//        case .remoteControlPlay:
//            vlcPlayer.play()
//        case .remoteControlPause:
//            vlcPlayer.pause()
//        case .remoteControlStop:
//            vlcPlayer.stop()
//        default:
//            ()
//        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
}
