//
//  RendererTypes.swift
//  GraphicsRenderer
//
//  Created by Shaps Benkau on 02/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

#if os(OSX)
    import AppKit
    public typealias Image = NSImage

    internal func screenScale() -> CGFloat {
        return NSScreen.main()!.backingScaleFactor
    }
    
    extension NSImage {
        public func pngRepresentation() -> Data? {
            return NSBitmapImageRep(data: tiffRepresentation!)?.representation(using: .PNG, properties: [:])
        }
        
        public func jpgRepresentation(quality: CGFloat) -> Data? {
            return NSBitmapImageRep(data: tiffRepresentation!)?.representation(using: .JPEG, properties: [NSImageCompressionFactor: quality])
        }
    }
#else
    import UIKit
    public typealias Image = UIImage
    
    internal func screenScale() -> CGFloat {
        return UIScreen.main.scale
    }
    
    extension UIImage {
        public func pngRepresentation() -> Data? {
            return UIImagePNGRepresentation(self)
        }
        
        public func jpgRepresentation(quality: CGFloat) -> Data? {
            return UIImageJPEGRepresentation(self, quality)
        }
    }
#endif

extension CGContext {
    
    public static var current: CGContext? {
        #if os(OSX)
            return NSGraphicsContext.current()!.cgContext
        #else
            return UIGraphicsGetCurrentContext()
        #endif
    }
    
}
