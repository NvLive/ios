//
//  ReachabilityService.swift
//  Navalny Live
//
//  Created by Eliah Snakin on 28/07/2017.
//  Copyright © 2017 Eliah Snakin. All rights reserved.
//

import Foundation
import StatusBarNotificationCenter
import ReSwift

class ReachabilityService {
    
    fileprivate var window: UIWindow
    
    init(withBaseWindow window: UIWindow) {
        self.window = window
        
        store.subscribe(self) { subcription in
            subcription.select { state in state.reachabilityState }
        }
        
        subscribeToReachabilityNotifications()
        startMonitoringNetworkReachability()
    }
    
    internal var status: NetworkReachability.Status {
        return store.state.reachabilityState.status
    }
    
}


extension ReachabilityService {

    fileprivate func startMonitoringNetworkReachability() {
        
        // TODO: process errors
        do {
            NetworkReachability.reachability = try Reachability(hostname: NetworkParameters.baseReachabilityHostname)
            do {
                try NetworkReachability.reachability?.start()
            } catch let error as NetworkReachability.Error {
                print(error)
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    fileprivate func subscribeToReachabilityNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityFlagChanged), name: .reachabilityFlagsChanged, object: NetworkReachability.reachability)
    }
    
    @objc func reachabilityFlagChanged(notification: Notification) {
        let status = NetworkReachability.reachability?.status ?? .undefined
        store.dispatchOnMain(ReachabilityAction.statusUpdated(status: status))
    }
}

extension ReachabilityService: StoreSubscriber {
    
    func newState(state: ReachabilityState) {
        guard state.status != .undefined else { return }
        
        DispatchQueue.main.async {
            self.displayReachabilityStatusUpdate(status: state.status, baseWindow: self.window)
        }
    }
    
    fileprivate func displayReachabilityStatusUpdate(status: NetworkReachability.Status, baseWindow window: UIWindow) {

        let config = NotificationCenterConfiguration(baseWindow: window)
        var labelConfig = NotificationLabelConfiguration()
        labelConfig.backgroundColor = Color.Base.danger
        
        var message: String? = nil
        
        switch status {
        case .unreachable:
            message = "Нет соединения :("
        case .wifi:
            message = "Есть контакт :)"
        case .wwan:
            message = "Есть контакт :)"
        case .undefined:
            break
        }
        
        guard message != nil else {
            return
        }
        
        if status == .unreachable {
            StatusBarNotificationCenter.showStatusBarNotificationWithMessage(message, withNotificationCenterConfiguration: config, andNotificationLabelConfiguration: labelConfig, whenComplete: nil)
        } else {
            StatusBarNotificationCenter.dismissNotificationWithCompletion(nil)
            StatusBarNotificationCenter.showStatusBarNotificationWithMessage(message, forDuration: 2, withNotificationCenterConfiguration: config, andNotificationLabelConfiguration: labelConfig)
        }
    }
}
