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
    @IBOutlet weak var playPause: UIButton!
    let vlcPlayer = VLCMediaPlayer(options: [])!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vlcPlayer.delegate = self
        let media = VLCMedia(url: URL(string: "rtmp://192.168.1.187:1935/webcam/mystream")!)
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
        case .opening:
             playPause.setTitle("Loading" , for: .normal)
        case .playing,.buffering:
            playPause.setTitle("Pause" , for: .normal)
        default:
            playPause.setTitle("Play", for: .normal)
        }
        
    }
}
