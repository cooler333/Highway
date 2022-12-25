## Mobule builder

1. Create empty MainModuleBuilder.swift file
1. Implement build function
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
1. Build and show view controller
```swift
let mainViewController = MainBuilder().build()
otherViewController.present(viewController, animated: true)
```