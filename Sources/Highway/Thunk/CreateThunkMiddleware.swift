//
//  CreateThunkMiddleware.swift
//  Highway
//
//  Created by Dmitrii Cooler on 02.07.2022.
//

import Foundation

public func createThunkMiddleware<State, Action: Equatable, Environment>(
    thunk: Thunk<State, Action, Environment>,
    action: Action
) -> Middleware<State, Action> {
    return { dispatch, state, action in
        if action == action {
            thunk.body(dispatch, state, action, thunk.environment)
        }
    }
}

public func createThunkMiddleware<State, Action: Equatable, Environment>(
    thunk: Thunk<State, Action, Environment>,
    actions: [Action]
) -> Middleware<State, Action> {
    return { dispatch, state, action in
        if actions.contains(action) {
            thunk.body(dispatch, state, action, thunk.environment)
        }
    }
}

public func createMiddleware<State, Action, Environment>(
    environment: Environment,
    _ body: @escaping (
        _ dispatch: @escaping Dispatch<Action>,
        _ state: State,
        _ action: Action,
        _ environment: Environment
    ) -> Void
) -> Middleware<State, Action> {
    return { dispatch, getState, action in
        body(dispatch, getState, action, environment)
    }
}

public func createMiddleware<State, Action>(
    _ body: @escaping (
        _ dispatch: @escaping Dispatch<Action>,
        _ state: State,
        _ action: Action
    ) -> Void
) -> Middleware<State, Action> {
    return { dispatch, getState, action in
        body(dispatch, getState, action)
    }
}
