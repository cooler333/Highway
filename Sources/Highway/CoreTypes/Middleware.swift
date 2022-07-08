//
//  Middleware.swift
//  Highway
//
//  Created by Dmitrii Cooler on 02.07.2022.
//

public typealias Middleware<State, ActionType> = (
    @escaping Dispatch<ActionType>, State, ActionType
) -> Void
