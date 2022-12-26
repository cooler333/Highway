## Present second module

1. Go to `MainFlowCoordinator.swift`
2. Replace `TODO` and pass shared state (via child store) to `Randomizer` module
```swift
func mainModuleDidTapRandomButton() {
    let childStore = store.createChildStore(
        keyPath: \.count,
        reducer: RandomizerFeature.reducer(),
        middleware: RandomizerFeature.middleware(
            environment: .init(moduleOutput: self)
        )
    )
    let randomizeViewController = RandomizerModuleBuilder().build(store: childStore)
    rootViewController.present(randomizeViewController, animated: true)
}
```
3. Implement `RandomizerModuleOutput`
```swift
extension MainFlowCoordinator: RandomizerModuleOutput {
    func randomizerModuleDidTapCloseButton() {
        rootViewController.dismiss(animated: true)
    }
}
```

[Next: Share state](ShareState.md)
