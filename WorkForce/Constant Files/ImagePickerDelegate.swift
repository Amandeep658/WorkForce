//
//  ImagePickerDelegate.swift
//  Let Me Listen
//
//  Created by Apple on 07/12/21.
//

import Foundation
import UIKit
import AVKit
import AVFoundation


public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?,videoData:Data?)
    func videoSelect(thumbnail: UIImage?,videoData:Data?)
}

open class ImagePicker: NSObject {
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image","public.movie"]
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
    public func present(from sourceView: UIView) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: "Take photo".localized()) {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library".localized()) {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        self.presentationController?.present(alertController, animated: true)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage? , videoData: Data?) {
        controller.dismiss(animated: true) {
            self.delegate?.didSelect(image: image,videoData: videoData)
            self.delegate?.videoSelect(thumbnail: image, videoData: videoData)
        }
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil,videoData: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image =  info[.editedImage] as? UIImage{
            self.pickerController(picker, didSelect: image,videoData: nil)
            return
        }else if let image = info[.originalImage] as? UIImage{
            self.pickerController(picker, didSelect: image,videoData: nil)
            return
        }else if let video = info[.mediaURL] as? URL{
            let thumbnail = self.createThumbnailOfVideoFromUrl(url: video)
            let thumbnailData = thumbnail!.jpegData(compressionQuality: 0.3)!
            let data = NSData(contentsOf: video as URL)! as Data
            self.pickerController(picker, didSelect: thumbnail,videoData: data)
        }else{
            self.pickerController(picker, didSelect: nil,videoData: nil)
        }
    }
    
    func createThumbnailOfVideoFromUrl(url: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url:url , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
}

extension ImagePicker: UINavigationControllerDelegate {
    
}
