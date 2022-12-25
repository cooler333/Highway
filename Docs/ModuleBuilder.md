## Add module builder

1. Create empty `MainModuleBuilder.swift` file inside `exmpl/Main` folder in `exmpl` project
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
3. Open `SceneDelegate.swift`, call build function and present `MainViewController`
```swift
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // ...
    window.makeKeyAndVisible()

    let mainViewController = MainModuleBuilder().build()
    otherViewController.present(mainViewController, animated: true)
}
```
4. Run app and tap on "plus" button. Label will update from 0 to 1

[Next: Middleware and asyncronious logic](Middleware.md)
