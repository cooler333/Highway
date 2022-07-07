//
//  Store.swift
//  Highway
//
//  Created by Dmitrii Cooler on 02.07.2022.
//

import Foundation

public final class Store<State: Equatable, Action> {

    private var stateGetter: (() -> State)!
    private var stateSetter: ((State) -> Void)!

    public var state: State {
        get { stateGetter() }
        set { stateSetter(newValue) }
    }

    var _state: State! {
        didSet {
            subscriptions.forEach { subscription in
                subscription.listener(_state)
            }
        }
    }

    private var reducer: Reducer<State, Action>
    private var subscriptions: [Subscription<State>] = []
    private var isDispatching = Synchronized<Bool>(false)
    private let middleware: [Middleware<State, Action>]

    public required init(
        reducer: @escaping Reducer<State, Action>,
        state: State,
        initialAction: Action,
        middleware: [Middleware<State, Action>] = []
    ) {
        self.reducer = reducer
        self.middleware = middleware

        self._state = state
        self.stateGetter = { [unowned self] in
            return self._state
        }
        self.stateSetter = { [unowned self] state in
            self._state = state
        }

        dispatch(initialAction)
    }

    private init(
        reducer: @escaping Reducer<State, Action>,
        stateGetter: @escaping () -> State,
        stateSetter: @escaping (State) -> Void,
        initialAction: Action,
        middleware: [Middleware<State, Action>] = []
    ) {
        self.reducer = reducer
        self.middleware = middleware

        self.stateGetter = stateGetter
        self.stateSetter = stateSetter

        dispatch(initialAction)
    }

    @discardableResult
    public func subscribe(_ listener: @escaping (State) -> Void) -> Subscription<State> {
        let subscription = Subscription<State>(listener: listener)
        subscriptions.append(subscription)
        return subscription
    }

    public func unsubscribe(_ subscription: Subscription<State>) {
        if let index = subscriptions.firstIndex(of: subscription) {
            subscriptions.remove(at: index)
        }
    }

    // swiftlint:disable:next identifier_name
    public func _defaultDispatch(action: Action) {
        guard !self.isDispatching.value else {
            raiseFatalError(
                """
                Action has been dispatched while a previous action is being processed.
                A reducer is dispatching an action in a concurrent context (e.g. from multiple threads).
                Action: \(action)
                """
            )
        }

        isDispatching.value { $0 = true }
        let newState = reducer(state, action)
        isDispatching.value { $0 = false }

        if state != newState {
            state = newState
        }
    }

    public func dispatch(_ action: Action) {
        _defaultDispatch(action: action)
        let dispatch: (Action) -> Void = { [unowned self] in self.dispatch($0) }
        let getState: () -> State = { [unowned self] in self.state }
        middleware.forEach { middleware in
            middleware(dispatch, getState, action)
        }
    }

    public func createChildStore<ChildState, ChildAction>(
        keyPath: WritableKeyPath<State, ChildState>,
        reducer: @escaping Reducer<ChildState, ChildAction>,
        initialAction: ChildAction,
        middleware: [Middleware<ChildState, ChildAction>] = []
    ) -> Store<ChildState, ChildAction> {
        let childStore = Store<ChildState, ChildAction>(
            reducer: reducer,
            stateGetter: { self.state[keyPath: keyPath] },
            stateSetter: { self.state[keyPath: keyPath] = $0 },
            initialAction: initialAction,
            middleware: middleware
        )
        subscribe({ [weak childStore] state in
            guard let childStore = childStore else { return }
            childStore.subscriptions.forEach { subscription in
                subscription.listener(state[keyPath: keyPath])
            }
        })
        return childStore
    }
}
