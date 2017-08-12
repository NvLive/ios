//
//  ReachabilityState.swift
//  Navalny Live
//
//  Created by Eliah Snakin on 30/07/2017.
//  Copyright © 2017 Eliah Snakin. All rights reserved.
//

import ReSwift

struct ReachabilityState: StateType {
    var status: NetworkReachability.Status = .undefined {
        didSet { updated = Date() }
    }
    fileprivate var updated: Date?
}
extension ReachabilityState: Equatable {
    static func ==(lhs: ReachabilityState, rhs: ReachabilityState) -> Bool {
        return lhs.updated == rhs.updated
    }
}


enum ReachabilityAction: Action {
    case statusUpdated(status: NetworkReachability.Status)
}


func reachabilityReducer(action: Action, state: ReachabilityState?) -> ReachabilityState {
    var state = state ?? ReachabilityState()
    
    guard action is ReachabilityAction else { return state }
    
    switch action as! ReachabilityAction {
    case .statusUpdated(status: let status):
        state.status = status
    }
    
    return state
}
