//
//  Thunk.swift
//  Highway
//
//  Created by Dmitrii Cooler on 02.07.2022.
//

import Foundation

public struct Thunk<State, Action, Environment> {
    let environment: Environment
    let body: (
        _ dispatch: @escaping Dispatch<Action>,
        _ getState: () -> State,
        _ action: Action,
        _ environment: Environment
    ) -> Void

    public init(
        environment: Environment,
        body: @escaping (
            _ dispatch: @escaping Dispatch<Action>,
            _ getState: () -> State,
            _ action: Action,
            _ environment: Environment
        ) -> Void
    ) {
        self.environment = environment
        self.body = body
    }
}

public extension Thunk where Environment == Void {
    init(
        body: @escaping (
            _ dispatch: @escaping Dispatch<Action>,
            _ getState: () -> State,
            _ action: Action,
            _ environment: Environment
        ) -> Void
    ) {
        environment = ()
        self.body = body
    }
}

public func createThunkMiddleware<State, Action: Equatable, Environment>(
    thunk: Thunk<State, Action, Environment>
) -> Middleware<State, Action> {
    return { dispatch, getState, action in
        thunk.body(dispatch, getState, action, thunk.environment)
    }
}

public func createThunkMiddleware<State, Action: Equatable, Environment>(
    thunk: Thunk<State, Action, Environment>,
    action thunkAction: Action
) -> Middleware<State, Action> {
    return { dispatch, getState, action in
        if action == thunkAction {
            thunk.body(dispatch, getState, action, thunk.environment)
        }
    }
}

public func createThunkMiddleware<State, Action: Equatable, Environment>(
    thunk: Thunk<State, Action, Environment>,
    actions: [Action]
) -> Middleware<State, Action> {
    return { dispatch, getState, action in
        if actions.contains(action) {
            thunk.body(dispatch, getState, action, thunk.environment)
        }
    }
}
