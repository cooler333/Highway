//
//  RootState.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Foundation

struct AppState: Equatable {
    var count = 0
    var isSaving = false
    var saved = false
}

// to save to UserDefaults
extension AppState: Codable {}
