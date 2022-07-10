//
//  Reducer.swift
//  Highway
//
//  Created by Dmitrii Cooler on 02.07.2022.
//

public typealias Reduce<State, Action> = (
    _ state: State,
    _ action: Action
) -> State

public struct Reducer<State, Action> {
    let reduce: Reduce<State, Action>

    public init(_ reduce: @escaping Reduce<State, Action>) {
        self.reduce = reduce
    }
}
