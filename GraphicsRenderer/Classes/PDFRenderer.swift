//
//  PDFRenderer.swift
//  GraphicsRenderer
//
//  Created by Shaps Benkau on 02/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

/**
 *  Represents a PDF renderer format
 */
public final class PDFRendererFormat: RendererFormat {
    
    /**
     Returns a default format, configured for this device
     
     - returns: A new format
     */
    public static func `default`() -> PDFRendererFormat {
        let bounds = CGRect(x: 0, y: 0, width: 612, height: 792)
        return PDFRendererFormat(bounds: bounds, documentInfo: [:], flipped: false)
    }
    
    /// Returns the bounds for this format
    public let bounds: CGRect
    
    /// Returns the associated document info
    public var documentInfo: [String: Any]
    
    public var isFlipped: Bool
    
    /**
     Creates a new format with the specified bounds and pageInfo
     
     - parameter bounds:       The bounds for each page in the PDF
     - parameter documentInfo: The info associated with this PDF
     
     - returns: A new PDF renderer format
     */
    internal init(bounds: CGRect, documentInfo: [String: Any], flipped: Bool) {
        self.bounds = bounds
        self.documentInfo = documentInfo
        self.isFlipped = flipped
    }
    
    public init(documentInfo: [String: Any], flipped: Bool) {
        self.bounds = .zero
        self.documentInfo = documentInfo
        self.isFlipped = flipped
    }
    
}

public final class PDFRendererContext: RendererContext {
    
    public let cgContext: CGContext
    public let format: PDFRendererFormat
    public let pdfContextBounds: CGRect
    private var hasOpenPage: Bool = false
    
    internal init(format: PDFRendererFormat, cgContext: CGContext, bounds: CGRect) {
        self.format = format
        self.cgContext = cgContext
        self.pdfContextBounds = bounds
    }
    
    public func beginPage() {
        beginPage(withBounds: format.bounds, pageInfo: [:])
    }
    
    public func beginPage(withBounds bounds: CGRect, pageInfo: [String : Any]) {
        var info = pageInfo
        info[kCGPDFContextMediaBox as String] = bounds
        
        guard let pageInfo = info as? CFDictionary else { fatalError("Document info couldn't be converted to CFDictionary") }
        
        endPageIfOpen()
        cgContext.beginPDFPage(pageInfo)
        hasOpenPage = true
        
        if format.isFlipped {
            let transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: format.bounds.height)
            cgContext.concatenate(transform)
        }
    }
    
    public func setURL(_ url: URL, for rect: CGRect) {
        guard let url = url as? CFURL else { fatalError("url couldn't be converted to CFURL") }
        cgContext.setURL(url, for: rect)
    }
    
    public func addDestination(withName name: String, at point: CGPoint) {
        guard let name = name as? CFString else { fatalError("name couldn't be converted to CFString") }
        cgContext.addDestination(name, at: point)
    }
    
    public func setDestinationWithName(_ name: String, for rect: CGRect) {
        guard let name = name as? CFString else { fatalError("name couldn't be converted to CFString") }
        cgContext.setDestination(name, for: rect)
    }
    
    fileprivate func endPageIfOpen() {
        guard hasOpenPage else { return }
        cgContext.endPDFPage()
    }
}

public final class PDFRenderer: Renderer {
    
    /// The associated context type
    public typealias Context = PDFRendererContext
    
    /// Returns the format for this renderer
    public let format: PDFRendererFormat
    
    public init(bounds: CGRect, format: PDFRendererFormat? = nil) {
        guard bounds.size != .zero else { fatalError("size cannot be zero") }
        
        let info = format?.documentInfo ?? [:]
        self.format = PDFRendererFormat(bounds: bounds, documentInfo: info, flipped: format?.isFlipped ?? true)
    }
    
    public func writePDF(to url: URL, withActions actions: (PDFRendererContext) -> Void) throws {
        var rect = format.bounds
        let consumer = CGDataConsumer(url: url as CFURL)!
        let context = CGContext(consumer: consumer, mediaBox: &rect, format.documentInfo as CFDictionary?)!
        try? runDrawingActions(forContext: context, drawingActions: actions, completionActions: nil)
    }
    
    public func pdfData(actions: (PDFRendererContext) -> Void) -> Data {
        var rect = format.bounds
        let data = NSMutableData()
        let consumer = CGDataConsumer(data: data)!
        let context = CGContext(consumer: consumer, mediaBox: &rect, format.documentInfo as CFDictionary?)!
        try? runDrawingActions(forContext: context, drawingActions: actions, completionActions: nil)
        return data as Data
    }
    
    private func runDrawingActions(forContext cgContext: CGContext, drawingActions: (Context) -> Void, completionActions: ((Context) -> Void)? = nil) throws {
        let context = PDFRendererContext(format: format, cgContext: cgContext, bounds: format.bounds)
        
        #if os(OSX)
            let previousContext = NSGraphicsContext.current()
            NSGraphicsContext.setCurrent(NSGraphicsContext(cgContext: context.cgContext, flipped: format.isFlipped))
        #else
            UIGraphicsPushContext(context.cgContext)
        #endif
        
        drawingActions(context)
        completionActions?(context)
        
        context.endPageIfOpen()
        context.cgContext.closePDF()
        
        #if os(OSX)
            NSGraphicsContext.setCurrent(previousContext)
        #else
            UIGraphicsPopContext()
        #endif
    }

}

