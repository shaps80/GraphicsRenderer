//
//  ImageRenderer.swift
//  GraphicsRenderer
//
//  Created by Shaps Benkau on 02/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

public struct ImageRendererFormat: RendererFormat {
    public static func `default`() -> ImageRendererFormat {
        return ImageRendererFormat(bounds: .zero)
    }
    
    public var bounds: CGRect
    public var opaque: Bool
    public var scale: CGFloat
    
    init(bounds: CGRect, opaque: Bool = false, scale: CGFloat = UIScreen.main.scale) {
        self.bounds = bounds
        self.opaque = opaque
        self.scale = scale
    }
}

public struct ImageRendererContext: RendererContext {
    public var format: ImageRendererFormat
    
    public var cgContext: CGContext
    public var currentImage: UIImage {
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    internal init(format: ImageRendererFormat, cgContext: CGContext) {
        self.format = format
        self.cgContext = cgContext
    }
}

public struct ImageRenderer: Renderer {
    public typealias Context = ImageRendererContext
    
    public var allowsImageOutput: Bool = true
    public var format: ImageRendererFormat
    
    public init(size: CGSize, format: ImageRendererFormat? = nil) {
        self.format = format ?? ImageRendererFormat(bounds: CGRect(origin: .zero, size: size))
    }
    
    public static func prepare(_ context: CGContext, with rendererContext: ImageRendererContext) { }
    public static func context(with format: ImageRendererFormat) -> CGContext? {
        UIGraphicsBeginImageContextWithOptions(format.bounds.size, format.opaque, format.scale)
        return UIGraphicsGetCurrentContext()
    }
    
    public func image(actions: (Context) -> Void) -> UIImage {
        var image: UIImage?
        
        try? runDrawingActions(actions) { context in
            image = context.currentImage
        }
        
        return image!
    }
    
    public func pngData(actions: (Context) -> Void) -> Data {
        return Data()
    }
    
    public func jpegData(withCompressionQuality compressionQuality: CGFloat, actions: (Context) -> Void) -> Data {
        return Data()
    }
    
    internal func runDrawingActions(_ drawingActions: (Context) -> Void, completionActions: ((Context) -> Void)? = nil) throws {
        guard let cgContext = ImageRenderer.context(with: format) else {
            throw RendererContextError.missingContext
        }
        
        let context = Context(format: format, cgContext: cgContext)
        ImageRenderer.prepare(cgContext, with: context)
        
        drawingActions(context)
        completionActions?(context)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
    }
}
