//
//  Thunk.swift
//  Highway
//
//  Created by Dmitrii Cooler on 02.07.2022.
//

import Foundation

public struct Thunk<State, Action, Environment> {
    let environment: Environment?
    let body: (
        _ dispatch: @escaping Dispatch<Action>,
        _ state: State,
        _ action: Action,
        _ environment: Environment?
    ) -> Void
    
    public init(
        environment: Environment,
        body: @escaping (
            _ dispatch: @escaping Dispatch<Action>,
            _ getState: State,
            _ action: Action,
            _ environment: Environment?
        ) -> Void
    ) {
        self.environment = environment
        self.body = body
    }
}
