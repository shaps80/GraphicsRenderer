//
//  PDFRenderer.swift
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
 *  Represents a PDF renderer format
 */
public struct PDFRendererFormat: RendererFormat {
    
    /**
     Returns a default format, configured for this device
     
     - returns: A new format
     */
    public static func `default`() -> PDFRendererFormat {
        return PDFRendererFormat(bounds: .zero, documentInfo: [:])
    }
    
    /// Returns the bounds for this format
    public let bounds: CGRect
    
    /// Returns the associated document info
    public let documentInfo: [String: Any]
    
    /**
     Creates a new format with the specified bounds and pageInfo
     
     - parameter bounds:       The bounds for each page in the PDF
     - parameter documentInfo: The info associated with this PDF
     
     - returns: A new PDF renderer format
     */
    internal init(bounds: CGRect, documentInfo: [String: Any]) {
        self.bounds = bounds
        self.documentInfo = documentInfo
    }
    
}
