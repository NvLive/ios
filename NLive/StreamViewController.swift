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
    @IBOutlet weak var playPause: UIButton? = nil
    let vlcPlayer = VLCMediaPlayer(options: [])!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vlcPlayer.delegate = self
        let media = VLCMedia(url: URL(string: "rtmp://194.177.20.219:1935/webcam/fbk_office")!)
        vlcPlayer.media = media
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
