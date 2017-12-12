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
#if os(OSX)
import AppKit
#endif

func * (lhs : String, rhs : Int) -> String {
    if (rhs <= 0) { return "" }
    if (rhs == 1) { return lhs }
    var str = lhs
    for _ in 1..<rhs
    {
        str += lhs
    }
    return str
}

protocol PlaygroundObjectDecoder {
    func decodeObject(_ decoder: PlaygroundDecoder, _ bytes: BytesStorage, _ name: String, _ kind: PlaygroundRepresentation) -> PlaygroundDecodedObject?
}

class PlaygroundDecodedObject_Structured: PlaygroundDecodedObject {
    let typeName: String
    let summary: String
    let totalCount: UInt64
    let storedCount: UInt64
    let type: String
    var children: [PlaygroundDecodedObject]

    init (_ name: String, _ brief: String, _ long: String, _ total: UInt64, _ stored: UInt64, _ type: String) {
        self.typeName = brief
        self.summary = long
        self.totalCount = total
        self.storedCount = stored
        self.children = [PlaygroundDecodedObject]()
        self.type = type
        super.init(name)
    }

    func addChild(_ x: PlaygroundDecodedObject) {
        self.children.append(x)
    }

    var count: Int { return children.count }

    subscript(x: Int) -> PlaygroundDecodedObject { return children[x] }

    override func print<T: TextOutputStream>(_ stream: inout T, _ depth: Int) {
        let prefix = "\t"*depth
        super.print(&stream, depth)
        Swift.print("\(prefix)Typename: \(typeName)", to: &stream)
        Swift.print("\(prefix)Summary: \(summary)", to: &stream)
        Swift.print("\(prefix)Total count: \(totalCount)", to: &stream)
        Swift.print("\(prefix)Stored count: \(storedCount)", to: &stream)
        Swift.print("\(prefix)Type: \(type)", to: &stream)
        for child in children {
            child.print(&stream, depth+1)
        }
    }
}

class PlaygroundObjectDecoder_Structured: PlaygroundObjectDecoder {
    func decodeObject(_ decoder: PlaygroundDecoder, _ bytes: BytesStorage, _ name: String, _ kind: PlaygroundRepresentation) -> PlaygroundDecodedObject? {
        guard let brief = String(storage: bytes) else { return nil }
        guard let long = String(storage: bytes) else { return nil }
        guard let total = UInt64(storage: bytes) else { return nil }
        guard let stored: UInt64 = ((total > 0) ? UInt64(storage: bytes) : 0) else { return nil }
        let object = PlaygroundDecodedObject_Structured(name, brief, long, total, stored, kind.description)
        stored.doFor {
            object.addChild(decoder.decodeObject(bytes)!)
        }
        return object
    }
}

class PlaygroundDecodedObject_Gap: PlaygroundDecodedObject {
    override init(_ name: String) {
        super.init(name)
    }

    override func print<T: TextOutputStream>(_ stream: inout T, _ depth: Int) {
        let prefix = "\t"*depth
        super.print(&stream, depth)
        Swift.print("\(prefix)Type: Gap", to: &stream)
    }
}

class PlaygroundObjectDecoder_Gap: PlaygroundObjectDecoder {
    func decodeObject(_ decoder: PlaygroundDecoder, _ bytes: BytesStorage, _ name: String, _ kind: PlaygroundRepresentation) -> PlaygroundDecodedObject? {
        return PlaygroundDecodedObject_Gap(name)
    }
}

class PlaygroundDecodedObject_ScopeEntry: PlaygroundDecodedObject {
    override init(_ name: String) {
        super.init(name)
    }

    override func print<T: TextOutputStream>(_ stream: inout T, _ depth: Int) {
        let prefix = "\t"*depth
        super.print(&stream, depth)
        Swift.print("\(prefix)Type: Scope Entry", to: &stream)
    }
}

class PlaygroundObjectDecoder_ScopeEntry: PlaygroundObjectDecoder {
    func decodeObject(_ decoder: PlaygroundDecoder, _ bytes: BytesStorage, _ name: String, _ kind: PlaygroundRepresentation) -> PlaygroundDecodedObject? {
        return PlaygroundDecodedObject_ScopeEntry(name)
    }
}

