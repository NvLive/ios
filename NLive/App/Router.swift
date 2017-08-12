//
//  AppRouter.swift
//  Navalny Live
//
//  Created by Eliah Snakin on 27/06/2017.
//  Copyright © 2017 Eliah Snakin. All rights reserved.
//

import ReSwift

enum RouterSequence: Hashable {
    case dashboard
    case undefined
    
    var vc: (storyboardName: String, vcIdentifier: String?)? {
        switch self {
        case .dashboard:
            return ("Main", nil)
        case .undefined:
            return nil
        }
    }
}

struct RouterState: StateType {
    var loadedSequence: RouterSequence = .undefined
}
extension RouterState: Equatable {
    static func ==(lhs: RouterState, rhs: RouterState) -> Bool {
        return lhs.loadedSequence == rhs.loadedSequence
    }
}

enum RouterAction: Action {
    case loadDefaultSequence
//    case load(sequence: RouterSequence)
}


func routerReducer(action: Action, state: RouterState?) -> RouterState {
    var state = state ?? RouterState()
    
    guard action is RouterAction else { return state }
    
    switch action as! RouterAction {
    case .loadDefaultSequence:
        state.loadedSequence = .dashboard
        
//    case .load(sequence: let sequence):
//        state.loadedSequence = sequence
    }
    
    return state
}



class AppRouter: StoreSubscriber {
    
    init() {
        store.subscribe(self) {
            $0.select { ($0.routerState) }
        }
    }
    
    func newState(state: RouterState) {
        load(sequence: state.loadedSequence)
    }
    
    private func load(sequence: RouterSequence) {
        guard let vcPointer = sequence.vc else { return }
        
        let storyboard = UIStoryboard(name: vcPointer.storyboardName, bundle: nil)
        
        var vc: UIViewController?
        if vcPointer.vcIdentifier != nil {
            vc = storyboard.instantiateViewController(withIdentifier: vcPointer.vcIdentifier!)
        } else {
            vc = storyboard.instantiateInitialViewController()
        }
        
        guard vc != nil else { return }
        setRootViewController(vc!)
    }
    
    private func setRootViewController(_ viewController:UIViewController) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setRootViewController(viewController, animated: false)
    }

}
