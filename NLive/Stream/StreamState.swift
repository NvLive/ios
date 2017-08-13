//
//  StreamState.swift
//  NLive
//
//  Created by Eliah Snakin on 13/08/2017.
//  Copyright © 2017 Eugene Antropov. All rights reserved.
//

import ReSwift
import RealmSwift


struct StreamState: StateType {
    enum PlaybackState {
        case loading, playing, paused, none
    }
    enum UserRequestedState {
        case play, pause, none
    }
    
    var activeBroadcast: BroadcastStore?
    var playbackState: PlaybackState = .none
    var userRequestedState: UserRequestedState = .none
}
extension StreamState: Equatable {
    static func ==(lhs: StreamState, rhs: StreamState) -> Bool {
        return
            lhs.activeBroadcast?.id == rhs.activeBroadcast?.id &&
            lhs.playbackState == rhs.playbackState &&
            lhs.userRequestedState == rhs.userRequestedState
    }
}

enum StreamAction: Action {
    case activate(broadcast: BroadcastStore)
    case playbackStateChanged(state: StreamState.PlaybackState)
    case pause
    case play
    case stop
}

func streamReducer(action: Action, state: StreamState?) -> StreamState {
    var state = state ?? StreamState()
    
    guard action is StreamAction else { return state }
    
    switch action as! StreamAction {
    case .activate(broadcast: let broadcast):
        state.activeBroadcast = broadcast
    case .playbackStateChanged(state: let playbackState):
        state.playbackState = playbackState
        if playbackState == .none {
            state.activeBroadcast = nil
        }
        state.userRequestedState = .none
    case .play:
        state.userRequestedState = .play
    case .pause:
        state.userRequestedState = .pause
    case .stop:
        state.userRequestedState = .none
        state.activeBroadcast = nil
    }
    
    return state
}