class PlaygroundDecodedObject_ScopeExit: PlaygroundDecodedObject {
    override init(_ name: String) {
        super.init(name)
    }

    override func print<T: TextOutputStream>(_ stream: inout T, _ depth: Int) {
        let prefix = "\t"*depth
        super.print(&stream, depth)
        Swift.print("\(prefix)Type: Scope Exit", to: &stream)
    }
}

class PlaygroundObjectDecoder_ScopeExit: PlaygroundObjectDecoder {
    func decodeObject(_ decoder: PlaygroundDecoder, _ bytes: BytesStorage, _ name: String, _ kind: PlaygroundRepresentation) -> PlaygroundDecodedObject? {
        return PlaygroundDecodedObject_ScopeExit(name)
    }
}

class PlaygroundDecodedObject_Error: PlaygroundDecodedObject {
    let error: String

    init(_ name: String, _ error: String) {
        self.error = error
        super.init(name)
    }

    override func print<T: TextOutputStream>(_ stream: inout T, _ depth: Int) {
        let prefix = "\t"*depth
        super.print(&stream, depth)
        Swift.print("\(prefix)Type: Error", to: &stream)
        Swift.print("\(prefix)Message: \(error)", to: &stream)
    }
}

class PlaygroundObjectDecoder_Error: PlaygroundObjectDecoder {
    func decodeObject(_ decoder: PlaygroundDecoder, _ bytes: BytesStorage, _ name: String, _ kind: PlaygroundRepresentation) -> PlaygroundDecodedObject? {
        guard let message = String(storage: bytes) else { return nil }
        return PlaygroundDecodedObject_Error(name,message)
    }
}

class PlaygroundObjectDecoder_IDERepr: PlaygroundObjectDecoder {
    func decodeObject(_ decoder: PlaygroundDecoder, _ bytes: BytesStorage, _ name: String, _ kind: PlaygroundRepresentation) -> PlaygroundDecodedObject? {
        guard let preferSummary = Bool(storage: bytes) else { return nil }
        guard let brief = String(storage: bytes) else { return nil }
        guard let long = String(storage: bytes) else { return nil }
        guard let tag = String(storage: bytes) else { return nil }
        guard let size = UInt64(storage: bytes) else { return nil }
        let subset = bytes.subset(len: size, consume: true)
        return decoder.getIDEReprDecoder(tag).decodeObject(decoder, subset, name, preferSummary, brief, long, tag)
    }
}

protocol PlaygroundIDEReprDecoder {
    func decodeObject(_ decoder: PlaygroundDecoder, _ bytes: BytesStorage, _ name: String, _ psum: Bool, _ brief: String, _ long: String, _ tag: String) -> PlaygroundDecodedObject_IDERepr?
}

class PlaygroundIDEReprDecoder_String: PlaygroundIDEReprDecoder {
    class PlaygroundDecodedObject_IDERepr_String: PlaygroundDecodedObject_IDERepr {
        let data: String

        init (_ name: String, _ psum: Bool, _ brief: String, _ long: String, _ tag: String, _ data: String) {
            self.data = data
            super.init(name, psum, brief, long, tag)
        }

        override func print<T: TextOutputStream>(_ stream: inout T, _ depth: Int) {
            let prefix = "\t"*depth
            super.print(&stream, depth)
            Swift.print("\(prefix)Data: \(data)", to: &stream)
        }

        override var payload: Any? { return data }
    }
    func decodeObject(_ decoder: PlaygroundDecoder, _ bytes: BytesStorage, _ name: String, _ psum: Bool, _ brief: String, _ long: String, _ tag: String) -> PlaygroundDecodedObject_IDERepr? {
        guard let data = String(fullBytesStorage: bytes) else { return nil }
        return PlaygroundDecodedObject_IDERepr_String(name, psum ,brief, long, tag, data)
    }
}

