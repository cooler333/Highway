## Add ModuleOutput

1. Udpate `MainModuleBuilder.swift`
```swift
import Foundation
import Highway

protocol MainModuleOutput: AnyObject {
    func mainModuleDidTapRandomButton()
}

final class MainModuleBuilder {
    func build(store: Store<MainFeature.State, MainFeature.Action>) -> UIViewController {
        return MainViewController(store: store)
    }
}
```
2. Go to `MainFlowCoordinator.swift`
3. Add import
```swift
// ...

import Highway
```
4. Add store property
```swift
final class MainFlowCoordinator {
    // ...

    private var store: Store<MainFeature.State, MainFeature.Action>!
```
5. Update start function
```swift
func start() {
    let store = Store<MainFeature.State, MainFeature.Action>(
        reducer: MainFeature.reducer(),
        state: MainFeature.State(),
        initialAction: nil,
        middleware: MainFeature.middleware(
            environment: .init(moduleOutput: self)
        )
    )
    self.store = store

    let mainViewController = MainModuleBuilder().build(store: store)
    window.rootViewController = mainViewController
    self.rootViewController = mainViewController
}
```
6. Go to `MainFeature.swift`
7. Add following to the end of the file
```swift
extension MainFeature {
    final class Environment {
        weak var moduleOutput: MainModuleOutput!

        init(moduleOutput: MainModuleOutput) {
            self.moduleOutput = moduleOutput
        }
    }
}
```
8. Add an environment argument to the `middleware` func
```swift
extension MainFeature {
    static func middleware(environment: Environment) -> [Middleware<MainFeature.State, MainFeature.Action>] {
        // ...
    }
}
```
9. Go to the `MainFlowCoordinator.swift` and add folling to the end of file
```swift
extension MainFlowCoordinator: MainModuleOutput {
    func mainModuleDidTapRandomButton() {
        // TODO: show random module
    }
}
```

[Next: Present second module](SecondModule.md)
