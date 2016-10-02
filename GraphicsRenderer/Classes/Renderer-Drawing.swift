//
//  Renderer-Drawing.swift
//  GraphicsRenderer
//
//  Created by Shaps Benkau on 02/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

extension RendererContext {
    public func fill(_ rect: CGRect) {
        fill(rect, blendMode: .normal)
    }
    
    public func fill(_ rect: CGRect, blendMode: CGBlendMode) {
        cgContext.saveGState()
        cgContext.setBlendMode(blendMode)
        cgContext.fill(rect)
        cgContext.restoreGState()
    }
    
    public func stroke(_ rect: CGRect) {
        stroke(rect, blendMode: .normal)
    }
    
    public func stroke(_ rect: CGRect, blendMode: CGBlendMode) {
        cgContext.saveGState()
        cgContext.setBlendMode(blendMode)
        cgContext.stroke(rect)
        cgContext.restoreGState()
    }
    
    public func clip(to rect: CGRect) {
        cgContext.saveGState()
        cgContext.clip(to: rect)
        cgContext.restoreGState()
    }
}
