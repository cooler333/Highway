//
//  RootState.swift
//  SocketPingPong
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Foundation

struct AppState: Equatable {
    enum PlayType: Equatable {
        case readyToPlay
        case playing
        case paused
    }

    enum SideType: Equatable {
        case ping
        case pong
        case unknown
    }

    var playType: PlayType = .paused
    var sideType: SideType = .unknown
}
