## Upgrade routing

1. Create `MainFlowCoordinator.swift` file inside `exmpl` folder in `exmpl` project
2. Add implementation
```swift
import UIKit

final class MainFlowCoordinator {

    private weak var window: UIWindow!
    private weak var rootViewController: UIViewController!

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let mainViewController = MainModuleBuilder().build()
        window.rootViewController = mainViewController
        self.rootViewController = mainViewController
    }
}
```
3. Open `SceneDelegate.swift`
4. Add property
```swift
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
// ...

private var flowCoordinator: MainFlowCoordinator!
```
5. Update scene function
```swift
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    self.window = window
    window.makeKeyAndVisible()

    flowCoordinator = MainFlowCoordinator(window: window)
    flowCoordinator.start()
}
```

[Next: Add ModuleOutput](ModuleOutput.md)
