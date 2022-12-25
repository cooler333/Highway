## Business logic

1. Create empty MainFeature.swift file
1. Add imports
```swift
import Foundation
import Highway
```
1. Add namespace
```swift
// ...

enum MainFeature {}
```
1. Add state
```swift
// ...

extension MainFeature {
    struct State: Equatable {
        var count = 0
    }
}
```
1. Add actions 
```swift
// ...

extension MainFeature {
    enum Action: Equatable {
        case increment
        case decrement
    }
}
```
1. Add reducer and business logic
```swift
// ...

extension MainFeature {
    static func reducer() -> Reducer<MainFeature.State, MainFeature.Action> {
        return .init { state, action in
            switch action {
            case .increment:
                var state = state
                state.count += 1
                return state

            case .decrement:
                var state = state
                state.count += 1
                return state
            }
        }
    }
}
```
