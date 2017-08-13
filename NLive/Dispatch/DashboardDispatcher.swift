//
//  DashboardDispatcher.swift
//  NLive
//
//  Created by Eliah Snakin on 13/08/2017.
//  Copyright © 2017 Eugene Antropov. All rights reserved.
//

import ReSwift

class DashboardDispatcher: Dispatcher {
    
    fileprivate let showStoreService = ShowStoreService()
    fileprivate let broadcastStoreService = BroadcastStoreService()

    fileprivate let showNetworkService = ShowNetworkService()
    fileprivate let broadcastNetworkService = BroadcastNetworkService()
    
    fileprivate let actionType = DashboardAction.self
    fileprivate var state: DashboardState {
        return store.state.dashboardState
    }
    
    internal func fetchCurrent() {
        
        let live = broadcastStoreService.readCurrent()
        store.dispatchOnMain(self.actionType.featuredBroadcastsFetchInitiated(placeholderBroadcasts: live))
        
        broadcastNetworkService.requestListCurrent(completion: { (broadcasts, error) in
            guard
                let broadcasts = broadcasts,
                error == nil
            else {
                store.dispatchOnMain(self.actionType.featuredBroadcastsFetchError(error: error))
                return
            }
            
            self.broadcastStoreService.persistList(withDTO: broadcasts)
            let featuredBroadcasts = self.broadcastStoreService.readCurrent()
            store.dispatchOnMain(self.actionType.featuredBroadcastsFetched(broadcasts: featuredBroadcasts))
        })
    }
    
    internal func fetchLast() {
        
        let last = broadcastStoreService.readLast()
        store.dispatchOnMain(self.actionType.lastBroadcastsFetchInitiated(placeholderBroadcasts: last))
        
        broadcastNetworkService.requestList(countLast: 100, completion: { (broadcasts, error) in
            guard
                let broadcasts = broadcasts,
                error == nil
                else {
                    store.dispatchOnMain(self.actionType.lastBroadcastsFetchError(error: error))
                    return
            }
            
            self.broadcastStoreService.persistList(withDTO: broadcasts)
            let lastBroadcasts = self.broadcastStoreService.readLast()
            store.dispatchOnMain(self.actionType.lastBroadcastsFetched(broadcasts: lastBroadcasts))
        })
    }
    
    internal func fetchShows() {
        
        let shows = showStoreService.readList()
        store.dispatchOnMain(self.actionType.showsFetchInitiated(placeholderShows: shows))
        
        showNetworkService.requestList { (shows, error) in
            guard
                let shows = shows,
                error == nil
                else {
                    store.dispatchOnMain(self.actionType.showsFetchError(error: error))
                    return
            }
            
            self.showStoreService.persistList(withDTO: shows)
            let storedShows = self.showStoreService.readList()
            store.dispatchOnMain(self.actionType.showsFetched(shows: storedShows))
        }
    }
}


