# Highway

If you were looking for a something like this: 
- TEA (The Elm Architecture)
- MVU (Model-View-Update)
- MVI (Model-View-Intent)
- Redux-like
- Flux-like
- UDF (Unidirectional Data Flow)
- e.t.c

...but on Swift. Then you have found it!

Highway is implementation of TEA/MVU architecture pattern using Swift.

## Features

- Cancellable side effects (cancel outdated network requests)
- Do not use 3rd party libraries
- use Combine
- 100% business logic code coverage
- Lightweight: 2 structs, 1 enum, 2 final classes; less than 200 lines of code

#### We're open to merge requests

## Examples

- [Infinite Scroll](https://github.com/cooler333/Highway/tree/main/Examples/InfiniteScroll)

#### Other
- [Cocoapods integration](https://github.com/cooler333/Highway/tree/main/Examples/PodExample)
- [Swift Package Manager integration](https://github.com/cooler333/Highway/tree/main/Examples/SPMExample)

## Requirements

- iOS: 13.0
- Swift: 5.5

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

Dmitrii Coolerov, coolerov333@gmail.com

## License

Highway is available under the MIT license. See the LICENSE file for more info.
