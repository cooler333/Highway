//
//  Reducer.swift
//  Highway
//
//  Created by Dmitrii Cooler on 02.07.2022.
//

public typealias Reducer<ReducerStateType, ActionType> = (
    _ state: ReducerStateType,
    _ action: ActionType
) -> ReducerStateType
