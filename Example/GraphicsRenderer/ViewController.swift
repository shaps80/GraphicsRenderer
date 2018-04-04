/*
  Copyright © 03/10/2016 Snippex Ltd

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
 */

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
    
    private func performDrawing<Context>(context: Context) where Context: RendererContext, Context.ContextType: CGContext {
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
