## Implement business logic

1. Create empty `MainFeature.swift` file inside exmpl/Main folder in exmpl project
2. Add imports
```swift
import Foundation
import Highway
```
3. Add namespace for your module
```swift
// ...

enum MainFeature {}
```
4. Add state data
```swift
// ...

extension MainFeature {
    struct State: Equatable {
        var count = 0
    }
}
```
5. Add actions/events
```swift
// ...

extension MainFeature {
    enum Action: Equatable {
        case increment
        case decrement
    }
}
```
6. Add reducer and business logic for state mutation
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
                state.count -= 1
                return state
            }
        }
    }
}
```

[Next: View](View.md)
