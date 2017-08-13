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
    var activeBroadcast: BroadcastStore?
    var isPlaying: Bool = false
}

enum StreamAction: Action {
    case activate(broadcast: BroadcastStore?)
    case pause
    case play
}

func streamReducer(action: Action, state: StreamState?) -> StreamState {
    var state = state ?? StreamState()
    
    guard action is StreamAction else { return state }
    
    switch action as! StreamAction {
    case .activate(broadcast: let broadcast):
        state.activeBroadcast = broadcast
        state.isPlaying = broadcast != nil
    case .play:
        state.isPlaying = state.activeBroadcast != nil
    case .pause:
        state.isPlaying = false
    }
    
    return state
}
