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
import Cocoa
    
final class NSViewRenderer {
    static var views = NSMutableSet()

    static func render(_ _v: NSView) -> AnyObject? {
        var result: AnyObject? = nil
        switch NSViewRenderer.views.member(_v) {
        case nil:
            NSViewRenderer.views.add(_v)
            
            let bounds = _v.bounds
            if let b = _v.bitmapImageRepForCachingDisplay(in: bounds) {
                _v.cacheDisplay(in: bounds, to: b)
                result = b
            }
            
            NSViewRenderer.views.remove(_v)
        default: ()
        }
        
        return result
    }
}
#endif

#if os(iOS) || os(tvOS)
import UIKit

// FIXME: rdar://22317321
func getGraphicsContext() -> CGContext? {
    return UIGraphicsGetCurrentContext()
}
    
final class UIViewRenderer  {
    static var _views = NSMutableSet()

    static func render(_ _v: UIView) -> AnyObject? {
        var result: AnyObject? = nil
        
        switch UIViewRenderer._views.member(_v) {
        case nil:
            UIViewRenderer._views.add(_v)
            
            let bounds = _v.bounds
            // in case of an empty rectangle abort the logging
            if (bounds.size.width == 0) || (bounds.size.height == 0) {
                return nil
            }
            
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
            
            if let ctx = getGraphicsContext() {
                UIColor(white:1.0, alpha:0.0).set()
                ctx.fill(bounds)
                _v.layer.render(in: ctx)
                
                let image = UIGraphicsGetImageFromCurrentImageContext()
                
                UIGraphicsEndImageContext()
                
                result = image
            }
            
            UIViewRenderer._views.remove(_v)
            
        default: ()
        }
        
        return result
    }
}
#endif
