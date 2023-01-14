## Update view

1. Open `MainViewController.swift` and add `autoIncrementButton` property
```swift
private var autoIncrementButton: UIButton!
```
2. Create button
```swift
override func viewDidLoad() {
    // ...
    decrementButton.titleLabel?.font = .systemFont(ofSize: 30)

    let autoIncrementButton = UIButton(primaryAction: UIAction(handler: { [weak self] _ in
        guard let self = self else { return }
        if self.store.state.isAutoIncrementEnabled {
            self.store.dispatch(.stopAutoIncrement)
        } else {
            self.store.dispatch(.startAutoIncrement)
        }
    }))
    autoIncrementButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(autoIncrementButton)
    autoIncrementButton.topAnchor.constraint(equalTo: decrementButton.bottomAnchor, constant: 20).isActive = true
    autoIncrementButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    autoIncrementButton.setTitle("Start", for: .normal)
    autoIncrementButton.titleLabel?.font = .systemFont(ofSize: 30)
    self.autoIncrementButton = autoIncrementButton

    // ...
}
```
3. Change subscribe closure to update button text
```swift
store.subscribe { [weak self] state in
    DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        self.label.text = "\(state.count)"
        if state.isAutoIncrementEnabled {
            self.autoIncrementButton.setTitle("Stop", for: .normal)
        } else {
            self.autoIncrementButton.setTitle("Start", for: .normal)
        }
    }
}
```
4. Run app and tap "Start" button. Then the label will increase value every second.
5. That's it!

[Go to home page](https://github.com/cooler333/Highway)
