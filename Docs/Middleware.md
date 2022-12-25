## Middleware

1. Add middleware builder function to MainFeature.swift
```swift
// ...

extension MainFeature {
    static func middleware() -> [Middleware<MainFeature.State, MainFeature.Action>] {
        return [
            createMiddleware({ dispatch, getState, action in
                switch action {
                case .decrement:
                    print("Decrement action is called")

                case .increment:
                    print("Increment action is called")
                }
            })
        ]
    }
}
```
2. Add middleware to store initializer
```swift
final class MainBuilder {
    func build() -> UIViewController {
        let store = Store<MainFeature.State, MainFeature.Action>(
            reducer: MainFeature.reducer(),
            state: MainFeature.State(),
            initialAction: nil,
            middleware: MainFeature.middleware()
        )

        let viewController = MainViewController(store: store)
        return viewController
    }
}
```
3. Run app and tap on plus sign button. The next output will be printed to console
```
> Increment action is called
```

[Next: Asyncronious events](AsyncroniousEvents.md)
