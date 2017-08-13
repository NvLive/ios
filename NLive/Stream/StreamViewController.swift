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
    @IBOutlet weak var smallView: UIView!
    @IBOutlet weak var volumeView: MPVolumeView!
    
    @IBOutlet weak var smallViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var broadcastImage: UIImageView!
    @IBOutlet weak var boradcastTitle: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var playPause: UIButton? = nil
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var detailBroadcastImage: UIImageView!
    @IBOutlet weak var detailShowTitle: UILabel!
    @IBOutlet weak var detailBroadcastTitle: UILabel!
    @IBOutlet weak var detailBroadcastDescr: UILabel!
    @IBOutlet weak var detailBroadcastContents: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var leftTime: UILabel!
    @IBOutlet weak var rightTime: UILabel!
    
    var mainViewController: MainViewController? {
        return self.parent as? MainViewController
    }
    
    var activeBroadcast: BroadcastStore? = nil {
        didSet {
            if activeBroadcast == nil {
                changeMusicBoxState(to: .none, animated: true)
                stop()
            } else {
                changeMusicBoxStateToActive(animated: true)
                play()
            }
            
            if let imageUrlString = activeBroadcast?.show.first?.placeholderImageUrlString,
                let imageUrl = URL(string: imageUrlString) {
                Nuke.loadImage(with: imageUrl, into: broadcastImage)
            }
            boradcastTitle.text = activeBroadcast?.title ?? ""
            detailBroadcastTitle.text = activeBroadcast?.title ?? ""
            detailBroadcastDescr.text = activeBroadcast?.descriptionString ?? ""
            detailBroadcastContents.text = activeBroadcast?.contents ?? ""
            detailShowTitle.text = activeBroadcast?.show.first?.title ?? ""
            
            if let streamUrlString = activeBroadcast?.streamUrlString,
                let streamUrl = URL(string: streamUrlString) {
                let media = VLCMedia(url: streamUrl)
                vlcPlayer.media = media
                vlcPlayer.play()
            }
            
            if let imageUrlString = activeBroadcast?.placeholderImageUrlString,
                let imageUrl = URL(string: imageUrlString) {
                Nuke.loadImage(with: imageUrl, into: detailBroadcastImage)
            }
            
        }
    }
    
    let miniStateSize: CGFloat = 56
    
    enum MusicBoxState {
        case mini
        case full
        case none
    }
    
    var musicBoxState: MusicBoxState = .none
    
    func changeMusicBoxState(to state: MusicBoxState, animated: Bool) {
        self.musicBoxState = state
        
        UIView.animate(withDuration: animated ? 0.35 : 0) {
//            guard let `self` = self else { return }
            switch(self.musicBoxState) {
            case .mini:
                self.mainViewController?.streamHeightConstraint.constant = self.miniStateSize
                self.mainViewController?.fadeView.alpha = 0
//                self.smallView.alpha = 1
                self.mainViewController?.streamBottomConstraint.constant = 0
            case .full:
                self.mainViewController?.streamHeightConstraint.constant = UIScreen.main.bounds.height - 64
                self.mainViewController?.fadeView.alpha = 1
//                self.smallView.alpha = 0
                self.mainViewController?.streamBottomConstraint.constant = 0
            case .none:
                self.mainViewController?.streamHeightConstraint.constant = self.miniStateSize
                self.mainViewController?.fadeView.alpha = 0
//                self.smallView.alpha = 1
                self.mainViewController?.streamBottomConstraint.constant = -self.miniStateSize
            }
            self.mainViewController?.view.layoutIfNeeded()
        }
    }
    
    func changeMusicBoxStateToActive(animated: Bool) {
        guard musicBoxState == .none else { return }
        changeMusicBoxState(to: .mini, animated: true)
    }
    

    
    let vlcPlayer = VLCMediaPlayer(options: [])!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vlcPlayer.addObserver(self, forKeyPath: "time", options: [.old, .new, .initial], context: nil)
        vlcPlayer.addObserver(self, forKeyPath: "remainingTime", options: [.old, .new, .initial], context: nil)
        volumeView.showsVolumeSlider = false
        volumeView.showsRouteButton = true        
        volumeView.setRouteButtonImage(nil, for: .normal)
        
        vlcPlayer.delegate = self
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "time" || keyPath == "remainingTime"{
            leftTime.text = vlcPlayer.time.stringValue
            rightTime.text = vlcPlayer.remainingTime.stringValue
            timeLabel.text = vlcPlayer.time.stringValue
            self.slider.layer.removeAllAnimations()
            UIView.animate(withDuration: 0.1, animations: {[weak self] in
                guard let `self` = self else { return }
                self.slider.value = self.vlcPlayer.position
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        store.subscribe(self) { subcription in
            subcription.select { state in state.streamState }
        }
        
        changeMusicBoxState(to: activeBroadcast != nil ? .mini : .none, animated: false)
        
//        self.mainViewController?.fadeView.addGestureRecognizer(panGesture)
        self.mainViewController?.fadeView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        store.unsubscribe(self)
        self.mainViewController?.fadeView.removeGestureRecognizer(panGesture)
        self.mainViewController?.fadeView.removeGestureRecognizer(tapGesture)
    }
    
    
    @IBAction func playPausePresed() {
        togglePlay()
    }
    
    func togglePlay() {
        if vlcPlayer.isPlaying == true {
            vlcPlayer.pause()
        }
        else {
            vlcPlayer.play()
        }
    }
    
    func play() {
        guard vlcPlayer.isPlaying == false else { return }
        vlcPlayer.play()
    }
    
    func pause() {
        guard vlcPlayer.isPlaying == true else { return }
        vlcPlayer.pause()
    }
    
    func stop() {
        vlcPlayer.stop()
    }
    
    @IBAction func backgroundPress(gesture: UITapGestureRecognizer) {
        if musicBoxState == .mini {
            changeMusicBoxState(to: .full, animated: true)
        }
    }
    
    @IBAction func fadePress(gesture: UITapGestureRecognizer) {
        if musicBoxState == .full {
            changeMusicBoxState(to: .mini, animated: true)
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
                changeMusicBoxState(to: .mini, animated: true)
                gesture.isEnabled = false
                gesture.isEnabled = true
            }
            else {
                self.mainViewController?.streamHeightConstraint.constant = min(newValue, UIScreen.main.bounds.height)
            }
        case .ended:
            changeMusicBoxState(to: .full, animated: true)
            gesture.isEnabled = false
            gesture.isEnabled = true
        default:
            ()
        }        
    }
    
    @IBAction func sliderDidChange(slider: UISlider) {
        if vlcPlayer.isSeekable {
            vlcPlayer.position = slider.value
            leftTime.text = vlcPlayer.time.stringValue
            rightTime.text = vlcPlayer.remainingTime.stringValue
            timeLabel.text = vlcPlayer.time.stringValue
        }
    }
}

