//
//  Store.swift
//  Highway
//
//  Created by Dmitrii Cooler on 02.07.2022.
//

public final class Store<State: Equatable, Action> {

    private var state: State

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
        self.state = state

        dispatch(initialAction)
    }
    
    public func getState() -> State {
        state
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
            subscriptions.forEach {
                $0.listener(state)
            }
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
    
    public func createSubStore<SubState, SubAction>(
        reducer: @escaping Reducer<SubState, SubAction>,
        subState: WritableKeyPath<State, SubState>,
        initialAction: SubAction,
        middleware: [Middleware<SubState, SubAction>] = []
    ) -> Store<SubState, SubAction> {
        return Store<SubState, SubAction>(
            reducer: { state, action in
                let newState = reducer(state, action)
                self.state[keyPath: subState] = newState
                return newState
            },
            state: state[keyPath: subState],
            initialAction: initialAction,
            middleware: middleware
        )
    }
}
