//
//  ImageExtension.swift
//  WorkForce
//
//  Created by apple on 14/10/22.
//

//import Foundation
import UIKit

extension UIImageView {
    
    // Data holder tap recognizer
    class TapWithDataRecognizer: UITapGestureRecognizer {
        weak var from: UIViewController?
        var imageDatasource: ImageDataSource?
        var initialIndex: Int = 0
        var options: [ImageViewerOption] = []
    }
    
    var tapRecognizer: TapWithDataRecognizer? {
        get {
            var _tapRecognizer: TapWithDataRecognizer?
            gestureRecognizers?.forEach {
                if let _tr = $0 as? TapWithDataRecognizer {
                    // if found, just use existing
                    _tapRecognizer = _tr
                }
            }
            return _tapRecognizer
        }
    }
    
    private var vc: UIViewController? {
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController
            else { return nil }
        return rootVC.presentedViewController != nil ? rootVC.presentedViewController : rootVC
    }
    
    public func setupImageViewer(options:[ImageViewerOption] = [], from: UIViewController? = nil) {
        setup(datasource: SimpleImageDatasource(imageItems: [.image(image)]), options: options, from: from)
    }
    
    public func setupImageViewer(url: URL, initialIndex:Int = 0, placeholder: UIImage? = nil, options:[ImageViewerOption] = [], from:UIViewController? = nil) {
        
        let datasource = SimpleImageDatasource(
            imageItems: [url].compactMap {
                ImageItem.url($0, placeholder: placeholder)
        })
        setup(datasource: datasource, initialIndex: initialIndex, options: options, from: from)
    }
    
    
    public func setupImageViewer(images:[UIImage], initialIndex: Int = 0,
        options:[ImageViewerOption] = [], from:UIViewController? = nil) {
        let datasource = SimpleImageDatasource(
            imageItems: images.compactMap {
                ImageItem.image($0)
        })
        setup(
            datasource: datasource,
            initialIndex: initialIndex,
            options: options,
            from: from)
        self.image = images[initialIndex]
    }
   
    
    public func setupImageViewer(
        datasource: ImageDataSource,
        initialIndex:Int = 0,
        options: [ImageViewerOption] = [],
        from:UIViewController? = nil) {
        
        setup(
            datasource: datasource,
            initialIndex: initialIndex,
            options: options,
            from: from)
    }
    
    private func setup(
        datasource: ImageDataSource?,
        initialIndex:Int = 0,
        options: [ImageViewerOption] = [],
        from: UIViewController? = nil) {
        
        var _tapRecognizer: TapWithDataRecognizer?
        gestureRecognizers?.forEach {
            if let _tr = $0 as? TapWithDataRecognizer {
                // if found, just use existing
                _tapRecognizer = _tr
            }
        }
        
        isUserInteractionEnabled = true
        contentMode = .scaleAspectFill
        clipsToBounds = true
        
        if _tapRecognizer == nil {
            _tapRecognizer = TapWithDataRecognizer(
                target: self, action: #selector(showImageViewer(_:)))
            _tapRecognizer!.numberOfTouchesRequired = 1
            _tapRecognizer!.numberOfTapsRequired = 1
        }
        // Pass the Data
        _tapRecognizer!.imageDatasource = datasource
        _tapRecognizer!.initialIndex = initialIndex
        _tapRecognizer!.options = options
        _tapRecognizer!.from = from
        addGestureRecognizer(_tapRecognizer!)
    }
    
    @objc func showImageViewer(_ sender: TapWithDataRecognizer) {
        guard let sourceView = sender.view as? UIImageView else { return }
//        let imageCarousel = ImageCarouselViewController.init(
//            sourceView: sourceView,
//            imageDataSource: sender.imageDatasource,
//            options: sender.options,
//            initialIndex: sender.initialIndex)
        var presentFromVC = sender.from ?? vc
        if presentFromVC == nil {
            presentFromVC = Singleton.window?.rootViewController
        }
//        presentFromVC?.present(imageCarousel, animated: true)
    }
    
    func showImageViewer(_ sender: TapWithDataRecognizer, sourceView: UIImageView) {
        
//        let imageCarousel = ImageCarouselViewController.init(
//            sourceView: sourceView,
//            imageDataSource: sender.imageDatasource,
//            options: sender.options,
//            initialIndex: sender.initialIndex)
        var presentFromVC = sender.from ?? vc
        if presentFromVC == nil {
            presentFromVC = Singleton.window?.rootViewController
        }
//        presentFromVC?.present(imageCarousel, animated: true)
    }
    
}
