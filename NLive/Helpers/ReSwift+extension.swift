//
//  ReSwift+extension.swift
//  Navalny Live
//
//  Created by Eliah Snakin on 30/07/2017.
//  Copyright © 2017 Eliah Snakin. All rights reserved.
//

import ReSwift

extension Store {
    
    open func dispatchOnMain(_ action: Action) {
        DispatchQueue.main.async {
            self.dispatch(action)
        }
    }
}
