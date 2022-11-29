//
//  PickerData.swift
//  WorkForce
//
//  Created by apple on 13/10/22.
//

import Foundation
import UIKit
import Photos


let imgOptions = PHContentEditingInputRequestOptions()


class PickData: NSObject {
    
    var fileName:String?
    var url: URL?
    var imgUrlStr: String?
    var image: UIImage?
    var index: Int?
    var data: Data?
    var fileSize:Int?
    var id: String?
    var asset: PHAsset?
    var videoAsset: AVURLAsset?
    var type: PICKER_TYPE?
    
    override init() {
        super.init()
    }
    
    init( fileName: String?,  imageUrl: URL?,  image: UIImage?,  index: Int?) {
        self.fileName = fileName
        self.url = imageUrl
        self.image = image
        self.index = index
    }
    
    init(imgUrlStr: String?) {
        self.imgUrlStr = imgUrlStr
    }
    
    init(index:Int) {
        self.index = index
    }
    
    public init(asset: PHAsset?) {
        super.init()
        self.asset = asset
        self.id    = asset?.localIdentifier
        self.setAsset()
    }
    
//    public init(video asset: AVURLAsset?, identifier: String?) {
//        super.init()
//        self.videoAsset = asset
//        self.id         = identifier
//        self.type       = .video
////        self.setVideoAsset()
//    }
    
//    private func setVideoAsset() {
//        if let filename = self.videoAsset?.url.lastPathComponent {
//            self.fileName = filename
//        } else {
//            self.fileName = "VID_\(Date().miliseconds().inInt).mp4"
//        }
//        if let url = self.videoAsset?.url {
//            self.data = try? Data(contentsOf: url)
//            self.url = url
//            url.getThumbnailImageFromVideoUrl(completion: { img in
//                DispatchQueue.main.async {
//                    self.image = img
//                }
//            })
//
////            VideoCompressor.compressVideo(inputURL: url) { newUrl in
////                DispatchQueue.main.async {
////                    if let updated = newUrl {
////                        self.data = try? Data(contentsOf: updated)
////                        print("data count is *** \(self.data?.count)")
////                        self.url = url
////                    } else {
////                        self.data = try? Data(contentsOf: url)
////                        self.url = url
////                    }
////                    print("data count is *** \(self.data?.count)")
////                }
////            }
//        }
//    }
    
    private func setAsset() {
        self.type = asset?.mediaType == .video ? .video : .image
        
        switch asset?.mediaType {
        case .video:
            imgOptions.isNetworkAccessAllowed = false
            asset?.requestContentEditingInput(with: imgOptions, completionHandler: { [weak self] (contentEditingInput, dictionary) in
                if let filename = self?.asset?.value(forKey: "filename") as? String {
                    self?.fileName = filename
                } else {
                    self?.fileName = "VID_\(Date().timeIntervalSince1970).mp4"
                }
                if let url = (contentEditingInput?.audiovisualAsset as? AVURLAsset)?.url {
                    self?.data = try? Data(contentsOf: url)
                    self?.url = url
                    
                    
//                    VideoCompressor.compressVideo(inputURL: url) { newUrl in
//                        DispatchQueue.main.async {
//                            if let updated = newUrl {
//                                self?.data = try? Data(contentsOf: updated)
//                                print("data count is *** \(self?.data?.count)")
//                                self?.url = url
//                            } else {
//                                self?.data = try? Data(contentsOf: url)
//                                self?.url = url
//                            }
//                            print("data count is *** \(self?.data?.count)")
//                        }
//                    }
//                    if let img = url.thumbnailForVideoAtURL() {
//                        self?.image = img
//                    }
//                    url.getThumbnailImageFromVideoUrl(completion: { img in
//                        DispatchQueue.main.async {
//                            self?.image = img
//                        }
//                    })
                }
            })
        case .image:
            imgOptions.isNetworkAccessAllowed = false
            print("asset get from ************ \(self.asset?.originalFilename)")
            asset?.requestContentEditingInput(with: imgOptions, completionHandler: { [self] (contentEditingInput, dictionary) in
                print("image is \(contentEditingInput?.displaySizeImage?.pngData()?.count)")
//                DispatchQueue.main.async {
                    print("fullSizeImageURL \( contentEditingInput?.fullSizeImageURL)")
                    if let url = contentEditingInput?.fullSizeImageURL {
                        do {
                            let data = try Data(contentsOf: url)
                            self.image =  UIImage(data: data)
                            let updated = self.image?.jpegData(compressionQuality: 0.2)
                            self.data = updated
                            self.fileSize = updated?.count
                            if let filename = self.asset?.value(forKey: "filename") as? String {
                                self.fileName = filename
                            } else {
                                self.fileName = "IMG_\(Date().timeIntervalSince1970).jpg"
                            }
                            self.url = url
                            print("data found \(self.data?.count)")
                        } catch {
                            print("not found data for \(url.absoluteString)")
                        }
//                    }
                }
            })
        default: break
        }
    }
    
}
