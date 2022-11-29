//
//  UIImageView + Custom.swift
//  Leila
//
//  Created by Soumya Jain on 01/06/18.
//  Copyright © 2018 Soumya Jain. All rights reserved.
//

import UIKit
import Kingfisher

public enum ImageViewerTheme {
    case light
    case dark
    case blur
    
    var color: UIColor {
        switch self {
        case .light:
            return .white
        case .dark:
            return .black
        case .blur:
            return .clear // UIColor.black.withAlphaComponent(0.8)
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .light:
            return .black
        case .dark:
            return .white
        case .blur:
            return .clear //UIColor.black.withAlphaComponent(0.8)
        }
    }
    
    var closeButtonForgourndColor: UIColor {
        switch self {
        case .light:
            return .black
        case .dark:
            return .white
        case .blur:
            return .white //UIColor.black.withAlphaComponent(0.8)
        }
    }
}

public enum ImageItem {
    case image(UIImage?)
    case url(URL, placeholder: UIImage?)
}

public enum ImageViewerOption {
    case theme(ImageViewerTheme)
    case closeIcon(UIImage)
    case rightNavItemTitle(String, onTap: ((Int) -> Void)?)
    case rightNavItemIcon(UIImage, onTap: ((Int) -> Void)?)
}

public protocol ImageDataSource: class {
    func numberOfImages() -> Int
    func imageItem(at index:Int) -> ImageItem
}


class SimpleImageDatasource: ImageDataSource {
    
    private(set) var imageItems:[ImageItem]
    
    init(imageItems: [ImageItem]) {
        self.imageItems = imageItems
    }
    
    func numberOfImages() -> Int {
        return imageItems.count
    }
    
    func imageItem(at index: Int) -> ImageItem {
        return imageItems[index]
    }
}

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
    public func setupImageViewer(urls: [URL], initialIndex:Int = 0, options:[ImageViewerOption] = [], placeholder: UIImage? = nil, from:UIViewController? = nil) {
        let datasource = SimpleImageDatasource(
            imageItems: urls.compactMap {
                ImageItem.url($0, placeholder: placeholder)
        })
//        setup(datasource: datasource, initialIndex: initialIndex, options: options, from: from)
    }
}
extension UIImageView {
    
    public func setImageView(urls urlStrings: [String], placeholder image: UIImage? = nil, item: Int = 0, controller: UIViewController? = nil) {
        print("urls count is *******  \(urlStrings)")
        guard urlStrings.filter({$0.count > 0}).count > 0 else { return }
        
        let urls = urlStrings.map { str -> URL in
            let val = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            return URL(string: val)!
        }
        guard urls.count > 0 else { return }
        let types: [ImageViewerOption] = [.theme(.blur)]
        self.setupImageViewer(urls: urls, initialIndex: item, options: types, from: controller)
        
        //        let url = URL(string: urlStrings[item].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        //        if isSkeleton {
        //            self.image = UIImage.gifImageWithName(name: "skeleton-loading")
        //        } else {
        //            self.setProgressView()
        //        }
        
//        self.setImage(image: urlStrings.first, placeholder: image)
        self.setImage(image: urlStrings[item], placeholder: image)
    }
    
}
