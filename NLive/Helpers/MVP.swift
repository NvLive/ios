//
//  Presenter.swift
//  Navalny Live
//
//  Created by Eliah Snakin on 28/06/2017.
//  Copyright © 2017 Eliah Snakin. All rights reserved.
//

protocol Dispatcher: class {
}


protocol PresenterActions {
    associatedtype V
    func attachView(_ view: V)
    func detachView()
}


class Presenter<D: Dispatcher, V: View> {
    
    internal let dispatcher: D
    weak internal private(set) var view : V?
    
    init(dispatcher: D) {
        self.dispatcher = dispatcher
    }
    
    /// Override for setup actions without attaching
    func configureView(_ view: V) {
    }
    
    /// Attaching view
    func attachView(_ view: V) {
        self.view = view
    }
    
    /// Override to refresh currently attached view
    func refreshView() {
    }
    
    /// Detaching view
    func detachView() {
        self.view = nil
    }
}


class Interactor<D: Dispatcher> {
    
    internal let dispatcher: D
    
    init(dispatcher: D) {
        self.dispatcher = dispatcher
    }
}


protocol View: class {
}
