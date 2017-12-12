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

typealias SourceLocation = (line: UInt64, col: UInt64)
typealias SourceRange = (begin: SourceLocation, end: SourceLocation)

protocol Serializable {
    func toBytes() -> [UInt8]
    init? (storage: BytesStorage)
}

typealias ChildrenRange = CountableRange<UInt64>
typealias QuickLookObject = Swift.PlaygroundQuickLook

// given a disparate array of ranges, return a possibly smaller such array such that
// no two ranges overlap and ranges are sorted by their startIndex
func generateNonOverlappingUnion(_ ranges : [ChildrenRange]) -> [ChildrenRange] {
    // less than 2 ranges can't overlap now can they
    if (ranges.count < 2) {
        return ranges
    }
    let sorted = ranges.sorted {
        $0.startIndex < $1.startIndex
    }
    var actual_ranges = Array<ChildrenRange>()
    var current_range = sorted[0]
    for i in 1..<sorted.count {
        if sorted[i].startIndex <= current_range.endIndex {
            current_range = current_range.startIndex..<sorted[i].endIndex
        } else {
            actual_ranges.append(current_range)
            current_range = sorted[i]
        }
    }
    // append whatever range we are left with before returning
    actual_ranges.append(current_range)
    return actual_ranges
}

// this assumes the ranges are sorted by their startIndex
// given an array of ranges return a possibly smaller such array such that
// no range includes a value >= upper_bound
func boundCheckRanges(_ ranges : [ChildrenRange], _ upper_bound : UInt64) -> [ChildrenRange] {
    var actual_ranges = Array<ChildrenRange>()
    for range in ranges {
        if range.startIndex >= upper_bound {
            // the upper_bound cannot be the startIndex since the startIndex is inclusive
            break
        }
        else if range.endIndex > upper_bound {
            // the upper_bound can be the endIndex since the endIndex is exclusive
            actual_ranges.append(range.startIndex..<upper_bound)
        }
        else { actual_ranges.append(range) }
    }
    return actual_ranges
}

extension FixedWidthInteger where Self.Stride: SignedInteger {
    func doFor (f: (Self) -> ()) {
        for x in CountableRange(uncheckedBounds: (lower: 0 as Self, upper:self)) {
            f(x)
        }
    }
    
    func doFor (f: () -> ()) {
        for _ in CountableRange(uncheckedBounds: (lower: 0 as Self, upper:self)) {
            f()
        }
    }
}
