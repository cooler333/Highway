//
//  Assertions
//  Copyright © 2015 mohamede1945. All rights reserved.
//  https://github.com/mohamede1945/AssertionsTestingExample
//

import Foundation

func raiseFatalError(
    _ message: @autoclosure () -> String = "",
    file: StaticString = #file,
    line: UInt = #line
) -> Never {
    Assertions.fatalErrorClosure(message(), file, line)
    repeat {
        RunLoop.current.run()
    } while (true)
}

class Assertions {
    static var fatalErrorClosure = swiftFatalErrorClosure
    static let swiftFatalErrorClosure: (String, StaticString, UInt) -> Void
        = { Swift.fatalError($0, file: $1, line: $2) }
}
