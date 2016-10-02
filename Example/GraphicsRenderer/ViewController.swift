//
//  ViewController.swift
//  GraphicsRenderer
//
//  Created by Shaps Benkau on 10/02/2016.
//  Copyright (c) 2016 Shaps Benkau. All rights reserved.
//

import UIKit
import GraphicsRenderer


class DrawableView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        
    }
    
}


class ViewController: UIViewController {
    @IBOutlet var drawableView: DrawableView!
}

