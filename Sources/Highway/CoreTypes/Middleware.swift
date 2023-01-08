//
//  Middleware.swift
//  Highway
//
//  Created by Dmitrii Cooler on 02.07.2022.
//

public typealias GetState<State> = () -> State?

public struct Middleware<State, Action> {
    private let body: (@escaping Dispatch<Action>, @escaping GetState<State>, Action) -> Void

    public init<Environment>(
        body: @escaping (@escaping Dispatch<Action>, @escaping GetState<State>, Action, Environment) -> Void,
        environment: Environment
    ) {
        self.body = { dispatch, getState, action in
            body(dispatch, getState, action, environment)
        }
    }

    public init(
        body: @escaping (@escaping Dispatch<Action>, @escaping GetState<State>, Action) -> Void
    ) {
        self.body = body
    }

    public func run(dispatch: @escaping Dispatch<Action>, getState: @escaping GetState<State>, action: Action) {
        body(dispatch, getState, action)
    }
}

public func createMiddleware<State, Action, Environment>(
    environment: Environment,
    _ body: @escaping (
        _ dispatch: @escaping Dispatch<Action>,
        _ getState: @escaping () -> State?,
        _ action: Action,
        _ environment: Environment
    ) -> Void
) -> Middleware<State, Action> {
    return .init(body: body, environment: environment)
}

public func createMiddleware<State, Action>(
    _ body: @escaping (
        _ dispatch: @escaping Dispatch<Action>,
        _ getState: @escaping () -> State?,
        _ action: Action
    ) -> Void
) -> Middleware<State, Action> {
    return .init(body: body)
}
