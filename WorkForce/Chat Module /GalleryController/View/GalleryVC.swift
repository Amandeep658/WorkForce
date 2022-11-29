//
//  GalleryVC.swift
//  meetwise
//
//  Created by hitesh on 23/07/21.
//  Copyright © 2021 hitesh. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

protocol GalleryVCDelegate: NSObjectProtocol {
    func galleryController(_ gallery: GalleryVC, didselect items: [PHAsset], assetIds: [String])
    func galleryControllerOpenCamera(_ gallery: GalleryVC)
}

class GalleryVC: UIViewController {
    
    @IBOutlet weak var tableView: GalleryAlbumTableView!
    @IBOutlet weak var collectionView: GalleryImagesCollectionView!
    @IBOutlet weak var selectAlbumButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableBackgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    lazy var assetIdentifiers: [String] = []
    lazy var isCameraOption: Bool = false
    weak var delegate: GalleryVCDelegate?
    lazy var maxSelection: Int = 10
    var pickerType: ImagePickerControllerType = .image
    
    init(isCameraOption: Bool = false, delegate: GalleryVCDelegate? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.isCameraOption = isCameraOption
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraAccess()
    }
    

    override func viewDidDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setGalleryPermission()
        switch pickerType {
        case .image:
            self.titleLabel.text = "Add Images"
        case .video:
            self.titleLabel.text = "Add Video"
        case .both:
            self.titleLabel.text = "Add Images/Video"
        }
        collectionView.maxSelection = self.maxSelection
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func cameraAccess() {
        collectionView.assetIdentifiers = self.assetIdentifiers
        collectionView.isCameraOption = isCameraOption
        collectionView.galleryDelegate = self
        tableView.galleryDelegate = self
        tableBackgroundView.isHidden = true
        let height = tableView.frame.height
        self.tableView.transform = .init(translationX: 0, y: -height)
        collectionView.setImageCollection(type: pickerType)
    }
    
    private func setGalleryPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            self.cameraAccess()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                DispatchQueue.main.async {
                    if newStatus ==  PHAuthorizationStatus.authorized {
                        self.cameraAccess()
                    }else{
                        print("User denied")
                    }
                }})
            break
        case .restricted:
            print("restricted")
            break
        case .denied:
            print("denied")
            break
        case .limited:
            break
        @unknown default:
            break
        }
    }
    
    func selectedImages() {
        let assets = self.collectionView.images.map({$0.0})
        print("assets count are \(assets.count) \(delegate == nil)")
        if assets.count > 0 {
                self.delegate?.galleryController(self, didselect: assets, assetIds: self.collectionView.assetIdentifiers)
            print("assest******>>>",assets)
        } else {
            ActivityIndicator.sharedInstance.hideActivityIndicator()
        }
    }
    
    @IBAction func doneBtn(_ sender: UIButton) {
        ActivityIndicator.sharedInstance.showActivityIndicator()
        selectedImages()
    }
    
    
    @IBAction func selectAlbumAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        let height = tableView.frame.height
        if sender.isSelected {
            self.tableView.transform = .init(translationX: 0, y: -height)
            self.tableBackgroundView.isHidden = false
        }
        UIView.animate(withDuration: 0.3) {
            if sender.isSelected {
                sender.imageView?.transform = .init(rotationAngle: CGFloat.pi)
                self.tableView.transform = .identity
            } else {
                sender.imageView?.transform = .identity
                self.tableView.transform = .init(translationX: 0, y: -height)
            }
        } completion: { ani in
            if !sender.isSelected {
                self.tableBackgroundView.isHidden = true
            }
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectAction(_ sender: UIButton) {
//        let assets = self.collectionView.images.map({$0.0})
//        self.delegate?.galleryController(self, didselect: assets, assetIds: self.collectionView.assetIdentifiers)
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension GalleryVC : GalleryAlbumTableViewDelegate {
    func tableView(selection: GalleryAlbumTableView.Section, didSelect ablum: PHCollection?) {
        var title: String = ""
        switch selection {
        case .allPhotos:
            self.collectionView.fetchResult = GalleryModel(type: pickerType).allPhotos
            title = "All Photos"
        case .smartAlbums, .userCollections:
            if let assetCollection = ablum as? PHAssetCollection {
                title = assetCollection.localizedTitle ?? "Photos"
                print("assestCollection ********** ",assetCollection)
                
                let options = PHFetchOptions()
                options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                
                let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: pickerType.predicates)
                options.predicate = predicate
                
                let result = PHAsset.fetchAssets(in: assetCollection, options: options)
                self.collectionView.fetchResult = result
            }
        }
        let height = tableView.frame.height
        UIView.animate(withDuration: 0.3) { [self] in
            selectAlbumButton.imageView?.transform = .identity
            tableView.transform = .init(translationX: 0, y: -height)
//            selectAlbumButton.title = title
        } completion: { ani in
            self.selectAlbumButton.isSelected = false
            self.tableBackgroundView.isHidden = true
        }
        
    }
}

extension GalleryVC: GalleryImagesCollectionViewDelegate {
    func galleryOpenCamera() {
        print("open camera")
        self.delegate?.galleryControllerOpenCamera(self)
    }
    
    func didSelect(item atIndex: IndexPath) {
        print("did Select image")
    }
    
}
