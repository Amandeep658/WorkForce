//
//  GalleryImagesCollectionView.swift
//  meetwise
//
//  Created by hitesh on 25/07/21.
//  Copyright © 2021 hitesh. All rights reserved.
//



import UIKit
import Photos
import PhotosUI


enum PICKER_TYPE {
    case image
    case video
    case documents
}

class ImageData: NSObject {
    var PHAsset: PHAsset?
    var image: UIImage?
    var indexPath: IndexPath?
    var isSelected: Bool = false
}



protocol GalleryImagesCollectionViewDelegate: NSObjectProtocol {
    func galleryOpenCamera()
    func didSelect(item atIndex:IndexPath)
}

class GalleryImagesCollectionView: UICollectionView {
    
    lazy var isCameraOption: Bool = false {
        didSet {
            reloadData()
        }
    }
    lazy var fetchResult: PHFetchResult<PHAsset> = PHFetchResult<PHAsset>() {
        didSet {
            self.reloadData()
        }
    }
    
    lazy var maxSelection: Int = 1
    weak var assetCollection: PHAssetCollection!
    lazy var availableWidth: CGFloat = 0
    lazy var previousPreheatRect = CGRect.zero
    fileprivate let imageManager = PHCachingImageManager()
    fileprivate var thumbnailSize: CGSize!
    var model: GalleryModel!
    
    lazy var images:[(PHAsset, IndexPath)] = []
    weak var galleryDelegate: GalleryImagesCollectionViewDelegate?
    var assetIdentifiers: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollectionView()
    }
    
    private func setCollectionView() {
        let size = (SCREEN_SIZE.width-4)/3
        thumbnailSize = CGSize(width: size, height: size)
        
        self.delegate = self
        self.dataSource = self
        self.register(GridViewCell.self, forCellWithReuseIdentifier: "GridViewCell")
        self.register(GridCameraViewCell.self, forCellWithReuseIdentifier: "GridCameraViewCell")
    }
    
    public func setImageCollection(type: ImagePickerControllerType) {
        model = GalleryModel(type: type)
        fetchResult = model.allPhotos
    }
    
    // MARK: Asset Caching
    func resetCachedAssets() {
        imageManager.stopCachingImagesForAllAssets()
        previousPreheatRect = .zero
    }
    
}

extension GalleryImagesCollectionView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isCameraOption {
            return fetchResult.count+1
        } else {
            return fetchResult.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isCameraOption, indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCameraViewCell", for: indexPath) as! GridCameraViewCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridViewCell", for: indexPath) as! GridViewCell
            let item = isCameraOption ? indexPath.item-1 : indexPath.item
            let asset = fetchResult.object(at: item)
            cell.setPHAsset(asset, imageManager: imageManager, seletedIds: assetIdentifiers)
            cell.clipsToBounds = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? GridViewCell {
            let item = isCameraOption ? indexPath.item-1 : indexPath.item
            let asset = fetchResult.object(at: item)
            cell.is_selected = assetIdentifiers.contains(asset.localIdentifier)
        }
    }
    
}

extension GalleryImagesCollectionView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return thumbnailSize
    }
}

extension GalleryImagesCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isCameraOption, indexPath.item == 0 {
            galleryDelegate?.galleryOpenCamera()
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? GridViewCell else { return }
            
            guard cell.isValidSize() else {
                return
            }
            print("is valid video size ***** \(cell.isValidSize())")
            
            let item = isCameraOption ? indexPath.item-1 : indexPath.item
            let asset = fetchResult.object(at: item)
            
            if self.maxSelection == 1 {
                var indexs = [IndexPath]()
                if let index = self.images.first?.1 {
                    indexs.append(index)
                }
                self.images.removeAll()
                self.assetIdentifiers.removeAll()
                if let cell = collectionView.cellForItem(at: indexPath) as? GridViewCell,
                   let asset = cell.asset {
                    self.images.append((asset, indexPath))
                    indexs.append(indexPath)
                    assetIdentifiers.append(asset.localIdentifier)
                }
                self.reloadItems(at: indexs)
            } else {
                if assetIdentifiers.contains(asset.localIdentifier) {
                    assetIdentifiers  = assetIdentifiers.filter({$0 != asset.localIdentifier})
                    self.images.removeAll(where: {$0.1 == indexPath})
                } else {
                    if assetIdentifiers.count < maxSelection {
                        assetIdentifiers.append(asset.localIdentifier)
                        self.images.append((asset, indexPath))
                    } else {
                       
                    }
                }
                self.reloadItems(at: [indexPath])
            }
        }
    }
    
}

extension PHAsset {
    var originalFilename: String? {
        var fname:String?
        if #available(iOS 9.0, *) {
            let resources = PHAssetResource.assetResources(for: self)
            if let resource = resources.first {
                fname = resource.originalFilename
            }
        }
        if fname == nil {
            fname = self.value(forKey: "filename") as? String
        }
        if fname == nil {
        }
        return fname
    }
    
}

