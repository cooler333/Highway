# Highway

Highway is implementation of Redux-like architecture pattern using Swift.

If you were looking for a something like this: 
- TEA (The Elm Architecture)
- MVU (Model-View-Update)
- MVI (Model-View-Intent)
- Redux-like
- Flux-like
- UDF (Unidirectional Data Flow)
- e.t.c

...but on Swift. Then you have found it!

## Features

- Multistore support (single state sharing)
- Fast state change and sync
- 100% business logic code coverage
- Lightweight
- Do not use 3rd party libraries
- can be used with SwiftUI

## Examples

- [Counter](https://github.com/cooler333/Highway/tree/main/Examples/Counter): Lighweight multi store app (Single view controller with multiple child view controller)
- [SwiftUI](https://github.com/cooler333/Highway/blob/main/Examples/Counter/Counter/UILayer/Main/View/MainView.swift): SwiftUI View with updates
- [SocketPingPong](https://github.com/cooler333/Highway/tree/main/Examples/SocketPingPong): An app with stream of events (like web socket or server side events)
- [ReusableViewControllers](https://github.com/cooler333/Highway/tree/main/Examples/ReusableViewControllers): Reuse view controller or view which was written with imperative style
- [Animation](https://github.com/cooler333/Highway/tree/main/Examples/Animation): View animation triggered by state change
- TODO: TableView with deletions/insertions
- [Infinite Scroll](https://github.com/cooler333/Highway/tree/main/Examples/InfiniteScroll): Enterprise solution app (with Dependency Injection, Flow Coordinator e.t.c.)

https://user-images.githubusercontent.com/2772537/177874199-1ba154f8-7982-4016-8618-dc59f76a5d6f.mov

#### Other
- [Cocoapods integration](https://github.com/cooler333/Highway/tree/main/Examples/PodExample)
- [Swift Package Manager integration](https://github.com/cooler333/Highway/tree/main/Examples/SPMExample)

## Requirements

- iOS: 13.0
- Swift: 5.4

## Installation (Cocoapods / SPM)

Highway is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Highway'
```

Also you can integrate framework as SPM package

## Alternatives
- [Mobius.swift](https://github.com/spotify/Mobius.swift)
- [ReSwift](https://github.com/ReSwift/ReSwift)
- [ReCombine](https://github.com/ReCombine/ReCombine)
- [Swift Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture)
- [Tea In Swift](https://github.com/chriseidhof/tea-in-swift)
- [SwiftRex](https://github.com/SwiftRex/SwiftRex)
- [More](https://github.com/onmyway133/awesome-ios-architecture#unidirectional-data-flow)

## Author

Dmitrii Cooler, coolerov333@gmail.com

## Credits and thanks

The following people gave feedback on the library at its early stages and helped make the library what it is today:

Special thanks to:

- [Aleksey Alekseev](https://github.com/joyalex) who helped me to imporve library peformance
- [Dmitii Bobrov](https://github.com/dimabobrov) with major feedback on early concepts 

## License

Highway is available under the MIT license. See the LICENSE file for more info.
