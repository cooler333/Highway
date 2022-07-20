//
//  RootFeature.swift
//  AnimatedEditableList
//
//  Created by Dmitrii Cooler on 20.07.2022.
//

import Foundation

enum RootFeature {
    struct State: Equatable {
        var data: [Section] = []
        
        struct Section: Equatable {
            let id: Int
            var items: [AnyHashable]
            
            struct Title: Hashable {
                let id: String
                let value: String
            }

            struct Details: Hashable {
                let id: String
                let value: String
            }

            struct Image: Hashable {
                let id: String
                let value: URL
            }
        }
    }

    enum Action {
        case initial
    }
}
