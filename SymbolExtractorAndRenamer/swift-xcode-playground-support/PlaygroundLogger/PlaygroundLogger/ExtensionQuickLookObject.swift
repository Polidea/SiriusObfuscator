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

extension QuickLookObject {
    // checks the rules for the "prefer summary" flag to be set
    func shouldPreferSummary(mirror: LoggerMirror) -> Bool {
#if APPLE_FRAMEWORKS_AVAILABLE
        if let obj = mirror.value as? AnyObject {
            if obj.responds(to: Selector(("debugQuickLookObject"))) {
                switch self {
                case .text(_), .attributedString(_), .int(_), .uInt(_), .float(_): return false
                default: return true
                }
            }
        }
#endif
        return false
    }
}

extension QuickLookObject {
    func getStringIfAny() -> String? {
        switch self {
        case .text(let str): return str
        default: return nil
        }
    }
}

