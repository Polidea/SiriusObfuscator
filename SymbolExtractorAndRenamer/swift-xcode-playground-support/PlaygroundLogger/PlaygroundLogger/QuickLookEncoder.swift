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

#if os(OSX)
import AppKit
#elseif os(iOS) || os(tvOS)
import UIKit
#endif

// there are only so many possible representation types (encoded in the Swift stdlib)
// this code takes those representations and makes each one of them into a (tag,bytes) pair
// that we can write into a logger packet
extension QuickLookObject {
    func genericUnwrap() -> Any? {
        switch self {
        case .sprite(let img):
            let mirror = Mirror(reflecting: img)
            if mirror.displayStyle == .optional && mirror.children.count == 1 {
                return mirror.children[mirror.children.startIndex].value
            }
            return img
        default:
            return nil
        }
    }
    
    func encode() -> QuickLookingResult
    {
        switch (self)
        {
        case .text(let str):
            return QuickLookingResult("STRN",(str.toBytes()))
        case .attributedString(let astr):
            if let x = astr as? AnyObject {
                let archiver = LoggerArchiver()
                archiver.archive(object: x)
                return QuickLookingResult("ASTR",archiver.getState())
            }
            else {
                return .Failure("invalid object")
            }
        case .int(let num):
            return QuickLookingResult("SINT",(("\(num)").toBytes()))
        case .uInt(let num):
            return QuickLookingResult("UINT",(("\(num)").toBytes()))
        case .float(let num):
            return QuickLookingResult("FLOT",num.toBytes())
        case .double(let num):
            return QuickLookingResult("DOBL",num.toBytes())
        case .image(let img):
#if APPLE_FRAMEWORKS_AVAILABLE
         return getImageData(img, "IMAG", PNGImageRepresentation())
#else
        return .Failure("image data not supported")
#endif
        case .view(let img):
#if APPLE_FRAMEWORKS_AVAILABLE
         return getImageData(img, "VIEW", PNGImageRepresentation())
#else
        return .Failure("image data not supported")
#endif
        case .sprite(_):
            return QuickLookingResult("STRN",("SpriteKit image data".toBytes()))
        case ._raw(let bytes, let tag):
            return QuickLookingResult(tag,.Array(bytes))
        case .color(let clr):
#if APPLE_FRAMEWORKS_AVAILABLE
            if let x = clr as? AnyObject {
                if let cgcgcolor = x.cgColor {
                    let cgcolor = LoggerCGColor(cgcgcolor)
                    if cgcolor.isValid() {
                        let archiver = LoggerArchiver()

                        if cgcolor.isPatternColor {
                            if let ql = cgcolor.patternImageQuicklook {
                                return ql
                            }
                            else {
                                return .Failure("pattern color data not available")
                            }
                        } else {
                            let cgcolorspacename = cgcolor.colorSpaceName
                            let safe_components = NSMutableArray()
                            let nc = Swift.Int(cgcolor.numComponents)
                            nc.doFor {
                                safe_components.add(cgcolor[$0] as NSNumber)
                            }
                            archiver.archive(key: "IDEColorSpaceKey", object: cgcolorspacename!)
                            archiver.archive(key: "IDEColorComponentsKey", object: safe_components)
                        }
                        
                        return QuickLookingResult("COLR",archiver.getState())
                    }
                }
            }
#endif
            return .Failure("invalid object")
        case .bezierPath(let bzp):
            if let x = bzp as? AnyObject {
                let archiver = LoggerArchiver()
                archiver.archive(object: x)
                return QuickLookingResult("BEZP",archiver.getState())
            } else {
                return .Failure("invalid object")
            }
        case .point(let x, let y):
            let archiver = LoggerArchiver()
            archiver.archive(key: "x", double: x)
            archiver.archive(key: "y",double: y)
            return QuickLookingResult("PONT",archiver.getState())
        case .size(let w, let h):
            let archiver = LoggerArchiver()
            archiver.archive(key: "w", double: w)
            archiver.archive(key: "h", double: h)
            return QuickLookingResult("SIZE",archiver.getState())
        case .rectangle(let x, let y, let w, let h):
            let archiver = LoggerArchiver()
            archiver.archive(key: "x",double: x)
            archiver.archive(key: "y",double: y)
            archiver.archive(key: "w",double: w)
            archiver.archive(key: "h",double: h)
            return QuickLookingResult("RECT",archiver.getState())
        case .range(let loc, let len):
            let archiver = LoggerArchiver()
            archiver.archive(key: "loc",int64: loc)
            archiver.archive(key: "len",int64: len)
            return QuickLookingResult("RANG",archiver.getState())
        case .bool(let value):
            if value {
                return QuickLookingResult("BOOL",([UInt8(1)]))
            } else {
                return QuickLookingResult("BOOL",([UInt8(0)]))
            }
        case .url(let url):
            return QuickLookingResult("URL",url.toBytes())
        default:
            return .Failure("unknown object type")
        }
    }
}
