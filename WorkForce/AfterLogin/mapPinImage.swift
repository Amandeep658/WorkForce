//
//  mapPinImage.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 20/07/22.
//

import Foundation
import UIKit

class MappinImage: NSObject{
    
    
    class func drawImageWithProfilePic(pp: UIImage, image: UIImage) -> UIImage {

//        let imgView = UIImageView(image: image)
        let imgView = UIImageView(image: image, highlightedImage: UIImage(named: "placeholder"))
        let picImgView = UIImageView(image: pp)
        picImgView.frame = CGRect(x: 2, y: 2, width: 26, height: 26)

        imgView.addSubview(picImgView)
        picImgView.center.x = imgView.center.x
        picImgView.center.y = imgView.center.y - 7
        picImgView.layer.cornerRadius = picImgView.frame.width/2
        picImgView.clipsToBounds = true
        imgView.setNeedsLayout()
        picImgView.setNeedsLayout()

        let newImage = imageWithView(view: imgView)
        return newImage
    }

 class func imageWithView(view: UIView) -> UIImage {
        var image: UIImage?
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return image ?? UIImage()
    }
}
