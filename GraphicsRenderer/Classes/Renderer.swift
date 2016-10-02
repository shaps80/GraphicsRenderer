//
//  Renderer.swift
//  GraphicsRenderer
//
//  Created by Shaps Benkau on 02/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

public enum RendererContextError: Error {
    case missingContext
    case mainThreadRequired
}

public protocol RendererFormat {
    static func `default`() -> Self
    var bounds: CGRect { get }
}

public protocol RendererContext {
    associatedtype Format: RendererFormat
    
    var cgContext: CGContext { get }
    var format: Format { get }
    
    func fill(_ rect: CGRect)
    func fill(_ rect: CGRect, blendMode: CGBlendMode)
    func stroke(_ rect: CGRect)
    func stroke(_ rect: CGRect, blendMode: CGBlendMode)
    func clip(to rect: CGRect)
}

public protocol Renderer {
    associatedtype Context: RendererContext
    
    var format: Context.Format { get }
    var allowsImageOutput: Bool { get }
    
    static func context(with format: Context.Format) -> CGContext?
    static func prepare(_ context: CGContext, with rendererContext: Context)
}

extension Renderer {
    
    public var allowsImageOutput: Bool {
        return false
    }
    
    public static func context(with format: ViewRendererFormat) -> CGContext? {
        return nil
    }
    
}
