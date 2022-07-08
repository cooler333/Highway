//
//  MainAction.swift
//  Counter
//
//  Created by Dmitrii Cooler on 08.07.2022.
//

import Foundation

extension MainFeature {
    enum Action: Equatable {
        case initial
        case increment
        case decrement
        case save
        case saved(success: Bool)
    }
}
