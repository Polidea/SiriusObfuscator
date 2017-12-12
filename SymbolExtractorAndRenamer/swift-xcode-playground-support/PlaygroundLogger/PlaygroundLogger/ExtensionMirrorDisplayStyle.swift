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

extension Mirror.DisplayStyle {
   func getConsumedDepthLevels() -> UInt64 {
      switch self {
         // Dictionaries contain (key,value) tuples, and we don't want those tuples to consume a level of depth
         // as the effect we want to achieve is that the dictionary directly contains those keys and values
         // The easiest way to achieve that effect is to have the dictionary not consume depth rather than keep track
         // of being in a dictionary as we encode the tuples and have the nested tuples not consume depth
      case .dictionary: return 0
        // Optionals are interesting, but having an optional consume one of our precious levels of depths causes
        // unpleasant displays when we run out too soon, and end up showing "..." instead of contained data
        // Attempt to fix this by making the optional case not consume a level
      case .optional: return 0
      default: return 1
      }
   }
}

extension Mirror.DisplayStyle : CustomStringConvertible {
    public var description: String {
        switch self {
        case .class: return "class"
        case .struct: return "struct"
        case .tuple: return "tuple"
        case .enum: return "enum"
        case .optional: return "optional"
        case .collection: return "collection"
        case .dictionary: return "dictionary"
        case .set: return "set"
        default: return "unknown"
        }
    }
}
