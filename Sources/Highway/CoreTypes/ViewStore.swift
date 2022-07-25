//
//  ViewStore.swift
//  Highway
//
//  Created by Dmitrii Coolerov on 13.07.2022.
//

import Foundation

public final class ViewStore<ViewState: Equatable, ViewAction> {
    private var subscriptions: [Subscription<ViewState>] = []
    private var subscription: Any!

    public var state: ViewState {
        stateGetter()
    }

    private var stateGetter: (() -> ViewState)!

    private var internalDispatch: ((ViewAction) -> Void)!

    public init<State: Equatable, Action>(
        store: Store<State, Action>,
        stateMapper: @escaping (State) -> ViewState,
        actionMapper: @escaping (ViewAction) -> Action
    ) {
        stateGetter = {
            stateMapper(store.state)
        }
        internalDispatch = { action in
            store.dispatch(actionMapper(action))
        }

        let subscription = store.subscribe { [weak self] (state: State) in
            self?.subscriptions.forEach { $0.listener(stateMapper(state)) }
        }
        self.subscription = subscription
    }

    @discardableResult
    public func subscribe(listener: @escaping (ViewState) -> Void) -> Subscription<ViewState> {
        let subscription = Subscription<ViewState>(listener: listener)
        subscriptions.append(subscription)
        return subscription
    }

    public func unsubscribe(_ subscription: Subscription<ViewState>) {
        if let index = subscriptions.firstIndex(of: subscription) {
            subscriptions.remove(at: index)
        }
    }

    public func dispatch(_ action: ViewAction) {
        internalDispatch(action)
    }
}