class PlaygroundIDEReprDecoder_Int: PlaygroundIDEReprDecoder {
    class PlaygroundDecodedObject_IDERepr_Int: PlaygroundDecodedObject_IDERepr {
        let data: Int64

        init (_ name: String, _ psum: Bool, _ brief: String, _ long: String, _ tag: String, _ data: Int64) {
            self.data = data
            super.init(name, psum, brief, long, tag)
        }

        override func print<T: TextOutputStream>(_ stream: inout T, _ depth: Int) {
            let prefix = "\t"*depth
            super.print(&stream, depth)
            Swift.print("\(prefix)Data: \(data)", to: &stream)
        }

        override var payload: Any? { return data }
    }
    func decodeObject(_ decoder: PlaygroundDecoder, _ bytes: BytesStorage, _ name: String, _ psum: Bool, _ brief: String, _ long: String, _ tag: String) -> PlaygroundDecodedObject_IDERepr? {
        guard let data = String(fullBytesStorage: bytes) else { return nil }
        guard let idata = Int(data) else { return nil }
        return PlaygroundDecodedObject_IDERepr_Int(name, psum ,brief, long, tag, Int64(idata))
    }
}

class PlaygroundIDEReprDecoder_UInt: PlaygroundIDEReprDecoder {
    class PlaygroundDecodedObject_IDERepr_UInt: PlaygroundDecodedObject_IDERepr {
        let data: UInt64

        init (_ name: String, _ psum: Bool, _ brief: String, _ long: String, _ tag: String, _ data: UInt64) {
            self.data = data
            super.init(name, psum, brief, long, tag)
        }

        override func print<T: TextOutputStream>(_ stream: inout T, _ depth: Int) {
            let prefix = "\t"*depth
            super.print(&stream, depth)
            Swift.print("\(prefix)Data: \(data)", to: &stream)
        }

        override var payload: Any? { return data }
    }
    func decodeObject(_ decoder: PlaygroundDecoder, _ bytes: BytesStorage, _ name: String, _ psum: Bool, _ brief: String, _ long: String, _ tag: String) -> PlaygroundDecodedObject_IDERepr? {
        guard let data = String(fullBytesStorage: bytes) else { return nil }
        return PlaygroundDecodedObject_IDERepr_UInt(name, psum, brief, long, tag, strtoull(data, nil, 10))
    }
}

class PlaygroundIDEReprDecoder_Float: PlaygroundIDEReprDecoder {
    class PlaygroundDecodedObject_IDERepr_Float: PlaygroundDecodedObject_IDERepr {
        let data: Float

        init (_ name: String, _ psum: Bool, _ brief: String, _ long: String, _ tag: String, _ data: Float) {
            self.data = data
            super.init(name, psum, brief, long, tag)
        }

        override func print<T: TextOutputStream>(_ stream: inout T, _ depth: Int) {
            let prefix = "\t"*depth
            super.print(&stream, depth)
            Swift.print("\(prefix)Data: \(data)", to: &stream)
        }

        override var payload: Any? { return data }
    }
    func decodeObject(_ decoder: PlaygroundDecoder, _ bytes: BytesStorage, _ name: String, _ psum: Bool, _ brief: String, _ long: String, _ tag: String) -> PlaygroundDecodedObject_IDERepr? {
        guard let data = Float(storage: bytes) else { return nil }
        return PlaygroundDecodedObject_IDERepr_Float(name, psum, brief, long, tag, data)
    }
}

class PlaygroundIDEReprDecoder_Double: PlaygroundIDEReprDecoder {
    class PlaygroundDecodedObject_IDERepr_Double: PlaygroundDecodedObject_IDERepr {
        let data: Double

        init (_ name: String, _ psum: Bool, _ brief: String, _ long: String, _ tag: String, _ data: Double) {
            self.data = data
            super.init(name, psum, brief, long, tag)
        }

        override func print<T: TextOutputStream>(_ stream: inout T, _ depth: Int) {
            let prefix = "\t"*depth
            super.print(&stream, depth)
            Swift.print("\(prefix)Data: \(data)", to: &stream)
        }

