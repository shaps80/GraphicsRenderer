//
//  Renderer.swift
//  GraphicsRenderer
//
//  Created by Shaps Benkau on 02/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

/**
 Represents a Renderer error
 
 - missingContext:     The context could not be found or created
 */
public enum RendererContextError: Error {
    case missingContext
}

/**
 *  Defines a renderer format
 */
public protocol RendererFormat {
    
    /**
     Returns a default instance, configured for the current device
     
     - returns: A new renderer format
     */
    static func `default`() -> Self
    
    /// Returns the drawable bounds
    var bounds: CGRect { get }
    
}


/**
 *  Represents a drawable -- used to add drawing support to CGContext, RendererContext and UIGraphicsImageRendererContext
 */
public protocol RendererDrawable {
    
    var cgContext: CGContext { get }
    func fill(_ rect: CGRect)
    func fill(_ rect: CGRect, blendMode: CGBlendMode)
    func stroke(_ rect: CGRect)
    func stroke(_ rect: CGRect, blendMode: CGBlendMode)
    func clip(to rect: CGRect)
}


/**
 *  Represents a renderer context, which provides additional drawing methods as well as access to the underlying CGContext
 */
public protocol RendererContext: RendererDrawable {
    associatedtype Format: RendererFormat
    var format: Format { get }
}

extension CGContext: RendererDrawable {
    public var cgContext: CGContext {
        return self
    }
}

#if os(iOS) || os(tvOS)
@available(iOS 10.0, *)
extension UIGraphicsImageRendererContext: RendererDrawable { }
#endif


/**
 *  Represents a renderer
 */
public protocol Renderer {
    
    /// The associated context type this renderer will use
    associatedtype Context: RendererContext
    
    /// Returns the format associated with this renderer
    var format: Context.Format { get }
    
    /// Returns true if this renderer may be used to generate CGImageRefs
    var allowsImageOutput: Bool { get }
    
    /**
     Returns a new CGContext to be used for this renderer
     
     - parameter format: The format used to configure this context
     
     - returns: The resulting CGContext
     */
    static func context(with format: Context.Format) -> CGContext?
    
    /**
     Provides an opportunity to apply any additional configuration options
     
     - parameter context:         The associated CGContext
     - parameter rendererContext: The associated RendererContext
     */
    static func prepare(_ context: CGContext, with rendererContext: Context)
}

extension Renderer {
    
    /// Default implementation returns false
    public var allowsImageOutput: Bool {
        return false
    }
    
    /**
     Default implementation returns false
     */
    public static func context(with format: RendererFormat) -> CGContext? {
        return nil
    }
    
}
