//
//  ScreenRenderer.swift
//  GraphicsRenderer
//
//  Created by Shaps Benkau on 02/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

public struct ScreenRendererFormat: RendererFormat {
    public static func `default`() -> ScreenRendererFormat {
        return ScreenRendererFormat(bounds: .zero)
    }
    
    public var bounds: CGRect
    public var scale: CGFloat = UIScreen.main.scale
    
    internal init(bounds: CGRect) {
        self.bounds = bounds
    }
}

/// Internal implementation for calling inside of drawRect:
internal struct ScreenRendererContext: RendererContext {
    internal let format: ScreenRendererFormat
    internal let cgContext: CGContext
    
    internal init(format: ScreenRendererFormat) {
        self.cgContext = UIGraphicsGetCurrentContext()!
        self.format = format
    }
}
