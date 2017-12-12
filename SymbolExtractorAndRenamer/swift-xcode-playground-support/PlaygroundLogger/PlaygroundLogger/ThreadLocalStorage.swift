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

import Foundation

final class ThreadLocalStorage<T: AnyObject> {
    private let key: NSString
    
    init (key: String) {
        self.key = NSString(string: key)
    }
    
    var Data: T? {
        get {
            let dict = Thread.current.threadDictionary
#if APPLE_FRAMEWORKS_AVAILABLE
    return dict.object(forKey: key) as? T
#else
           if let index = dict.indexForKey(key) {
               return dict[index].1 as? T
           }
           return nil
#endif
        }
        set (value) {
            Thread.current.threadDictionary[key] = value
        }
    }
}