        override var payload: Any? { return data }
    }
    func decodeObject(_ decoder: PlaygroundDecoder, _ bytes: BytesStorage, _ name: String, _ psum: Bool, _ brief: String, _ long: String, _ tag: String) -> PlaygroundDecodedObject_IDERepr? {
        guard let data = Double(storage: bytes) else { return nil }
        return PlaygroundDecodedObject_IDERepr_Double(name, psum, brief, long, tag, data)
    }
}

#if APPLE_FRAMEWORKS_AVAILABLE
class PlaygroundIDEReprDecoder_Point: PlaygroundIDEReprDecoder {
    class PlaygroundDecodedObject_IDERepr_Point: PlaygroundDecodedObject_IDERepr {
        let data: CGPoint

        init (_ name: String, _ psum: Bool, _ brief: String, _ long: String, _ tag: String, _ data: CGPoint) {
            self.data = data
            super.init(name, psum, brief, long, tag)
        }

        override func print<T: TextOutputStream>(_ stream: inout T, _ depth: Int) {
            let prefix = "\t"*depth
            super.print(&stream, depth)
            Swift.print("\(prefix)Data: \(data)", to: &stream)
        }

        override var payload: Any? { return data }
    }
    func decodeObject(_ decoder: PlaygroundDecoder, _ bytes: BytesStorage, _ name: String, _ psum: Bool, _ brief: String, _ long: String, _ tag: String) -> PlaygroundDecodedObject_IDERepr? {
        let decoder = LoggerUnarchiver(bytes)
        if !(decoder.has("x") && decoder.has("y")) { return nil }
        return PlaygroundDecodedObject_IDERepr_Point(name, psum, brief, long, tag, CGPoint(x: CGFloat(decoder.get(double: "x")), y: CGFloat(decoder.get(double: "y"))))
    }
}

class PlaygroundIDEReprDecoder_Size: PlaygroundIDEReprDecoder {
    class PlaygroundDecodedObject_IDERepr_Size: PlaygroundDecodedObject_IDERepr {
        let data: CGSize

        init (_ name: String, _ psum: Bool, _ brief: String, _ long: String, _ tag: String, _ data: CGSize) {
            self.data = data
            super.init(name, psum, brief, long, tag)
        }

        override func print<T: TextOutputStream>(_ stream: inout T, _ depth: Int) {
            let prefix = "\t"*depth
            super.print(&stream, depth)
            Swift.print("\(prefix)Data: \(data)", to: &stream)
        }

        override var payload: Any? { return data }
    }
    func decodeObject(_ decoder: PlaygroundDecoder, _ bytes: BytesStorage, _ name: String, _ psum: Bool, _ brief: String, _ long: String, _ tag: String) -> PlaygroundDecodedObject_IDERepr? {
        let decoder = LoggerUnarchiver(bytes)
        if !(decoder.has("w") && decoder.has("h")) { return nil }
        return PlaygroundDecodedObject_IDERepr_Size(name, psum, brief, long, tag, CGSize(width: CGFloat(decoder.get(double: "w")), height: CGFloat(decoder.get(double: "h"))))
    }
}

class PlaygroundIDEReprDecoder_Rect: PlaygroundIDEReprDecoder {
    class PlaygroundDecodedObject_IDERepr_Rect: PlaygroundDecodedObject_IDERepr {
        let data: CGRect

        init (_ name: String, _ psum: Bool, _ brief: String, _ long: String, _ tag: String, _ data: CGRect) {
            self.data = data
            super.init(name, psum, brief, long, tag)
        }

        override func print<T: TextOutputStream>(_ stream: inout T, _ depth: Int) {
            let prefix = "\t"*depth
            super.print(&stream, depth)
            Swift.print("\(prefix)Data: \(data)", to: &stream)
        }

