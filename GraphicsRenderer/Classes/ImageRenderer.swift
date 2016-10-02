//
//  ImageRenderer.swift
//  GraphicsRenderer
//
//  Created by Shaps Benkau on 02/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

/**
 *  Represents an image renderer format
 */
public struct ImageRendererFormat: RendererFormat {

    /**
     Returns a default format, configured for this device
     
     - returns: A new format
     */
    public static func `default`() -> ImageRendererFormat {
        return ImageRendererFormat(bounds: .zero)
    }
    
    /// Returns the bounds for this format
    public let bounds: CGRect
    
    /// Get/set whether or not the resulting image should be opaque
    public var opaque: Bool
    
    /// Get/set the scale of the resulting image
    public var scale: CGFloat
    
    /**
     Creates a new format with the specified bounds
     
     - parameter bounds: The bounds of this format
     - parameter opaque: Whether or not the resulting image should be opaque
     - parameter scale:  The scale of the resulting image
     
     - returns: A new format
     */
    init(bounds: CGRect, opaque: Bool = false, scale: CGFloat = UIScreen.main.scale) {
        self.bounds = bounds
        self.opaque = opaque
        self.scale = scale
    }
}

/**
 *  Represents a new renderer context
 */
public struct ImageRendererContext: RendererContext {
    
    /// The associated format
    public let format: ImageRendererFormat
    
    /// The associated CGContext
    public let cgContext: CGContext
    
    /// Returns a UIImage representing the current state of the renderer's CGContext
    public var currentImage: UIImage {
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    /**
     Creates a new renderer context
     
     - parameter format:    The format for this context
     - parameter cgContext: The associated CGContext to use for all drawing
     
     - returns: A new renderer context
     */
    internal init(format: ImageRendererFormat, cgContext: CGContext) {
        self.format = format
        self.cgContext = cgContext
    }
}

/**
 *  Represents an image renderer used for drawing into a UIImage
 */
public struct ImageRenderer: Renderer {
    
    /// The associated context type
    public typealias Context = ImageRendererContext
    
    /// Returns true
    public let allowsImageOutput: Bool = true
    
    /// Returns the format for this renderer
    public let format: ImageRendererFormat
    
    /**
     Creates a new renderer with the specified size and format
     
     - parameter size:   The size of the resulting image
     - parameter format: The format, provides additional options for this renderer
     
     - returns: A new image renderer
     */
    public init(size: CGSize, format: ImageRendererFormat? = nil) {
        self.format = format ?? ImageRendererFormat(bounds: CGRect(origin: .zero, size: size))
    }
    
    /**
     By default this method does nothing.
     */
    public static func prepare(_ context: CGContext, with rendererContext: ImageRendererContext) { }
    
    /**
     Returns a newly configured CGContext
     
     - parameter format: The format options to use for this context
     
     - returns: A new CGContext
     */
    public static func context(with format: ImageRendererFormat) -> CGContext? {
        UIGraphicsBeginImageContextWithOptions(format.bounds.size, format.opaque, format.scale)
        return UIGraphicsGetCurrentContext()
    }

    /**
     Returns a new image with the specified drawing actions applied
     
     - parameter actions: The drawing actions to apply
     
     - returns: A new image
     */
    public func image(actions: (Context) -> Void) -> UIImage {
        var image: UIImage?
        
        try? runDrawingActions(actions) { context in
            image = context.currentImage
        }
        
        return image!
    }
    
    /**
     Returns a PNG data representation of the resulting image
     
     - parameter actions: The drawing actions to apply
     
     - returns: A PNG data representation
     */
    public func pngData(actions: (Context) -> Void) -> Data {
        return data(png: true, quality: 1.0, actions: actions)
    }
    
    /**
     Returns a JPEG data representation of the resulting image
     
     - parameter actions: The drawing actions to apply
     
     - returns: A JPEG data representation
     */
    public func jpegData(withCompressionQuality compressionQuality: CGFloat, actions: (Context) -> Void) -> Data {
        return data(png: false, quality: compressionQuality, actions: actions)
    }
    
    private func data(png: Bool, quality: CGFloat, actions: (Context) -> Void) -> Data {
        var image: UIImage!
        
        try? runDrawingActions(actions) { (context) in
            image = context.currentImage
        }
        
        return png ? UIImagePNGRepresentation(image)! : UIImageJPEGRepresentation(image, quality)!
    }
    
    private func runDrawingActions(_ drawingActions: (Context) -> Void, completionActions: ((Context) -> Void)? = nil) throws {
        guard let cgContext = ImageRenderer.context(with: format) else {
            throw RendererContextError.missingContext
        }
        
        let context = Context(format: format, cgContext: cgContext)
        ImageRenderer.prepare(cgContext, with: context)
        
        drawingActions(context)
        completionActions?(context)
       
        UIGraphicsEndImageContext()
    }
}
