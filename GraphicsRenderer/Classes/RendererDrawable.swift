//
//  Renderer-Drawing.swift
//  GraphicsRenderer
//
//  Created by Shaps Benkau on 02/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

extension RendererDrawable {
    
    /// <#Description#>
    ///
    /// - Parameter rect: <#rect description#>
    public func fill(_ rect: CGRect) {
        fill(rect, blendMode: .normal)
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - rect: <#rect description#>
    ///   - blendMode: <#blendMode description#>
    public func fill(_ rect: CGRect, blendMode: CGBlendMode) {
        cgContext.saveGState()
        cgContext.setBlendMode(blendMode)
        cgContext.fill(rect)
        cgContext.restoreGState()
    }
    
    /// <#Description#>
    ///
    /// - Parameter rect: <#rect description#>
    public func stroke(_ rect: CGRect) {
        stroke(rect, blendMode: .normal)
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - rect: <#rect description#>
    ///   - blendMode: <#blendMode description#>
    public func stroke(_ rect: CGRect, blendMode: CGBlendMode) {
        cgContext.saveGState()
        cgContext.setBlendMode(blendMode)
        cgContext.stroke(rect.insetBy(dx: 0.5, dy: 0.5))
        cgContext.restoreGState()
    }
    
    /// <#Description#>
    ///
    /// - Parameter rect: <#rect description#>
    public func clip(to rect: CGRect) {
        cgContext.saveGState()
        cgContext.clip(to: rect)
        cgContext.restoreGState()
    }
}
