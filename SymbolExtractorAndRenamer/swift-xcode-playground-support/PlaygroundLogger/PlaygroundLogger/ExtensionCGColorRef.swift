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
import CoreGraphics
import ImageIO
#if os(OSX)
import AppKit
#endif
#if os(iOS) || os(tvOS)
import UIKit
#endif

// this API is weirdly unavailable for some reason, but I really need to
// use it in order to send over the name of the color space
// for decoding, so what I do is I force it to show up
@_silgen_name("CGColorSpaceCopyName")
func CGColorSpaceCopyName(_ x: CGColorSpace) -> NSString?

// FIXME: extending CGColor makes the compiler unhappy
// so just wrap the things we need in a new class
class LoggerCGColor {
    let color: CGColor
    let space: CGColorSpace
    
    var name: NSString? = nil
    var count: Int? = nil
    var components: ([CGFloat])? = nil
    var isPattern: Bool? = nil
    
    init(_ c: CGColor) {
        self.color = c
        self.space = self.color.colorSpace!
    }
    
    func isValid() -> Bool {
        if (isPatternColor) {
            return color.pattern != nil
        } else {
            let x = self[0] // force the components to be fetched
            let c1 = (colorSpaceName != nil)
            let c2 = (numComponents != nil)
            let c3 = (numComponents > 0)
            let c4 = (components != nil)
            let c5 = (x != nil)
            return c1 && c2 && c3 && c4 && c5
        }
        
    }
    
    var isPatternColor: Bool {
        if isPattern == nil {
            isPattern = color.colorSpace!.model == CGColorSpaceModel.pattern
        }
        return isPattern!
    }
    
    var patternImageQuicklook: QuickLookingResult? {
        if !isPatternColor { return nil }
        
        let patternRect = CGRect(x: 0, y: 0, width: 48, height: 48)

        guard let patternContext = CGContext(data: nil, width: Int(patternRect.size.width), height: Int(patternRect.size.height), bitsPerComponent: 8, bytesPerRow: Int(patternRect.size.width) * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue, releaseCallback: nil, releaseInfo: nil) else {
            return nil
        }
        
        patternContext.setFillColor(color)
        patternContext.fillEllipse(in: patternRect)
        guard let patternImage: CGImage = patternContext.makeImage() else {
            return nil
        }

        #if os(OSX)
            return getImageData(NSImage(cgImage: patternImage, size: patternRect.size), "IMAG", PNGImageRepresentation())
        #endif
        #if os(iOS) || os(tvOS)
            return getImageData(UIImage(cgImage: patternImage), "IMAG", PNGImageRepresentation())
        #endif
    }
    
    var colorSpaceName : NSString! {
        if name == nil {
            name = CGColorSpaceCopyName(self.space)
        }
        return name
    }
    
    var numComponents : Int! {
        if count == nil {
            count = Int(self.color.numberOfComponents)
        }
        return count
    }
    
    subscript(i: Int) -> CGFloat! {
        if numComponents == nil {
            return nil
        }
        if components == nil {
            let nc = Int(numComponents)
            let unsafes = self.color.components!

            var tmp_comps = [CGFloat](repeating:0, count: nc)
            self.components = Array(repeating:0, count: nc)
            nc.doFor {
              tmp_comps[$0] = unsafes[$0]
            }
            self.components = tmp_comps
        }
        if i>=0 && components != nil && i < components!.count {
            return components![i]
        }
        return nil
    }
}
