//
//  TabBarVC.swift
//  WalkinsAvailable
//
//  Created by MyMac on 4/5/22.
//


import UIKit
import SDWebImage
import Alamofire

class TabBarVC: ESTabBarController {
    
    var attributesForTitle: [NSAttributedString.Key : Any] {
        return [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)]
    }
    var currentController: UIViewController?
    var locName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTabController()
        updateProfileImage()
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCurrentlangugaeUpdate()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    @objc func editPostAction(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.selectedIndex = 2
        }
    }
    
    func updateProfileImage() {
        if UserType.userTypeInstance.userLogin == .Bussiness {
            if let lastitem = self.tabBar.items?.last as? ESTabBarItem {
                let photo = UserDefaults.standard.string(forKey: "BusinessProfileImage")
                if lastitem.contentView?.imageView.restorationIdentifier != photo {
                    self.getImage(tabItem: lastitem, imageString: photo)
                }
            }
        }else if UserType.userTypeInstance.userLogin == .Professional{
            if let lastitem = self.tabBar.items?.last as? ESTabBarItem {
                let photo = UserDefaults.standard.string(forKey: "ProfessionalProfileImage")
                if lastitem.contentView?.imageView.restorationIdentifier != photo {
                    self.getImage(tabItem: lastitem, imageString: photo)
                }
            }
        }else{
            if let lastitem = self.tabBar.items?.last as? ESTabBarItem {
                let photo = UserDefaults.standard.string(forKey: "CoustomerProfileImage")
                if lastitem.contentView?.imageView.restorationIdentifier != photo {
                    self.getImage(tabItem: lastitem, imageString: photo)
                }
            }
        }
        
    }
    
    
    func setTabController() {
        self.tabBar.backgroundColor = .white
        self.tabBar.borderColor = .black
        self.tabBar.borderWidth = 1.0
        if  UserType.userTypeInstance.userLogin == .Bussiness{
            let v1 =  UINavigationController(rootViewController: BusinessHmVC())
            v1.navigationBar.isHidden = true
            let v2 =  UINavigationController(rootViewController: BusinessConnectViewController())
            v2.navigationBar.isHidden = true
            let v3 = UINavigationController(rootViewController: JobsDesignerViewController())
            v3.navigationBar.isHidden = true
            let v4 =  UINavigationController(rootViewController: BusinessChatViewController())
            v4.navigationBar.isHidden = true
            let v5 =  UINavigationController(rootViewController: BusinessProfileViewController())
            v5.navigationBar.isHidden = true
            v1.tabBarItem = ESTabBarItem(ExampleIrregularityBasicContentView(), title: "Home".localized(), image: UIImage(named: "hm"), selectedImage: UIImage(named: "ho"))
            v2.tabBarItem = ESTabBarItem(ExampleIrregularityBasicContentView(), title: "Connect".localized(), image:UIImage(named: "Unstar"),selectedImage: UIImage(named: "fillStar"))
            v3.tabBarItem = ESTabBarItem(ExampleIrregularityBasicContentView(), title: "Jobs".localized(), image:UIImage(named: "job"),selectedImage: UIImage(named: "jobs"))
            v4.tabBarItem = ESTabBarItem(ExampleIrregularityBasicContentView(), title: "Chat".localized(), image: UIImage(named: "3"), selectedImage: UIImage(named: "ch"))
            let tabItem = ESTabBarItem(ExampleIrregularityBasicContentView(), title: "Profile".localized(), image: UIImage(named: "placeholder"), selectedImage: UIImage(named: "placeholder"))
            tabItem.contentView?.imageView.layer.cornerRadius = 12
            tabItem.contentView?.imageView.clipsToBounds = true
            v5.tabBarItem = tabItem
            let profileImg = UserDefaults.standard.string(forKey: "BusinessProfileImage")
            self.getImage(tabItem: v5.tabBarItem as! ESTabBarItem, imageString: profileImg)
            self.viewControllers = [v1, v2,v3, v4, v5]
        
        }
        else if UserType.userTypeInstance.userLogin == .Professional{
            let v1 =  UINavigationController(rootViewController: HomeViewController())
            v1.navigationBar.isHidden = true
            let v2 =  UINavigationController(rootViewController: ConnectViewController())
            v2.navigationBar.isHidden = true
            let v4 =  UINavigationController(rootViewController: ChatViewController())
            v4.navigationBar.isHidden = true
            let v5 =  UINavigationController(rootViewController: ProfessionalProfileVC())
            v5.navigationBar.isHidden = true
            v1.tabBarItem = ESTabBarItem(ExampleIrregularityBasicContentView(), title: "Home".localized(), image: UIImage(named: "hm"), selectedImage: UIImage(named: "ho"))
            v2.tabBarItem = ESTabBarItem(ExampleIrregularityBasicContentView(), title: "Connect".localized(), image:UIImage(named: "Unstar"),
                                         selectedImage: UIImage(named: "fillStar"))
            v4.tabBarItem = ESTabBarItem(ExampleIrregularityBasicContentView(), title: "Chat".localized(), image: UIImage(named: "3"), selectedImage: UIImage(named: "ch"))
            let tabItem = ESTabBarItem(ExampleIrregularityBasicContentView(), title: "Profile".localized(), image: UIImage(named: "placeholder"), selectedImage: UIImage(named: "placeholder"))
            tabItem.contentView?.imageView.layer.cornerRadius = 12
            tabItem.contentView?.imageView.clipsToBounds = true
            v5.tabBarItem = tabItem
            self.viewControllers = [v1, v2,v4, v5]
            let profileImg = UserDefaults.standard.string(forKey: "ProfessionalProfileImage")
            self.getImage(tabItem: v5.tabBarItem as! ESTabBarItem, imageString: profileImg ?? "")
            
        }else if UserType.userTypeInstance.userLogin == .Coustomer{
            let v1 =  UINavigationController(rootViewController: CustomerHomeVC())
            v1.navigationBar.isHidden = true
            let v2 =  UINavigationController(rootViewController: CoustomerConnectVC())
            v2.navigationBar.isHidden = true
            let v3 = UINavigationController(rootViewController: JobsDesignerViewController())
            v3.navigationBar.isHidden = true
            let v4 =  UINavigationController(rootViewController: CoustomerChatVC())
            v4.navigationBar.isHidden = true
            let v5 =  UINavigationController(rootViewController: CoustomerProfileVC())
            v5.navigationBar.isHidden = true
            v1.tabBarItem = ESTabBarItem(ExampleIrregularityBasicContentView(), title: "Home".localized(), image: UIImage(named: "hm"), selectedImage: UIImage(named: "ho"))
            v2.tabBarItem = ESTabBarItem(ExampleIrregularityBasicContentView(), title: "Connect".localized(), image:UIImage(named: "Unstar"),selectedImage: UIImage(named: "fillStar"))
            v3.tabBarItem = ESTabBarItem(ExampleIrregularityBasicContentView(), title: "Jobs".localized(), image:UIImage(named: "job"),selectedImage: UIImage(named: "jobs"))
            v4.tabBarItem = ESTabBarItem(ExampleIrregularityBasicContentView(), title: "Chat".localized(), image: UIImage(named: "3"), selectedImage: UIImage(named: "ch"))
            let tabItem = ESTabBarItem(ExampleIrregularityBasicContentView(), title: "Profile".localized(), image: UIImage(named: "placeholder"), selectedImage: UIImage(named: "placeholder"))
            tabItem.contentView?.imageView.layer.cornerRadius = 12
            tabItem.contentView?.imageView.clipsToBounds = true
            v5.tabBarItem = tabItem
            self.viewControllers = [v1, v2,v3,v4, v5]
            let profileImg = UserDefaults.standard.string(forKey: "CoustomerProfileImage")
            self.getImage(tabItem: v5.tabBarItem as! ESTabBarItem, imageString: profileImg ?? "")
        }else{
        }
    }
    
    func getImage(tabItem: ESTabBarItem, imageString: String?) {
        let urlString = imageString      // UserDefaultsCustom.getUserData()?.image
        if let urlst = urlString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlst) {
            SDWebImageManager.shared().loadImage(with: url, options: .highPriority, progress: nil, completed: { image, data, error, cacheType, finished, url in
                if let err = error {
                    print("error error error error error error", err)
                    return
                }
                
                //                guard let img = image else { return }
                if let img = image {
                    print("img img img img img", img)
                    tabItem.contentView?.image = img
                    tabItem.contentView?.selectedImage = img
                    tabItem.contentView?.imageView.restorationIdentifier = urlString
                    tabItem.contentView?.clipsToBounds = true
                }
                
            })
        }
        
    }
    
    //    MARK: LANGUAGE UPDATE
    func getCurrentlangugaeUpdate(){
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print("headers*****>>>",headers)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.getCurrentlangugae, params: getCurrentLanguageParametres(), headers: headers){ [self] (response) in
            print(response)
            AFWrapperClass.svprogressHudDismiss(view: self)
            let status = response["code"] as? Int ?? 0
            print(status)
            if status == 200 {
                
            }else {
            }
        } failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
    
    
    func getCurrentLanguageParametres() -> [String:AnyObject] {
        var parameters : [String:AnyObject] = [:]
        if Locale.current.languageCode == "es"{
            parameters["is_language"] = "1"  as AnyObject
        }else if Locale.current.languageCode == "pt"{
            parameters["is_language"] = "2"  as AnyObject
        }else if Locale.current.languageCode == "en"{
            parameters["is_language"] = "0"  as AnyObject
        }
        print(parameters)
        return parameters
    }
}

extension TabBarVC : UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if  UserType.userTypeInstance.userLogin == .Bussiness{
            if tabBarController.selectedIndex == 0{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "homeTabPressed"), object: nil, userInfo: nil)
                }
            }else if tabBarController.selectedIndex == 3{
                print("chatt pressed")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "chatPressed"), object: nil, userInfo: nil)
                }
            }
        }else if UserType.userTypeInstance.userLogin == .Professional{
            if tabBarController.selectedIndex == 0{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "professionalhomeTabPressed"), object: nil, userInfo: nil)
                }
            }else if tabBarController.selectedIndex == 2{
                print("chatt pressed")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "chatPressed"), object: nil, userInfo: nil)
                }
            }
        }else if UserType.userTypeInstance.userLogin == .Coustomer{
            if tabBarController.selectedIndex == 2{
                print("chatt pressed")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "chatPressed"), object: nil, userInfo: nil)
                }
            }
        }else{
            print("its printing")
        }
    }
}

extension UIImage{
    var roundedImage: UIImage {
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        UIBezierPath(
            roundedRect: rect,
            cornerRadius: self.size.height
        ).addClip()
        self.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    func resizedImage(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    func squareMyImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: self.size.width, height: self.size.width))
        
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.width))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
