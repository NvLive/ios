//
//  State.swift
//  Navalny Live
//
//  Created by Eliah Snakin on 27/06/2017.
//  Copyright © 2017 Eliah Snakin. All rights reserved.
//

import ReSwift

struct AppState: StateType {
    var routerState = RouterState()
    var reachabilityState = ReachabilityState()
    var dashboardState = DashboardState()
}

func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState(
        routerState: routerReducer(action: action, state: state?.routerState),
        reachabilityState: reachabilityReducer(action: action, state: state?.reachabilityState),
        dashboardState: dashboardReducer(action: action, state: state?.dashboardState)
    )
}


struct DashboardState: StateType {
    
}

enum DashboardAction: Action {
    
}

func dashboardReducer(action: Action, state: DashboardState?) -> DashboardState {
    var state = state ?? DashboardState()
    
    guard action is DashboardAction else { return state }
    
    switch action as! DashboardAction {
//    case .statusUpdated(status: let status):
//        state.status = status
    default: break
    }
    
    return state
}
