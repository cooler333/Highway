## Add module builder

1. Create empty MainModuleBuilder.swift file
2. Implement build function
```swift
import Foundation
import Highway

final class MainModuleBuilder {
    func build() -> UIViewController {
        let store = Store<MainFeature.State, MainFeature.Action>(
            reducer: MainFeature.reducer(),
            state: MainFeature.State()
        )

        let viewController = MainViewController(store: store)
        return viewController
    }
}
```
3. Build and show view controller
```swift
let mainViewController = MainBuilder().build()
otherViewController.present(viewController, animated: true)
```
4. Run app and tap on "plus" button. Label will update from 0 to 1

[Next: Middleware and asyncronious logic](Middleware.md)
