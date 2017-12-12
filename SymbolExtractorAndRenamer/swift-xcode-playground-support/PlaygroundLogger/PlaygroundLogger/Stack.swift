//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

final class Stack<T> {
    private var impl: [T]
    private var pos: Int
    
    init() {
        impl = []
        pos = 0
    }
    
    func push(_ x: T) {
        let i = pos
        pos += 1
        impl.insert(x, at: i)
    }
    
    func pop() -> T {
        assert(pos > 0, "Cannot pop out of an empty stack")
        pos -= 1
        return impl[pos]
    }
    
    func tryPop() -> T? {
        if pos == 0 { return nil }
        return pop()
    }
    
    func peek() -> T {
        assert(pos > 0, "Cannot peek out of an empty stack")
        return impl[pos-1]
    }
    
    func tryPeek() -> T? {
        if pos == 0 { return nil }
        return peek()
    }

    var empty: Bool { return pos == 0 }
}
