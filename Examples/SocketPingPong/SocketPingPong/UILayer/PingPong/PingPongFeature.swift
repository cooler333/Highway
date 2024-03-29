//
//  PingPongFeature.swift
//  SocketPingPong
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Combine
import Foundation
import Highway

enum PingPongFeature {
    enum Action: Equatable {
        case initial
        case play
        case pause
        case received
    }

    class Environment {
        var cancellable = Set<AnyCancellable>()
    }

    static func reducer() -> Reducer<AppState, Action> {
        return .init { state, action in
            switch action {
            case .initial:
                var state = state
                state.playType = .paused
                return state

            case .play:
                var state = state
                state.playType = .readyToPlay
                return state

            case .pause:
                var state = state
                state.playType = .paused
                return state

            case .received:
                var state = state
                state.playType = .playing
                if state.sideType == .ping {
                    state.sideType = .pong
                } else {
                    state.sideType = .ping
                }
                return state
            }
        }
    }

    static func middlewares(environment: Environment) -> [Middleware<AppState, Action>] {
        return [
            createMiddleware { dispatch, getState, _ in
                guard let state = getState() else { return }

                if state.playType == .paused {
                    environment.cancellable.forEach { $0.cancel() }
                }

                if state.playType == .readyToPlay {
                    Timer.publish(
                        every: 1,
                        on: .main,
                        in: .common
                    )
                    .autoconnect()
                    .sink { _ in
                        guard let state = getState() else { return }
                        if state.playType == .paused {
                            environment.cancellable.forEach { $0.cancel() }
                        } else {
                            dispatch(.received)
                        }
                    }
                    .store(in: &environment.cancellable)
                }
            },
        ]
    }
}
