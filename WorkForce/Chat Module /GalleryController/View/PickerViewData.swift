//
//  PickerViewData.swift
//  WorkForce
//
//  Created by apple on 13/10/22.
//

import Foundation
import UIKit
import Photos


let imageOptions = PHContentEditingInputRequestOptions()

class PicData: NSObject {
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
    
    private func setAsset() {
        self.type = asset?.mediaType == .video ? .video : .image
        
        switch asset?.mediaType {
        case .video:
            imageOptions.isNetworkAccessAllowed = false
            asset?.requestContentEditingInput(with: imageOptions, completionHandler: { [weak self] (contentEditingInput, dictionary) in
                if let filename = self?.asset?.value(forKey: "filename") as? String {
                    self?.fileName = filename
                } else {
                    self?.fileName = "VID_\(Date().timeIntervalSince1970).mp4"
                }
                if let url = (contentEditingInput?.audiovisualAsset as? AVURLAsset)?.url {
                    self?.data = try? Data(contentsOf: url)
                    self?.url = url
                }
            })
        case .image:
            imageOptions.isNetworkAccessAllowed = false
            print("asset get from ************ \(self.asset?.originalFilename)")
            asset?.requestContentEditingInput(with: imageOptions, completionHandler: { [self] (contentEditingInput, dictionary) in
                print("image is \(contentEditingInput?.displaySizeImage?.pngData()?.count)")
                    print("fullSizeImageURL \(contentEditingInput?.fullSizeImageURL)")
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
                }
            })
        default: break
        }
    }
    
}





//    init(banner: Banner, index:Int) {
//        self.fileName = banner.file_name
//        self.imgUrlStr = banner.url
//        self.fileSize = banner.file_size
//        print("size is ***** \(banner.file_size)")
//        self.id = banner._id
//        self.index = index
//    }
//
//    func getJson(isData:Bool) -> JSON {
//        var docs = JSON()
//        docs["file_name"] = self.fileName
//        docs["url"] = self.imgUrlStr
//        if isData {
//            docs["file_size"] = self.fileSize
//        }
//        return docs
//    }
//
//    func getBanner() -> Banner {
//        let banner = Banner()
//        banner.file_name = self.fileName
//        banner.url = self.imgUrlStr
//        banner.file_size = self.fileSize
//        banner.added_on = Date().toString()
//        return banner
//    }
    





//                if let url = (contentEditingInput?.audiovisualAsset as? AVURLAsset)?.url {
//                    self?.localUrl = url
//
//                    self?.uploadVideo(url: url)
//                    url.getThumbnailImageFromVideoUrl(completion: { img in
//                        DispatchQueue.main.async {
//                            self?.image = img
//                        }
//                    })
//                }
//            })






//                        MWFileManager.saveLocalImage(data: self?.data, fileName: self?.fileName)
//                        MWFileManager.saveFile(data: data, fileName: self?.fileName ?? "name.txt")
//                        self?.localUrl = MWFileManager.getPhotoFileUrl(_fileName: self?.fileName ?? "")
//                        self?.uploadData()
