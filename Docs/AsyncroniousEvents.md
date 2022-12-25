## Call Asyncronious action

1. Open `MainFeature.swift` and import Combine framework
```swift
import Foundation
import Highway
import Combine
```
2. Add new property to State
```swift
extension MainFeature {
    struct State: Equatable {
        var count = 0
        var isAutoIncrementEnabled = false
    }
}
```
3. Add new case to Action
```swift
extension MainFeature {
    enum Action: Equatable {
        case increment
        case decrement
        case autoIncrement
    }
}
```
4. Implement case in reducer
```swift
extension MainFeature {
    static func reducer() -> Reducer<MainFeature.State, MainFeature.Action> {
        return .init { state, action in
            switch action {
            // ...

            case .decrement:
                var state = state
                state.count -= 1
                return state

            case .startAutoIncrement:
                var state = state
                state.isAutoIncrementEnabled = true
                return state

            case .stopAutoIncrement:
                var state = state
                state.isAutoIncrementEnabled = false
                return state
            }
        }
    }
}
```
5. Add middleware with Timer. Do not forget to handle new case in previous middleware.
```swift
extension MainFeature {
    static func middleware() -> [Middleware<MainFeature.State, MainFeature.Action>] {
        var timerCancellable: [AnyCancellable] = []
        return [
            createMiddleware({ dispatch, getState, action in
                switch action {
                case .decrement:
                    print("Decrement action is called")

                case .increment:
                    print("Increment action is called")

                case .autoIncrement:
                    break
                }
            }),
            createMiddleware({ dispatch, getState, action in
                switch action {
                case .startAutoIncrement:
                    Timer.publish(every: 1, on: .main, in: .default)
                        .autoconnect()
                        .sink { _ in
                            dispatch(.increment)
                        }
                        .store(in: &timerCancellable)

                case .stopAutoIncrement:
                    timerCancellable.forEach({ $0.cancel() })
                    timerCancellable.removeAll()

                default:
                    break
                }
            })
        ]
    }
}
```
Async actions called via `dispatch()`

[Next: View events](ViewEvents.md)
