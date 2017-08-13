//
//  StreamViewController.swift
//  NLive
//
//  Created by EVGENY ANTROPOV on 12/08/2017.
//  Copyright © 2017 Eugene Antropov. All rights reserved.
//

import Foundation
import UIKit
import ReSwift
import RealmSwift

class StreamViewController: UIViewController {
    @IBOutlet weak var fadeView: UIView!
    @IBOutlet weak var smallView: UIView!
    
    var mainViewController: MainViewController? {
        return self.parent as? MainViewController
    }
    
    var activeBroadcast: BroadcastStore? = nil
    
    let miniStateSize: CGFloat = 56
    
    enum State {
        case mini
        case full
    }
    
    var state: State = .mini {
        didSet {
            reloadState(animated: true)
        }
    }
    
    func reloadState(animated: Bool) {
        UIView.animate(withDuration: animated ? 0.35 : 0) {[weak self] in
            guard let `self` = self else { return }
            switch(self.state) {
            case .mini:
                self.mainViewController?.streamHeightConstraint.constant = self.miniStateSize
                self.fadeView.alpha = 0
                self.smallView.alpha = 1
            case .full:
                self.mainViewController?.streamHeightConstraint.constant = UIScreen.main.bounds.height
                self.fadeView.alpha = 1
                self.smallView.alpha = 0
            }
            self.mainViewController?.view.layoutIfNeeded()
        }
    }
    

    @IBOutlet weak var playPause: UIButton? = nil
    let vlcPlayer = VLCMediaPlayer(options: [])!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vlcPlayer.delegate = self
        let media = VLCMedia(url: URL(string: "rtmp://194.177.20.219:1935/webcam/fbk_office")!)
        vlcPlayer.media = media
        
        store.subscribe(self) { subcription in
            subcription.select { state in state.streamState }
        }
        
        reloadState(animated: false)
    }
    
    
    @IBAction func playPausePresed() {
        if vlcPlayer.isPlaying == true {
            vlcPlayer.pause()
        }
        else {
            vlcPlayer.play()
        }
    }
    
    @IBAction func backgroundPress(gesture: UITapGestureRecognizer) {
        if state == .mini {
            state = .full
        }
    }
    
    @IBAction func fadePress(gesture: UITapGestureRecognizer) {
        if state == .full {
            state = .mini
        }
    }
    
    @IBAction func panHandler(gesture: UIPanGestureRecognizer) {
        switch(gesture.state) {
        case .changed, .began:
            let translation = gesture.translation(in: self.view)
            var newValue = self.mainViewController?.streamHeightConstraint.constant ?? 0
            newValue -= translation.y
            if newValue < UIScreen.main.bounds.height / 2 {
                state = .mini
                gesture.isEnabled = false
                gesture.isEnabled = true
            }
            else {
                self.mainViewController?.streamHeightConstraint.constant = min(newValue, UIScreen.main.bounds.height)
            }
            gesture.setTranslation(.zero, in: self.view)
        case .ended:
            state = .full
            gesture.isEnabled = false
            gesture.isEnabled = true
        default:
            ()
        }
        
    }
}

extension StreamViewController: StoreSubscriber {
    
    func newState(state: StreamState) {
        activeBroadcast = state.activeBroadcast
    }
}

extension StreamViewController: VLCMediaPlayerDelegate {
    func mediaPlayerStateChanged(_ aNotification: Notification!) {
        switch vlcPlayer.state {
        case .opening,.buffering:
             playPause?.setTitle("Loading" , for: .normal)
        case .playing:
            playPause?.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
        default:
            playPause?.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
        
    }
}
