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

class PlaygroundObjectWriter : PlaygroundWriter {
    let max_depth: UInt64
    let cap_aggregates: NestedDataCappingPolicy
    let cap_containers: NestedDataCappingPolicy

    func encode_gap() {
        stream.write(UInt8(0)).write(PlaygroundRepresentation.Gap)
    }

    func encode(quickLook: QuickLookObject, mirror: LoggerMirror) {
        let ql_result = quickLook.encode()
        switch ql_result {
        case .Success(let ql_encoded):
            Woodchuck.chuck {
                return Woodchuck.LogEntry("quicklook success - object: \(ql_encoded)")
            }
            stream.write(PlaygroundRepresentation.IDERepr)
            let (type_name, summary) = mirror.getSummaries()
            let prefer_summary = quickLook.shouldPreferSummary(mirror: mirror)
            stream.write(prefer_summary)
            stream.write(type_name).write(summary)
            Woodchuck.chuck {
                return Woodchuck.LogEntry("prefer_summary = \(prefer_summary), type_name = \(type_name), summary = \(summary)")
            }
            stream.write(ql_encoded.repr_type)
            let size = ql_encoded.repr_data.count
            stream.write(size)
            switch (ql_encoded.repr_data)
            {
            case .Array(let x): stream.write(x)
            case .Buffer(let x): stream.write(x)
            }
        case .Failure(let opt_message):
            Woodchuck.chuck {
                return Woodchuck.LogEntry("quicklook failure")
            }
            stream.write(PlaygroundRepresentation.Error)
            if let msg = opt_message {
                Woodchuck.chuck {
                    return Woodchuck.LogEntry("message: \(msg)")
                }
                stream.write(msg)
            } else {
                stream.write(UInt8(0))
            }
        }
    }

    func encode(structure: LoggerMirror, depth: UInt64, capping_policy: NestedDataCappingPolicy) {
        let mirror_count : UInt64 = UInt64(structure.count)
        switch (capping_policy)
        {
        case .All:
            encode(structure: structure, depth: depth, ranges: 0..<mirror_count)
        case .Head(let count):
            encode(structure: structure, depth: depth, ranges: 0..<count)
        case .HeadTail(let count, let percentage):
            if UInt64(structure.count) <= count {
                encode(structure: structure, depth: depth, ranges: 0..<mirror_count)
            } else {
                let head_count = (count * UInt64(percentage) / 100)
                let tail_count = count - head_count
                let head_range = 0..<head_count
                let tail_range = (mirror_count-tail_count)..<mirror_count
                encode(structure: structure, depth: depth, ranges: head_range, tail_range)
            }
        case .None:
            encode(structure: structure, depth: depth, ranges: 0..<0)
        }
    }

    func encode(structure: LoggerMirror, depth: UInt64) {
        switch (structure.displayStyle) {
        case .`class`, .`struct`, .tuple, .`enum`: encode(structure: structure, depth: depth, capping_policy: cap_aggregates)
        default: encode(structure: structure, depth: depth, capping_policy: cap_containers)
        }
    }
    
    // this assumes there will never be an out-of-bounds range - callers beware
    func encode(children: LoggerMirror, depth: UInt64, range: ChildrenRange) {
        func encodeChild(_ child_name: String, _ child_object: LoggerMirror, _ depth: UInt64) {
            stream.write(child_name)
            encode(object: child_object, depth: depth)
        }
        for index in range {
            let child_object = children[Int(index)]
            let child_name = child_object.label ?? "\(index)"
            
            encodeChild(child_name, child_object, depth)
        }
    }

    func encode(structure: LoggerMirror, depth : UInt64, ranges : ChildrenRange...) {
        let actual_ranges = boundCheckRanges(generateNonOverlappingUnion(ranges),UInt64(structure.count))
        let nested_depth = depth + structure.displayStyle.getConsumedDepthLevels()
        let disposition = PlaygroundRepresentation(structure.displayStyle)
        Woodchuck.chuck {
            return Woodchuck.LogEntry("ranges to log: \(actual_ranges), depth = \(depth), nested_depth = \(nested_depth), disposition = \(disposition)")
        }
        stream.write(disposition)
        let count = UInt64(structure.count)
        let (type_name,summary) = structure.getSummaries()
        Woodchuck.chuck {
            return Woodchuck.LogEntry("type_name = \(type_name), summary = \(summary)")
        }
        var real_count : UInt64 = 0
        actual_ranges.forEach { real_count += UInt64($0.count) }
        stream.write(type_name).write(summary).write(count)
        if count == 0 { return } // nothing to log - don't write real_count since it will also be zero, eject
        if (max_depth == nested_depth) {
            // this is the maximum depth - just emit a gap here
            stream.write(UInt8(1))
            encode_gap()
            return
        }
        let encode_gaps = (real_count < count)
        if (encode_gaps) {
            var num_gaps : UInt64 = 0
            actual_ranges.forEach { if $0.endIndex < count { num_gaps += 1 } }
            real_count += num_gaps
        }
        stream.write(real_count)
        for range in actual_ranges {
            // in practice, we always start logging at 0, so we don't need a "start range"
            encode(children: structure, depth: nested_depth, range: range)
            // encode a gap after each range - unless the range goes all the way to the end
            if (encode_gaps && range.endIndex < count) {
                encode_gap()
            }
        }
    }

    func encode(object: LoggerMirror, depth: UInt64) {
        if (depth == max_depth) {
            return
        }
        if let ql_object = object.quickLookObject {
            Woodchuck.chuck {
                return Woodchuck.LogEntry("object being logged has a quicklook")
            }
            encode(quickLook: ql_object, mirror: object)
        }
        else {
            Woodchuck.chuck {
                return Woodchuck.LogEntry("object being logged has a structure")
            }
            encode(structure: object, depth: depth)
        }
    }

    func encodeObject<T>(_ object : T, _ name : String, _ range: SourceRange) -> Int {
        Woodchuck.chuck {
            return Woodchuck.LogEntry("object being logged has name = \(name) and type = \(type(of: object))")
        }

        let initial_size = stream.size

        encode(header: range)
        stream.write(name)

        let mirror = LoggerMirror.reflect(object).unwrapOptionality()
        encode (object: mirror, depth: 0)

        Woodchuck.chuck {
            return Woodchuck.LogEntry("logging done - extra \(self.stream.size - initial_size) bytes written")
        }
        
        return stream.size - initial_size
    }

    init(_ max_depth : UInt64, _ cap_aggregates : NestedDataCappingPolicy, _ cap_containers : NestedDataCappingPolicy) {
        self.max_depth = max_depth+1
        self.cap_aggregates = cap_aggregates
        self.cap_containers = cap_containers
        super.init()
    }
}