extension StreamViewController: StoreSubscriber {
    
    func newState(state: StreamState) {
        if state.activeBroadcast != activeBroadcast {
            activeBroadcast = state.activeBroadcast
        }
        
        switch state.playbackState {
        case .loading:
            playPause?.setTitle("Loading" , for: .normal)
            playPause?.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            changeMusicBoxStateToActive(animated: true)
        case .playing:
            playPause?.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            changeMusicBoxStateToActive(animated: true)
        case .paused:
            playPause?.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
            changeMusicBoxStateToActive(animated: true)
        case .none:
            playPause?.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
            changeMusicBoxState(to: .none, animated: true)
        }
        
        switch state.userRequestedState {
        case .play:
            play()
        case .pause:
            pause()
        case .none:
            break
        }
    }
    
    func checkSeekEnable() {
        if vlcPlayer.isSeekable {
            slider.isUserInteractionEnabled = true
        }
        else {
            slider.isUserInteractionEnabled = false
            slider.value = 1.0
        }
    }
}

extension StreamViewController: VLCMediaPlayerDelegate {
    func mediaPlayerStateChanged(_ aNotification: Notification!) {
        switch vlcPlayer.state {
        case .opening, .buffering:
            store.dispatchOnMain(StreamAction.playbackStateChanged(state: .loading))
            checkSeekEnable()
        case .playing:
            store.dispatchOnMain(StreamAction.playbackStateChanged(state: .playing))
            checkSeekEnable()
        case .paused:
            store.dispatchOnMain(StreamAction.playbackStateChanged(state: .paused))
            checkSeekEnable()
        case .stopped, .error, .ended:
            store.dispatchOnMain(StreamAction.playbackStateChanged(state: .none))
        }
    }
}


extension StreamViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer is UIPanGestureRecognizer && otherGestureRecognizer is UIPanGestureRecognizer
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return !(otherGestureRecognizer is UIPanGestureRecognizer)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return !(otherGestureRecognizer is UIPanGestureRecognizer)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let pan = gestureRecognizer as? UIPanGestureRecognizer {
            return abs(pan.velocity(in: pan.view).y) > abs(pan.velocity(in: pan.view).x)
        }
        return false
    }
}
