//
//  DashboardState.swift
//  NLive
//
//  Created by Eliah Snakin on 13/08/2017.
//  Copyright © 2017 Eugene Antropov. All rights reserved.
//

import ReSwift
import RealmSwift


struct DashboardState: StateType {
    var featuredBroadcasts: Results<BroadcastStore>?
    var shows: Results<ShowStore>?
    var lastBroadcasts: Results<BroadcastStore>?
}
//extension DashboardState: Equatable {
//    static func ==(lhs: DashboardState, rhs: DashboardState) -> Bool {
//        return lhs.listUpdated == rhs.listUpdated
//    }
//}

enum DashboardAction: Action {
    case featuredBroadcastsFetchInitiated(placeholderBroadcasts: Results<BroadcastStore>?)
    case featuredBroadcastsFetchError(error: NetworkError?)
    case featuredBroadcastsFetched(broadcasts: Results<BroadcastStore>)
    
    case lastBroadcastsFetchInitiated(placeholderBroadcasts: Results<BroadcastStore>?)
    case lastBroadcastsFetchError(error: NetworkError?)
    case lastBroadcastsFetched(broadcasts: Results<BroadcastStore>)
    
    case showsFetchInitiated(placeholderShows: Results<ShowStore>?)
    case showsFetchError(error: NetworkError?)
    case showsFetched(shows: Results<ShowStore>)
}

func dashboardReducer(action: Action, state: DashboardState?) -> DashboardState {
    var state = state ?? DashboardState()
    
    guard action is DashboardAction else { return state }
    
    switch action as! DashboardAction {
    case .featuredBroadcastsFetchInitiated(placeholderBroadcasts: let placeholder):
        state.featuredBroadcasts = placeholder
    case .featuredBroadcastsFetchError(error: let error):
        break
    case .featuredBroadcastsFetched(broadcasts: let broadcasts):
        state.featuredBroadcasts = broadcasts
    
    case .lastBroadcastsFetchInitiated(placeholderBroadcasts: let placeholder):
        state.lastBroadcasts = placeholder
    case .lastBroadcastsFetchError(error: let error):
        break
    case .lastBroadcastsFetched(broadcasts: let broadcasts):
        state.lastBroadcasts = broadcasts
        
    case .showsFetchInitiated(placeholderShows: let placeholder):
        state.shows = placeholder
    case .showsFetchError(error: let error):
        break
    case .showsFetched(shows: let shows):
        state.shows = shows        
    }
    
    return state
}
