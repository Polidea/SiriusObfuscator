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

class ImageRepresentation {
    func getImageData(_ x: AnyObject) -> Data? {
        return nil
    }
    
    func toString() -> String {
        return "ImageRepresentation"
    }
}

#if os(iOS) || os(tvOS)
    func CI2Data(_ x: CIImage, callback: (UIImage?) -> (Data?)) -> Data? {
        let size = x.extent.size
        if size.width <= 0 || size.height <= 0 { return nil }
        UIGraphicsBeginImageContext(size)
        _ = UIGraphicsGetCurrentContext()
        let rect = CGRect(origin: .zero, size: size)
        var data: Data? = nil
        let img = UIImage(ciImage: x)
        img.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        data = callback(image)
        UIGraphicsEndImageContext()
        return data
    }
    
    func JPEGRepresentation(_ x: AnyObject, _ compressionFactor: CGFloat) -> Data? {
        if let ui_image = x as? UIImage {
            if ui_image.cgImage == nil {
                if let ci_image = ui_image.ciImage {
                    return CI2Data(ci_image) { return UIImageJPEGRepresentation($0!, compressionFactor) }
                }
            } else { return UIImageJPEGRepresentation(ui_image, compressionFactor) }
        }
        else if let ci_image = x as? CIImage {
                return CI2Data(ci_image) { return UIImageJPEGRepresentation($0!, compressionFactor) }
        }
        return nil
    }
    
    func PNGRepresentation(_ x: AnyObject) -> Data? {
        if let ui_image = x as? UIImage {
            if ui_image.cgImage == nil {
                if let ci_image = ui_image.ciImage {
                    return CI2Data(ci_image) { return UIImagePNGRepresentation($0!) }
                }
            } else { return UIImagePNGRepresentation(ui_image) }
        }
        else if let ci_image = x as? CIImage {
            return CI2Data(ci_image) { return UIImagePNGRepresentation($0!) }
        }
        return nil
    }
#endif

#if os(OSX)
    func CI2NS(_ x: CIImage) -> NSImage? {
        let cirep = NSCIImageRep(ciImage: x)
        let ns = NSImage(size: cirep.size)
        ns.addRepresentation(cirep)
        return ns
    }
#endif

extension CGImage {
    var hasAlphaChannel: Bool {
        switch self.alphaInfo {
        case .none, .noneSkipFirst,.noneSkipLast: return false
        default: return true
        }
    }
}

#if os(OSX)
    extension NSImage {
        var safeTIFFRepresentation: Data? {
            get {
                if self.representations.count == 0 {
                    let newImg = NSImage(size: self.size)
                    newImg.lockFocus()
                    newImg.unlockFocus()
                    return newImg.tiffRepresentation
                }
                return self.tiffRepresentation
            }
        }
        var isEmptyImage: Bool {
            return self.size.width == 0 && self.size.height == 0
        }
        var hasAlphaChannel: Bool {
            for representation in self.representations {
                if representation.hasAlpha { return true }
            }
            return false
        }
    }
    
    extension NSBitmapImageRep {
        var hasAlphaChannel: Bool {
            if let cg = self.cgImage {
                return cg.hasAlphaChannel
            } else {
                return false
            }
        }
    }
#elseif os(iOS) || os(tvOS)
    extension UIImage {
        var isEmptyImage: Bool {
            return self.size.width == 0 && self.size.height == 0
        }
        var hasAlphaChannel: Bool {
            if let cg = self.cgImage {
                return cg.hasAlphaChannel
            } else {
                return false
            }
        }
    }
#endif

extension CIImage {
    var isEmptyImage: Bool {
        return self.extent.size.width == 0 && self.extent.size.height == 0
    }
    var hasAlphaChannel: Bool {
        return true
    }
}

class JPGImageRepresentation : ImageRepresentation {
    var compressionFactor: CGFloat
    
    init(compressionFactor: CGFloat = 0.3) {
        self.compressionFactor = compressionFactor
    }
    
    override func getImageData(_ x: AnyObject) -> Data? {
        #if os(iOS) || os(tvOS)
            return JPEGRepresentation(x, compressionFactor)
        #elseif os(OSX)
            if let ci = (x as? CIImage) {
                if let ns = CI2NS(ci) {
                    return getImageData(ns)
                }
                return nil
            }
            var opt_img_data: Data? = nil
            var opt_image_rep: NSBitmapImageRep? = nil
            var image_props = [String: AnyObject]()
            image_props.updateValue(compressionFactor as NSNumber, forKey: NSImageCompressionFactor)
            opt_img_data = (x as? NSImage)?.safeTIFFRepresentation
            if let img_data = opt_img_data {
                opt_image_rep = NSBitmapImageRep(data: img_data)
            } else {
                opt_image_rep = (x as? NSBitmapImageRep)
            }
            if let image_rep = opt_image_rep {
                return image_rep.representation(using: NSBitmapImageFileType.JPEG, properties: image_props)
            }
            return nil
        #endif
    }
    