        override var payload: Any? { return data }
    }
    func decodeObject(_ decoder: PlaygroundDecoder, _ bytes: BytesStorage, _ name: String, _ psum: Bool, _ brief: String, _ long: String, _ tag: String) -> PlaygroundDecodedObject_IDERepr? {
        let decoder = LoggerUnarchiver(bytes)
        if !(decoder.has("x") && decoder.has("y") && decoder.has("w") && decoder.has("h")) { return nil }
        return PlaygroundDecodedObject_IDERepr_Rect(name,
                                                    psum,
                                                    brief,
                                                    long,
                                                    tag,
                                                    CGRect(x: CGFloat(decoder.get(double: "x")),
                                                           y: CGFloat(decoder.get(double: "y")),
                                                           width: CGFloat(decoder.get(double:"w")),
                                                           height: CGFloat(decoder.get(double: "h"))))
    }
}
#endif

class PlaygroundIDEReprDecoder_Range: PlaygroundIDEReprDecoder {
    class PlaygroundDecodedObject_IDERepr_Range: PlaygroundDecodedObject_IDERepr {
        let data: NSRange

        init (_ name: String, _ psum: Bool, _ brief: String, _ long: String, _ tag: String, _ data: NSRange) {
            self.data = data
            super.init(name, psum, brief, long, tag)
        }

        override func print<T: TextOutputStream>(_ stream: inout T, _ depth: Int) {
            let prefix = "\t"*depth
            super.print(&stream, depth)
            Swift.print("\(prefix)Data: \(data)", to: &stream)
        }

        override var payload: Any? { return data }
    }
    func decodeObject(_ decoder: PlaygroundDecoder, _ bytes: BytesStorage, _ name: String, _ psum: Bool, _ brief: String, _ long: String, _ tag: String) -> PlaygroundDecodedObject_IDERepr? {
        let decoder = LoggerUnarchiver(bytes)
        if !(decoder.has("loc") && decoder.has("len")) { return nil }
        return PlaygroundDecodedObject_IDERepr_Range(name, psum, brief, long, tag, NSRange(location: Int(decoder.get(int64: "loc")), length: Int(decoder.get(int64: "len"))))
    }
}

class PlaygroundIDEReprDecoder_Bool: PlaygroundIDEReprDecoder {
    class PlaygroundDecodedObject_IDERepr_Bool: PlaygroundDecodedObject_IDERepr {
        let data: Bool

        init (_ name: String, _ psum: Bool, _ brief: String, _ long: String, _ tag: String, _ data: Bool) {
            self.data = data
            super.init(name, psum, brief, long, tag)
        }

        override func print<T: TextOutputStream>(_ stream: inout T, _ depth: Int) {
            let prefix = "\t"*depth
            super.print(&stream, depth)
            Swift.print("\(prefix)Data: \(data)", to: &stream)
        }

        override var payload: Any? { return data }
    }
    func decodeObject(_ decoder: PlaygroundDecoder, _ bytes: BytesStorage, _ name: String, _ psum: Bool, _ brief: String, _ long: String, _ tag: String) -> PlaygroundDecodedObject_IDERepr? {
        guard let data = Bool(storage: bytes) else { return nil }
        return PlaygroundDecodedObject_IDERepr_Bool(name, psum, brief, long, tag, data)
    }
}

class PlaygroundIDEReprDecoder_URL: PlaygroundIDEReprDecoder {
    class PlaygroundDecodedObject_IDERepr_URL: PlaygroundDecodedObject_IDERepr {
        let data: NSURL

        init (_ name: String, _ psum: Bool, _ brief: String, _ long: String, _ tag: String, _ data: NSURL) {
            self.data = data
            super.init(name, psum, brief, long, tag)
        }

        override func print<T: TextOutputStream>(_ stream: inout T, _ depth: Int) {
            let prefix = "\t"*depth
            super.print(&stream, depth)
            Swift.print("\(prefix)Data: \(data)", to: &stream)
        }

        override var payload: Any? { return data }
    }
    func decodeObject(_ decoder: PlaygroundDecoder, _ bytes: BytesStorage, _ name: String, _ psum: Bool, _ brief: String, _ long: String, _ tag: String) -> PlaygroundDecodedObject_IDERepr? {
        guard let data = String(fullBytesStorage: bytes) else { return nil }
        guard let url = NSURL(string: data) else { return nil }
        return PlaygroundDecodedObject_IDERepr_URL(name, psum ,brief, long, tag, url)
    }
}

