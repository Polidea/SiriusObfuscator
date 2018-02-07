//
// Created by Maciej Oczko on 26.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation

func isRunningTests() -> Bool {
    return ProcessInfo.processInfo.environment["XCInjectBundle"] != nil
}

struct Dispatcher {
    static func delay(_ delay: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}

func abstractMethod() -> Never {
    fatalError("Override this method")
}
