//
//  PDFRenderer.swift
//  GraphicsRenderer
//
//  Created by Shaps Benkau on 02/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

public struct PDFRendererFormat: RendererFormat {
    public static func `default`() -> PDFRendererFormat {
        return PDFRendererFormat(bounds: .zero, pageInfo: [:])
    }
    
    public var bounds: CGRect
    public var documentInfo: [String: Any]
    
    internal init(bounds: CGRect, pageInfo: [String: Any]) {
        self.bounds = bounds
        documentInfo = [:]
    }
}

//public var currentImage: UIImage {
//    return UIGraphicsGetImageFromCurrentImageContext()!
//}

