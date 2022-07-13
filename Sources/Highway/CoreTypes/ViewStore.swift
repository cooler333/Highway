//
//  ViewStore.swift
//  Highway
//
//  Created by Dmitrii Coolerov on 13.07.2022.
//

import Foundation

// TODO: ViewStore
/*
public final class ViewStore<ViewState: Equatable, ViewAction> {
    private let store: Store<State, Action>
    private let stateMapper: (State) -> ViewState
    private let actionMapper: (ViewAction) -> Action


    public var state: ViewState {
        return store.state
    }

    public init<State, Action>(
        store: Store<State, Action>,
        stateMapper: @escaping (State) -> ViewState,
        actionMapper: @escaping (ViewAction) -> Action
    ) {
        self.store = store
        self.stateMapper = stateMapper
        self.actionMapper = actionMapper
    }

    @discardableResult
    public func subscribe(listener: @escaping (ViewState) -> Void) -> Subscription<ViewState> {
        store.subscribe(listener: listener)
    }

    public func unsubscribe(_ subscription: Subscription<ViewState>) {
        store.unsubscribe(subscription)
    }

    public func dispatch(_ action: ViewAction) {
        store.dispatch(action)
    }
}
*/
