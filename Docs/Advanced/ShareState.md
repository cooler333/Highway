## Share state

1. Open `MainFeature.swift`
2. Add new action to open next module
```swift
extension MainFeature {
    enum Action: Equatable {
        // ...
        case random
    }
}
```
3. Add new middleware
```swift
static func middleware(environment: Environment) -> [Middleware<MainFeature.State, MainFeature.Action>] {
    var timerCancellable: [AnyCancellable] = []
    return [
        // ...
        // Add following to the end of array
        createMiddleware(environment: environment, { dispatch, getState, action, environment in
            guard action == .random else { return }
            DispatchQueue.main.async { [weak environment] in
                environment?.moduleOutput.mainModuleDidTapRandomButton()
            }
        })
    }
}
```
4. Update reducer
```swift
static func reducer() -> Reducer<MainFeature.State, MainFeature.Action> {
    static func reducer() -> Reducer<MainFeature.State, MainFeature.Action> {
        return .init { state, action in
            switch action {
            // ...
            case .stopAutoIncrement:
                var state = state
                state.isAutoIncrementEnabled = false
                return state

            case .random:
                return state
            }
        }
    }
}
```
5. Update first middleware
```swift
extension MainFeature {
    static func middleware(environment: Environment) -> [Middleware<MainFeature.State, MainFeature.Action>] {
        var timerCancellable: [AnyCancellable] = []
        return [
            createMiddleware({ dispatch, getState, action in
                switch action {
                // ...
                case .startAutoIncrement, .stopAutoIncrement, .random:
                    break
                }
            }),
            // ...
        ]
    }
}
```
6. Go to `MainViewController.swift` and add button to open `Randomizer` module
```swift
final class MainViewController: UIViewController {
    // ...
    override func viewDidLoad() {
        super.viewDidLoad()
        // ...
        self.autoIncrementButton = autoIncrementButton

        let randomButton = UIButton(primaryAction: UIAction(handler: { [weak self] _ in
            self?.store.dispatch(.random)
        }))
        randomButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(randomButton)
        randomButton.topAnchor.constraint(equalTo: autoIncrementButton.bottomAnchor, constant: 20).isActive = true
        randomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        randomButton.setTitle("Open 'Random'", for: .normal)
        randomButton.titleLabel?.font = .systemFont(ofSize: 20)

        let label = UILabel()
        // ...
    }
}
```
7. Run app and tap "Start" button
8. Wait for a second
9. Tap `Open 'Random'` Button
10. Label will increase value every second
11. Play with counter
9. That's it!

[Go to home page](https://github.com/cooler333/Highway)
