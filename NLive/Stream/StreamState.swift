//
//  StreamState.swift
//  NLive
//
//  Created by Eliah Snakin on 13/08/2017.
//  Copyright © 2017 Eugene Antropov. All rights reserved.
//

import ReSwift
import RealmSwift


struct StremState: StateType {
    var activeBroadcast: Results<BroadcastStore>?
}

enum StremAction: Action {
    case activate(broadcast: Results<BroadcastStore>?)
}

func streamReducer(action: Action, state: StremState?) -> StremState {
    var state = state ?? StremState()
    
    guard action is StremAction else { return state }
    
    switch action as! StremAction {
    case .activate(broadcast: let broadcast):
        state.activeBroadcast = broadcast
    }
    
    return state
}
