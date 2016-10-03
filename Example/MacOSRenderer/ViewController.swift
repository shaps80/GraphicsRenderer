//
//  ViewController.swift
//  MacOSRenderer
//
//  Created by Shaps Benkau on 02/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Cocoa
import GraphicsRenderer

class ViewController: NSViewController {
    
    @IBOutlet weak var imageView: NSImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = ImageRenderer(size: CGSize(width: 100, height: 100)).image { context in
            let rect = context.format.bounds
            
            NSColor.white.setFill()
            context.fill(rect)
            
            NSColor.blue.setStroke()
            let frame = CGRect(x: 10, y: 10, width: 40, height: 40)
            context.stroke(frame)
            
            var url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            url = url?.appendingPathComponent("image.png")
            try? context.currentImage.pngRepresentation()!.write(to: url!)
            
            NSColor.red.setStroke()
            context.stroke(rect.insetBy(dx: 5, dy: 5))
        }
        
        imageView.image = image
    }

}

