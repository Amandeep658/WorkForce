//
//  UIImageView + Custom.swift
//  Leila
//
//  Created by Soumya Jain on 01/06/18.
//  Copyright © 2018 Soumya Jain. All rights reserved.
//

import UIKit


extension UIImage {
    var renderTemplateMode: UIImage {
        return self.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
    }
    
    var renderOriginalMode: UIImage {
        return self.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    }
    
    func maskWithColor(color: UIColor) -> UIImage {

         UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
         let context = UIGraphicsGetCurrentContext()!
         color.setFill()
        
         context.translateBy(x: 0, y: self.size.height)
         context.scaleBy(x: 1.0, y: -1.0)
         let rect = CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height)
         context.draw(self.cgImage!, in: rect)
         context.setBlendMode(CGBlendMode.sourceIn)
         context.addRect(rect)
         context.drawPath(using: CGPathDrawingMode.fill)
         let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()

         return coloredImage!
    }
    
    
    var isPortrait:  Bool    { size.height > size.width }
    var isLandscape: Bool    { size.width > size.height }
    var breadth:     CGFloat { min(size.width, size.height) }
    var breadthSize: CGSize  { .init(width: breadth, height: breadth) }
    var breadthRect: CGRect  { .init(origin: .zero, size: breadthSize) }
    var circleMasked: UIImage? {
        guard let cgImage = cgImage?
            .cropping(to: .init(origin: .init(x: isLandscape ? ((size.width-size.height)/2).rounded(.down) : 0,
                                              y: isPortrait  ? ((size.height-size.width)/2).rounded(.down) : 0),
                                size: breadthSize)) else { return nil }
        let format = imageRendererFormat
        format.opaque = false
        return UIGraphicsImageRenderer(size: breadthSize, format: format).image { _ in
            UIBezierPath(ovalIn: breadthRect).addClip()
            UIImage(cgImage: cgImage, scale: 1, orientation: imageOrientation)
            .draw(in: .init(origin: .zero, size: breadthSize))
        }
    }
    
    
}

extension UIImageView {
    open func setImageView(_ image:UIImage, with color:UIColor) {
        let img = image.renderTemplateMode
        self.tintColor = color
        self.image = img
    }
    
    func setImage(image urlString:String?, placeholder image:UIImage? = nil) {
        
        if let urlStr = urlString, urlStr.count > 0 {
            if let url = URL(string: urlStr), url.canOpen {
                
            } else {
                self.image = image
            }
        } else {
            self.image = image
        }
    }
    
    
    
}
