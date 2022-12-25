## Create view

1. Create empty MainViewController.swift file
2. Add imports
```swift
import UIKit
import Highway
```
3. Add Store as a property and initializer
```swift
final class MainViewController: UIViewController {
    private let store: Store<MainFeature.State, MainFeature.Action>

    init(store: Store<MainFeature.State, MainFeature.Action>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
```
4. Add increment/decrement buttons
```swift
// ...

override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground

    let incrementButton = UIButton(primaryAction: UIAction(handler: { [weak self] _ in
        self?.store.dispatch(.increment)
    }))
    incrementButton.setTitle("+", for: .normal)
    incrementButton.titleLabel?.font = .systemFont(ofSize: 30)
    view.addSubview(incrementButton)
    incrementButton.translatesAutoresizingMaskIntoConstraints = false
    incrementButton.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 20).isActive = true
    incrementButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 20).isActive = true

    let decrementButton = UIButton(primaryAction: UIAction(handler: { [weak self] _ in
        self?.store.dispatch(.decrement)
    }))
    decrementButton.setTitle("-", for: .normal)
    decrementButton.titleLabel?.font = .systemFont(ofSize: 30)
    view.addSubview(decrementButton)
    decrementButton.translatesAutoresizingMaskIntoConstraints = false
    decrementButton.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -20).isActive = true
    decrementButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 20).isActive = true
}

// ...
```
5. Add label property
```swift
final class MainViewController: UIViewController {
    // ...

    private var label: UILabel!
```
6. Add label
```swift
override func viewDidLoad() {
    // ...

    let label = UILabel()
    label.text = "\(store.state.count)"
    label.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(label)
    label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    self.label = label
}
```
7. Subscribe to store updates
```swift
override func viewDidLoad() {
    // ...

    store.subscribe { state in
        DispatchQueue.main.async { [weak self] in
            self?.label.text = "\(state.count)"
        }
    }
}
```

[Next: Module builder](ModuleBuilder.md)