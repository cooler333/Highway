//
//  StateStorage.swift
//  Counter
//
//  Created by Dmitrii Coolerov on 08.07.2022.
//

import Foundation

protocol StateStorageProtocol {
    func save(_ state: AppState, completion: @escaping (Result<Void, Error>) -> Void)
    func getState() -> AppState?
}

final class StateStorage: StateStorageProtocol {
    private let saveQueue = DispatchQueue(label: "StateStorage.SaveQueue")

    func save(_ state: AppState, completion: @escaping (Result<Void, Error>) -> Void) {
        saveQueue.asyncAfter(
            deadline: .now() + 3
        ) {
            do {
                let plist = try PropertyListEncoder().encode(state)
                UserDefaults.standard.set(plist, forKey: "state")
                UserDefaults.standard.synchronize()
                completion(.success(()))
            } catch {
                print(error)
                completion(.failure(error))
            }
        }
    }

    func getState() -> AppState? {
        guard let data = UserDefaults.standard.value(forKey: "state") as? Data else { return nil }
        do {
            return try PropertyListDecoder().decode(AppState.self, from: data)
        } catch {
            return nil
        }
    }
}
