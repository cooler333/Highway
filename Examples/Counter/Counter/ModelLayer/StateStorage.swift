//
//  StateStorage.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Foundation

protocol StateStorageProtocol {
    func save(_ state: AppState)
    func getState() -> AppState?
}

final class StateStorage: StateStorageProtocol {
    func save(_ state: AppState) {
        do {
            let plist = try PropertyListEncoder().encode(state)
            UserDefaults.standard.set(plist, forKey: "state")
            UserDefaults.standard.synchronize()
        } catch {
            print(error)
        }
    }

    func getState() -> AppState? {
        guard let data = UserDefaults.standard.value(forKey: "state") as? Data else { return nil }
        do {
            return try PropertyListDecoder().decode(AppState.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
}