    override func toString() -> String {
        return "JPGImageRepresentation(\(compressionFactor))"
    }
}

class PNGImageRepresentation : ImageRepresentation {
    override func getImageData(_ x: AnyObject) -> Data? {
        #if os(iOS) || os(tvOS)
            return PNGRepresentation(x)
        #elseif os(OSX)
            if let ci = (x as? CIImage) {
                if let ns = CI2NS(ci) {
                    return getImageData(ns)
                }
                return nil
            }
            var opt_img_data: Data? = nil
            var opt_image_rep: NSBitmapImageRep? = nil
            opt_img_data = (x as? NSImage)?.safeTIFFRepresentation
            if let img_data = opt_img_data {
                opt_image_rep = NSBitmapImageRep(data: img_data)
            } else {
                opt_image_rep = (x as? NSBitmapImageRep)
            }
            if let image_rep = opt_image_rep {
                return image_rep.representation(using: NSBitmapImageFileType.PNG, properties: [:])
            }
            return nil
        #endif
    }
    
    override func toString() -> String {
        return "PNGImageRepresentation"
    }
}

class SpriteKitImageRepresentation : ImageRepresentation {
    override func getImageData(_ x: AnyObject) -> Data? {
        var hasAlpha: Bool? = nil
        
        #if os(OSX)
        if let x_nsimage = x as? NSImage {
            hasAlpha = x_nsimage.hasAlphaChannel
        } else if let x_nsbitmapimagerep = x as? NSBitmapImageRep {
            hasAlpha = x_nsbitmapimagerep.hasAlphaChannel
        }
        #elseif os(iOS) || os(tvOS)
        if let x_uiimage = x as? UIImage {
            hasAlpha = x_uiimage.hasAlphaChannel
        }
        #endif
        if hasAlpha == nil {
            if let x_ciimage = x as? CIImage {
                hasAlpha = x_ciimage.hasAlphaChannel
            }
        }

        if hasAlpha ?? false {
            return PNGImageRepresentation().getImageData(x)
        } else {
            return JPGImageRepresentation().getImageData(x)
        }
    }
    
    override func toString() -> String {
        return "SpriteKitImageRepresentation"
    }
}

class LZWTIFFImageRepresentation : ImageRepresentation {
    let compressionFactor: CFloat
    
    init(compressionFactor: CFloat) {
        self.compressionFactor = compressionFactor
    }

    override func getImageData(_ x: AnyObject) -> Data? {
        #if os(OSX)
            return x.tiffRepresentation(using: .LZW, factor: compressionFactor)
        #else
            return nil
        #endif
    }
    
    override func toString() -> String {
        return "LZWTIFFImageRepresentation(\(compressionFactor))"
    }
}

func isEmptyImage(_ img: AnyObject) -> Bool {
    #if os(OSX)
        if let nsimage = img as? NSImage {
            return nsimage.isEmptyImage
        }
    #endif
    #if os(iOS) || os(tvOS)
        if let uiimage = img as? UIImage {
            return uiimage.isEmptyImage
        }
    #endif
    if let ciimage = img as? CIImage {
        return ciimage.isEmptyImage
    }
    return false
}

func isView(_ img: AnyObject) -> Bool {
    #if os(OSX)
        if img is NSView { return true }
    #endif
    #if os(iOS) || os(tvOS)
        if img is UIView { return true }
    #endif
    return false
}

#if os(OSX)
func viewAsImage(_ opt_vw: NSView?) -> AnyObject? {
    if let view = opt_vw {
        return NSViewRenderer.render(view)
    }
    return nil
}
#endif

#if os(iOS) || os(tvOS)
func viewAsImage(_ opt_vw: UIView?) -> AnyObject? {
    if let view = opt_vw {
        return UIViewRenderer.render(view)
    }
    return nil
}
#endif

func getImageData(_ img: Any, _ tag: String, _ ir: ImageRepresentation, _ allowView: Bool = true) -> QuickLookingResult {
    if let x = img as? AnyObject {
        if isEmptyImage(x) {
            return QuickLookObject.text("empty image").encode()
        }
        else if allowView && isView(x) {
            let allowViewDeeper = false // only allow one layer of view-as-image
            #if os(OSX)
                if let x_rendered = viewAsImage(x as? NSView) {
                    return getImageData(x_rendered, tag, ir, allowViewDeeper)
                }
                else {
                    return .Failure("view cannot be rendered")
                }
            #endif
    
            #if os(iOS) || os(tvOS)
                if let x_rendered = viewAsImage(x as? UIView) {
                    return getImageData(x_rendered, tag, ir, allowViewDeeper)
                }
                else {
                    return .Failure("view cannot be rendered")
                }
            #endif
        }
        else if let data = ir.getImageData(x) {
            return QuickLookingResult(QuickLookEncodedObject(tag,.Buffer(data)))
        }
        else {
            return .Failure("unrepresentable image data")
        }
    }
    else {
        return .Failure("not a valid object")
    }
}