#if os(OSX)
class PlaygroundIDEReprDecoder_Image: PlaygroundIDEReprDecoder {
    class PlaygroundDecodedObject_IDERepr_Image: PlaygroundDecodedObject_IDERepr {
        let data: NSImage
        
        init (_ name: String, _ psum: Bool, _ brief: String, _ long: String, _ tag: String, _ data: NSImage) {
            self.data = data
            super.init(name, psum, brief, long, tag)
        }
        
        override func print<T: TextOutputStream>(_ stream: inout T, _ depth: Int) {
            let prefix = "\t"*depth
            super.print(&stream, depth)
            Swift.print("\(prefix)Data: \(data)", to: &stream)
        }
        
        override var payload: Any? { return data }
    }
    func decodeObject(_ decoder: PlaygroundDecoder, _ bytes: BytesStorage, _ name: String, _ psum: Bool, _ brief: String, _ long: String, _ tag: String) -> PlaygroundDecodedObject_IDERepr? {
        let data = bytes.data
        guard let image = NSImage(data: data as Data) else { return nil }
        return PlaygroundDecodedObject_IDERepr_Image(name, psum ,brief, long, tag, image)
    }
}
#endif

class PlaygroundDecoder {
    var bytes: BytesStorage
    var obj_decoders: [PlaygroundRepresentation: PlaygroundObjectDecoder]
    var iderepr_decoders: [String: PlaygroundIDEReprDecoder]

    init (_ bytes: BytesStorage) {
        self.bytes = bytes
        self.obj_decoders = [PlaygroundRepresentation: PlaygroundObjectDecoder]()
        self.iderepr_decoders = [String: PlaygroundIDEReprDecoder]()
        self.obj_decoders[.Class] = PlaygroundObjectDecoder_Structured()
        self.obj_decoders[.Struct] = PlaygroundObjectDecoder_Structured()
        self.obj_decoders[.Tuple] = PlaygroundObjectDecoder_Structured()
        self.obj_decoders[.Enum] = PlaygroundObjectDecoder_Structured()
        self.obj_decoders[.Aggregate] = PlaygroundObjectDecoder_Structured()
        self.obj_decoders[.Container] = PlaygroundObjectDecoder_Structured()
        self.obj_decoders[.IndexContainer] = PlaygroundObjectDecoder_Structured()
        self.obj_decoders[.KeyContainer] = PlaygroundObjectDecoder_Structured()
        self.obj_decoders[.MembershipContainer] = PlaygroundObjectDecoder_Structured()
        self.obj_decoders[.Gap] = PlaygroundObjectDecoder_Gap()
        self.obj_decoders[.ScopeEntry] = PlaygroundObjectDecoder_ScopeEntry()
        self.obj_decoders[.ScopeExit] = PlaygroundObjectDecoder_ScopeExit()
        self.obj_decoders[.Error] = PlaygroundObjectDecoder_Error()

        self.obj_decoders[.IDERepr] = PlaygroundObjectDecoder_IDERepr()
        self.iderepr_decoders["STRN"] = PlaygroundIDEReprDecoder_String()
        self.iderepr_decoders["SINT"] = PlaygroundIDEReprDecoder_Int()
        self.iderepr_decoders["UINT"] = PlaygroundIDEReprDecoder_UInt()
        self.iderepr_decoders["FLOT"] = PlaygroundIDEReprDecoder_Float()
        self.iderepr_decoders["DOBL"] = PlaygroundIDEReprDecoder_Double()
#if APPLE_FRAMEWORKS_AVAILABLE
        self.iderepr_decoders["RECT"] = PlaygroundIDEReprDecoder_Rect()
        self.iderepr_decoders["PONT"] = PlaygroundIDEReprDecoder_Point()
        self.iderepr_decoders["SIZE"] = PlaygroundIDEReprDecoder_Size()
#endif
        self.iderepr_decoders["RANG"] = PlaygroundIDEReprDecoder_Range()
        self.iderepr_decoders["BOOL"] = PlaygroundIDEReprDecoder_Bool()
        self.iderepr_decoders["URL"]  = PlaygroundIDEReprDecoder_URL()
        #if os(OSX)
        self.iderepr_decoders["IMAG"]  = PlaygroundIDEReprDecoder_Image()
        #endif
    }

