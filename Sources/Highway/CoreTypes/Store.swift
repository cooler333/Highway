//
//  Store.swift
//  Highway
//
//  Created by Dmitrii Cooler on 02.07.2022.
//

import Foundation

public protocol StoreCreator {
    associatedtype State: Equatable

    func createChildStore<ChildState: Equatable, ChildAction>(
        keyPath: WritableKeyPath<State, ChildState>,
        reducer: Reducer<ChildState, ChildAction>,
        initialAction: ChildAction?,
        middleware: [Middleware<ChildState, ChildAction>]
    ) -> Store<ChildState, ChildAction>

    func createChildStore<ChildState: Equatable, ChildAction>(
        keyPath: WritableKeyPath<State, ChildState>,
        reducer: Reducer<ChildState, ChildAction>,
        initialAction: ChildAction?
    ) -> Store<ChildState, ChildAction>

    func createChildStore<ChildAction>(
        reducer: Reducer<State, ChildAction>,
        initialAction: ChildAction?,
        middleware: [Middleware<State, ChildAction>]
    ) -> Store<State, ChildAction>

    func createChildStore<ChildAction>(
        reducer: Reducer<State, ChildAction>,
        initialAction: ChildAction?
    ) -> Store<State, ChildAction>
}

public final class Store<State: Equatable, Action>: StoreCreator {
    private var stateGetter: (() -> State)!
    private var stateSetter: ((State) -> Void)!

    public private(set) var state: State {
        get { stateGetter() }
        set { stateSetter(newValue) }
    }

    private var _state: State! {
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

    private let internalQueue: DispatchQueue

    public required init(
        reducer: Reducer<State, Action>,
        state: State,
        initialAction: Action? = nil,
        middleware: [Middleware<State, Action>] = []
    ) {
        internalQueue = DispatchQueue(label: "Highway.internalQueue")
        self.reducer = reducer
        self.middleware = middleware

        _state = state
        stateGetter = { [unowned self] in
            self._state
        }
        stateSetter = { [unowned self] state in
            self._state = state
        }

        if let initialAction = initialAction {
            dispatch(initialAction)
        }
    }

    private init(
        reducer: Reducer<State, Action>,
        stateGetter: @escaping () -> State,
        stateSetter: @escaping (State) -> Void,
        initialAction: Action? = nil,
        middleware: [Middleware<State, Action>] = [],
        internalQueue: DispatchQueue
    ) {
        self.internalQueue = internalQueue
        self.reducer = reducer
        self.middleware = middleware

        self.stateGetter = stateGetter
        self.stateSetter = stateSetter

        if let initialAction = initialAction {
            dispatch(initialAction)
        }
    }

    @discardableResult
    public func subscribe(listener: @escaping (State) -> Void) -> Subscription<State> {
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
    public func innerDispatch(action: Action) {
        guard !isDispatching.value else {
            fatalError(
                """
                Action has been dispatched while a previous action is being processed.
                A reducer is dispatching an action in a concurrent context (e.g. from multiple threads).
                Action: \(action)
                """
            )
        }

        isDispatching.value { $0 = true }
        let newState = reducer.reduce(state, action)
        isDispatching.value { $0 = false }

        if state != newState {
            state = newState
        }
    }

    public func dispatch(_ action: Action) {
        internalQueue.async { [weak self] in
            guard let self = self else { return }
            self.innerDispatch(action: action)
            let middlewareDispatch: (Action) -> Void = { [weak self] in
                guard let self = self else {
                    debugPrint("dispatch() called after Store deinit")
                    return
                }
                self.dispatch($0)
            }
            let getState: () -> State? = { [weak self] in
                guard let self = self else {
                    debugPrint("getState() called after Store deinit")
                    return nil
                }
                return self.state
            }
            self.middleware.forEach { middleware in
                middleware(middlewareDispatch, getState, action)
            }
        }
    }

    public func createChildStore<ChildState, ChildAction>(
        keyPath: WritableKeyPath<State, ChildState>,
        reducer: Reducer<ChildState, ChildAction>,
        initialAction: ChildAction? = nil,
        middleware: [Middleware<ChildState, ChildAction>]
    ) -> Store<ChildState, ChildAction> {
        let childStore = Store<ChildState, ChildAction>(
            reducer: reducer,
            stateGetter: { self.state[keyPath: keyPath] },
            stateSetter: { self.state[keyPath: keyPath] = $0 },
            initialAction: initialAction,
            middleware: middleware,
            internalQueue: internalQueue
        )
        subscribe(listener: { [weak childStore] state in
            guard let childStore = childStore else { return }
            childStore.subscriptions.forEach { subscription in
                subscription.listener(state[keyPath: keyPath])
            }
        })
        return childStore
    }

    public func createChildStore<ChildState, ChildAction>(
        keyPath: WritableKeyPath<State, ChildState>,
        reducer: Reducer<ChildState, ChildAction>,
        initialAction: ChildAction? = nil
    ) -> Store<ChildState, ChildAction> {
        return createChildStore(
            keyPath: keyPath,
            reducer: reducer,
            initialAction: initialAction,
            middleware: []
        )
    }

    public func createChildStore<ChildAction>(
        reducer: Reducer<State, ChildAction>,
        initialAction: ChildAction? = nil,
        middleware: [Middleware<State, ChildAction>]
    ) -> Store<State, ChildAction> {
        let childStore = Store<State, ChildAction>(
            reducer: reducer,
            stateGetter: { self.state },
            stateSetter: { self.state = $0 },
            initialAction: initialAction,
            middleware: middleware,
            internalQueue: internalQueue
        )
        subscribe(listener: { [weak childStore] state in
            guard let childStore = childStore else { return }
            childStore.subscriptions.forEach { subscription in
                subscription.listener(state)
            }
        })
        return childStore
    }

    public func createChildStore<ChildAction>(
        reducer: Reducer<State, ChildAction>,
        initialAction: ChildAction? = nil
    ) -> Store<State, ChildAction> {
        return createChildStore(
            reducer: reducer,
            initialAction: initialAction,
            middleware: []
        )
    }
}
