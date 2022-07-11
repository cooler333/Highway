//
//  Middleware.swift
//  Highway
//
//  Created by Dmitrii Cooler on 02.07.2022.
//

public typealias Middleware<State, ActionType> = (
    @escaping Dispatch<ActionType>, () -> State, ActionType
) -> Void

public func createMiddleware<State, Action, Environment>(
    environment: Environment,
    _ body: @escaping (
        _ dispatch: @escaping Dispatch<Action>,
        _ getState: () -> State,
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
        _ getState: () -> State,
        _ action: Action
    ) -> Void
) -> Middleware<State, Action> {
    return { dispatch, getState, action in
        body(dispatch, getState, action)
    }
}
