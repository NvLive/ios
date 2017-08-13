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
import MediaPlayer
import Nuke

class StreamViewController: UIViewController {
    @IBOutlet weak var fadeView: UIView!
    @IBOutlet weak var smallView: UIView!
    @IBOutlet weak var volumeView: MPVolumeView!
    
    @IBOutlet weak var broadcastImage: UIImageView!
    @IBOutlet weak var boradcastTitle: UILabel!
    @IBOutlet weak var playPause: UIButton? = nil
    @IBOutlet weak var panGesture: UIPanGestureRecognizer!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var mainViewController: MainViewController? {
        return self.parent as? MainViewController
    }
    
    var activeBroadcast: BroadcastStore? = nil {
        didSet{
            if let imageUrlString = activeBroadcast?.show.first?.placeholderImageUrlString,
                let imageUrl = URL(string: imageUrlString) {
                Nuke.loadImage(with: imageUrl, into: broadcastImage)
            }
            boradcastTitle.text = activeBroadcast?.title ?? ""
            if let streamUrlString = activeBroadcast?.streamUrlString,
                let streamUrl = URL(string: streamUrlString) {
                let media = VLCMedia(url: streamUrl)
                vlcPlayer.media = media
                vlcPlayer.play()
            }
        }
    }
    
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
    

    
    let vlcPlayer = VLCMediaPlayer(options: [])!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        volumeView.showsVolumeSlider = false
        volumeView.showsRouteButton = true        
        volumeView.setRouteButtonImage(nil, for: .normal)
        
        vlcPlayer.delegate = self
        
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
        defer { gesture.setTranslation(.zero, in: self.view) }
        guard scrollView.contentOffset.y <= 0 else { return }
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
            playPause?.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        default:
            playPause?.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
        }
        
    }
}


extension StreamViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
   func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
