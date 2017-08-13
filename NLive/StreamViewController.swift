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
            let screen = UIScreen.main.bounds
            switch(self.state) {
            case .mini:
                self.view.frame = CGRect(x: 0, y: screen.height - self.miniStateSize, width: screen.width, height: self.miniStateSize)
            case .full:
                self.view.frame = CGRect(x: 0, y: 0, width: screen.width, height: screen.height)
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
    }
    
    override func viewDidAppear(_ animated: Bool) {        
        super.viewDidAppear(animated)
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
}

extension StreamViewController: VLCMediaPlayerDelegate {
    func mediaPlayerStateChanged(_ aNotification: Notification!) {
        switch vlcPlayer.state {
        case .opening,.buffering:
             playPause?.setTitle("Loading" , for: .normal)
        case .playing:
            playPause?.setTitle("Pause" , for: .normal)
        default:
            playPause?.setTitle("Play", for: .normal)
        }
        
    }
}
