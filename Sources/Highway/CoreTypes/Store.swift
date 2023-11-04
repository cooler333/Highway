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
            notifier.publish(newValue: _state)
        }
    }

    private var reducer: Reducer<State, Action>
    private let notifier: Notifier<State> = .init()
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
        return notifier.subscribe(listener: listener)
    }

    public func unsubscribe(_ subscription: Subscription<State>) {
        notifier.unsubscribe(subscription)
    }

    public func innerDispatch(action: Action) {
        let newState = reducer.reduce(state, action)
        if state != newState {
            state = newState
        }

        let middlewareDispatch: (Action) -> Void = { [weak self] middlewareAction in
            guard let self else {
                debugPrint("dispatch() called after Store deinit")
                return
            }
            self.innerDispatch(action: middlewareAction)
        }
        let getState: () -> State? = { [weak self] in
            guard let self else {
                debugPrint("getState() called after Store deinit")
                return nil
            }
            return self.state
        }
        middleware.forEach { middleware in
            middleware.run(dispatch: middlewareDispatch, getState: getState, action: action)
        }
    }

    public func dispatch(_ action: Action) {
        internalQueue.async { [weak self] in
            guard let self else { return }
            guard !self.isDispatching.value else {
                fatalError(
                    """
                    Action has been dispatched while a previous action is being processed.
                    A reducer is dispatching an action in a concurrent context (e.g. from multiple threads).
                    Action: \(action)
                    """
                )
            }

            self.isDispatching.value { $0 = true }
            self.innerDispatch(action: action)
            self.isDispatching.value { $0 = false }
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
            childStore.notifier.publish(newValue: state[keyPath: keyPath])
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
            childStore.notifier.publish(newValue: state)
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