    func getIDEReprDecoder(_ tag: String) -> PlaygroundIDEReprDecoder {
        if let decoder = iderepr_decoders[tag] {
            return decoder
        }
        class DefaultIDEReprDecoder: PlaygroundIDEReprDecoder {
            class DefaultIDEReprDecoder_Object: PlaygroundDecodedObject_IDERepr {
                let data: String

                init (_ name: String, _ psum: Bool, _ brief: String, _ long: String, _ tag: String, _ data: String) {
                    self.data = data
                    super.init(name, psum, brief, long, tag)
                }

            }
            func decodeObject(_ decoder: PlaygroundDecoder, _ bytes: BytesStorage, _ name: String, _ psum: Bool, _ brief: String, _ long: String, _ tag: String) -> PlaygroundDecodedObject_IDERepr? {
                let len_to_dump = 128
                var buffer = ""
                for i in 0..<bytes.count {
                    if i > len_to_dump {
                        buffer += "..."
                        break
                    } else {
                        buffer = buffer + "\(bytes.get()) "
                    }
                }
                return DefaultIDEReprDecoder_Object(name, psum, brief, long, tag, buffer)
            }
        }
        return DefaultIDEReprDecoder()
    }

    func decodeObject(_ bytes: BytesStorage) -> PlaygroundDecodedObject? {
        guard let name = String(storage: bytes) else { return nil }
        let kind = PlaygroundRepresentation(byte: bytes.get())
        return obj_decoders[kind]?.decodeObject(self, bytes, name, kind)
    }

    func decode () -> PlaygroundDecodedLogEntry? {
        guard let version = UInt64(storage: bytes) else { return nil }
        guard let startline = UInt64(eightBytesStorage: bytes) else { return nil }
        guard let startcol = UInt64(eightBytesStorage: bytes) else { return nil }
        guard let endline = UInt64(eightBytesStorage: bytes) else { return nil }
        guard let endcol = UInt64(eightBytesStorage: bytes) else { return nil }
        guard let header_count = UInt64(storage: bytes) else { return nil }
        var header = [String: String]()
        for _ in 0..<header_count {
            guard let key = String(storage: bytes) else { return nil }
            guard let value = String(storage: bytes) else { return nil }
            header[key] = value
        }
        guard let object = decodeObject(self.bytes) else { return nil }
        return PlaygroundDecodedLogEntry(version: version,
                                         startLine: startline,
                                         startColumn: startcol,
                                         endLine: endline,
                                         endColumn: endcol,
                                         header: header,
                                         object: object)
    }
}

class PlaygroundDecodedObject {
    let name: String

    init(_ name: String) {
        self.name = name
    }

    func print<T: TextOutputStream>(_ stream: inout T, _ depth: Int) {
        let prefix = "\t"*depth
        Swift.print("\(prefix)Name: \(name)", to: &stream)
    }
}

class PlaygroundDecodedObject_IDERepr: PlaygroundDecodedObject {
    let shouldPreferSummary: Bool
    let typeName: String
    let summary: String
    let tag: String

    init (_ name: String, _ psum: Bool, _ brief: String, _ long: String, _ tag: String) {
        self.shouldPreferSummary = psum
        self.typeName = brief
        self.summary = long
        self.tag = tag
        super.init(name)
    }

    override func print<T: TextOutputStream>(_ stream: inout T, _ depth: Int) {
        let prefix = "\t"*depth
        super.print(&stream, depth)
        Swift.print("\(prefix)Typename: \(typeName)", to: &stream)
        Swift.print("\(prefix)Summary: \(summary)", to: &stream)
        Swift.print("\(prefix)Tag: \(tag)", to: &stream)
    }

    var payload: Any? { return nil }
}
