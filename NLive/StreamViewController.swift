//
//  StreamViewController.swift
//  NLive
//
//  Created by EVGENY ANTROPOV on 12/08/2017.
//  Copyright © 2017 Eugene Antropov. All rights reserved.
//

import Foundation
import UIKit

class StreamViewController: UIViewController {
    var mainViewController: MainViewController? {
        return self.parent as? MainViewController
    }
    
    let miniStateSize: CGFloat = 44
    
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
        UIView.animate(withDuration: animated ? 0.25 : 0) {[weak self] in
            guard let `self` = self else { return }
            UIView.animate(withDuration: 0.25) {
                switch(self.state) {
                case .mini:
                    self.mainViewController?.streamHeightConstraint.constant = self.miniStateSize
                case .full:
                     self.mainViewController?.streamHeightConstraint.constant = UIScreen.main.bounds.height - 40
                }
                self.mainViewController?.view.layoutIfNeeded()
            }
        }
    }
    

    @IBOutlet weak var playPause: UIButton? = nil
    let vlcPlayer = VLCMediaPlayer(options: [])!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vlcPlayer.delegate = self
        let media = VLCMedia(url: URL(string: "rtmp://194.177.20.219:1935/webcam/fbk_office")!)
        vlcPlayer.media = media
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
