//
//  ViewController.swift
//  GraphicsRenderer
//
//  Created by Shaps Benkau on 10/02/2016.
//  Copyright (c) 2016 Shaps Benkau. All rights reserved.
//

import UIKit
import GraphicsRenderer

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let docURL = url!.appendingPathComponent("doc.pdf")
        
        try? PDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792)).writePDF(to: docURL) { context in
            context.beginPage()
            performDrawing(context: context)
            context.beginPage()
            performDrawing(context: context)
        }
        
        print("PDF saved to: \(docURL)")
        
        let format = ImageRendererFormat.default()
        let image = ImageRenderer(size: CGSize(width: 100, height: 100), format: format).image { context in
            performDrawing(context: context)
        }
        
        imageView.image = image
    }
    
    private func performDrawing<Context: RendererContext>(context: Context) {
        let rect = context.format.bounds
        
        UIColor.white.setFill()
        context.fill(rect)
        
        UIColor.blue.setStroke()
        let frame = CGRect(x: 10, y: 10, width: 40, height: 40)
        context.stroke(frame)
        
        UIColor.red.setStroke()
        context.stroke(rect.insetBy(dx: 5, dy: 5))
    }
    
}
