//
//  AppDelegate.swift
//  WorkForce
//
//  Created by apple on 04/05/22.
//

import UIKit
import Firebase
import FirebaseAuth
import IQKeyboardManagerSwift
import UserNotifications
import GooglePlaces
import GoogleMaps
import StoreKit
import SwiftyStoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        //        GMSServices.provideAPIKey("AIzaSyAGY0Xsa05iLDkxF93vUfX-MRcBE3vdz5E")
        //        GMSPlacesClient.provideAPIKey("AIzaSyAGY0Xsa05iLDkxF93vUfX-MRcBE3vdz5E")
        GMSPlacesClient.provideAPIKey("AIzaSyCzdtjehNkbBv2JsYR2pVxq1qB866Pk72M")
        GMSServices.provideAPIKey("AIzaSyCzdtjehNkbBv2JsYR2pVxq1qB866Pk72M")
        self.configureNotification()
        self.setupIAP()
        let sddssdsd = getLenguage()
        print(sddssdsd)
        
//        if let currentLanguage = Locale.currentLanguage {
//            print(currentLanguage.rawValue)
//            // Your code here.
//        }
       checkLen()
        return true
    }
    
    
    
    func checkLen() {
        let lan = NSLocale.preferredLanguages.first
        let lanDict = NSLocale.components(fromLocaleIdentifier: lan ?? "")
        let lanCOde = lanDict["kCFLocalLanguageCodeKey"]
        print(lanCOde)
    }
    
    func currentLanguageTrigger() {
        // This is done so that network calls now have the Accept-Language as Language.getCurrentLanguage() (Using Alamofire) Check if you can remove these
        //        let language = Bundle.main.preferredLocalizations.first
        //        UserDefaults.standard.set([Locale.current.languageCode ], forKey: "AppleLanguages")
        //        UserDefaults.standard.synchronize()
        //        Bundle.setLanguage(NSLocale.current.languageCode!)
        
        var preferredLanguage : String = Bundle.main.preferredLocalizations.first!
        print(preferredLanguage)
    }
    
    
    func getLenguage() -> Locale {
        guard let lenguage = NSLocale.preferredLanguages.first else {
            return NSLocale.current }
        return NSLocale(localeIdentifier: lenguage) as Locale
    }
    
    
    func navigation(){
        let nav = UINavigationController(rootViewController: BusinessesViewController(nibName: "BusinessesViewController", bundle: nil))
        nav.navigationBar.isHidden = true
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    
    func specificNavigation(){
        let nav = UINavigationController(rootViewController: CustomerJobListVC(nibName: "CustomerJobListVC", bundle: nil))
        nav.navigationBar.isHidden = true
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    
    func ManageClassnavigation(){
        let nav = UINavigationController(rootViewController: ManageJobsViewController(nibName: "ManageJobsViewController", bundle: nil))
        nav.navigationBar.isHidden = true
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    
    func setupIAP() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    print("\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                case .failed, .purchasing, .deferred:
                    break // do nothing
                }
            }
        }
        SwiftyStoreKit.updatedDownloadsHandler = { downloads in
            // contentURL is not nil if downloadState == .finished
            let contentURLs = downloads.compactMap { $0.contentURL }
            if contentURLs.count == downloads.count {
                print("Saving: \(contentURLs)")
                SwiftyStoreKit.finishTransaction(downloads[0].transaction)
            }
        }
    }
    
    func loginToHomePage(){
        if UserType.userTypeInstance.userLogin == .Bussiness{
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let homeViewController = TabBarVC(nibName: "TabBarVC", bundle: nil)
            homeViewController.selectedIndex = 0
            let nav = UINavigationController(rootViewController: homeViewController)
            nav.setNavigationBarHidden(true, animated: true)
            appdelegate.window?.rootViewController = nav
        }else if UserType.userTypeInstance.userLogin == .Professional{
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let homeViewController = TabBarVC(nibName: "TabBarVC", bundle: nil)
            homeViewController.selectedIndex = 0
            let nav = UINavigationController(rootViewController: homeViewController)
            nav.setNavigationBarHidden(true, animated: true)
            appdelegate.window?.rootViewController = nav
        }else if UserType.userTypeInstance.userLogin == .Coustomer{
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let homeViewController = TabBarVC(nibName: "TabBarVC", bundle: nil)
            homeViewController.selectedIndex = 0
            let nav = UINavigationController(rootViewController: homeViewController)
            nav.setNavigationBarHidden(true, animated: true)
            appdelegate.window?.rootViewController = nav
        }
    }
    
    func checkLogin(){
        let checkRole = UserDefaults.standard.value(forKey: "CheckRow") ?? ""
        if checkRole as! String == "Business" {
            if AppDefaults.token != nil{
                UserType.userTypeInstance.userLogin = .Bussiness
                self.loginToHomePage()
            }
            else{
                self.navigation()
            }
        }else if checkRole as! String == "Professional"{
            if AppDefaults.token != nil{
                UserType.userTypeInstance.userLogin = .Professional
                self.loginToHomePage()
            }
            else{
                self.navigation()
            }
        }else{
            if AppDefaults.token != nil{
                UserType.userTypeInstance.userLogin = .Coustomer
                self.loginToHomePage()
            }
            else{
                self.navigation()
            }
        }
    }
    
    
    
    // MARK: UISCENCE SESSION DEL
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("device token is \(deviceTokenString)")
        AppDefaults.deviceToken = deviceToken.hexString
        Auth.auth().setAPNSToken(deviceToken, type: .prod)
    }
    
    
    func application(_ application: UIApplication, open url: URL,options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        if Auth.auth().canHandle(url) {
            return true
        }
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification notification: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("\(#function)")
        if Auth.auth().canHandleNotification(notification) {
            completionHandler(.noData)
            return
        }
    }
    
    //    MARK: PUSH NOTIFICATION
    func configureNotification() {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
        }else{
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,willPresent notification: UNNotification,withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        if let notifData = userInfo["aps"] as? [String:Any]{
            if let data = notifData["data"] as? [String:Any]{
                let notifType = data["notification_type"] as? String
                print(notifType)
            }
        }else{
            completionHandler([.alert, .badge, .sound])
        }
        completionHandler([.alert, .badge ,.sound])
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let userInfo = response.notification.request.content.userInfo as? [String:Any]{
            print(userInfo)
            if let notifData = userInfo["aps"] as? [String:Any]{
                if let data = notifData["data"] as? [String:Any]{
                    print(data)
                    let state  = UIApplication.shared.applicationState
                    //                    if (state == .inactive || state == .background) {
                    self.checkFeedbackNotification(data: data)
                }
                completionHandler()
                
            }
        }
    }
    
    
    func checkFeedbackNotification(data: [String:Any]){
        let notificationType = data["notification_type"] as? String
        switch notificationType {
        case "1":
            let isType = data["type"] as? String
            let isSubscription =  data["isSubscribed"] as? String
            if isSubscription == "1" || isType == "3"{
                print("Please take subscription")
                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                let chatViewController = SingleChatController()
                chatViewController.pushNav = true
                chatViewController.userName = (data["username"] as? String ?? "")!
                chatViewController.chatRoomId = (data["room_id"] as? String ?? "")!
                chatViewController.companyname = (data["username"] as? String ?? "")!
                let homeVC = TabBarVC()
                homeVC.selectedIndex = 0
                let nav = UINavigationController()
                nav.setViewControllers([homeVC,chatViewController], animated: true)
                nav.navigationBar.isHidden = true
                appdelegate.window?.rootViewController = nav
            }else{
                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                let subscription = SubscribePlanViewController()
                let homeVC = TabBarVC()
                homeVC.selectedIndex = 0
                let nav = UINavigationController()
                nav.setViewControllers([homeVC,subscription], animated: true)
                nav.navigationBar.isHidden = true
                appdelegate.window?.rootViewController = nav
            }
            break
        case "2":
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let notificationVC = NotificationViewController()
            let homeVC = TabBarVC()
            homeVC.selectedIndex = 0
            let nav = UINavigationController()
            nav.setViewControllers([homeVC, notificationVC], animated: true)
            nav.navigationBar.isHidden = true
            appdelegate.window?.rootViewController = nav
            break
        case "3":
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let notificationVC = NotificationViewController()
            let homeVC = TabBarVC()
            homeVC.selectedIndex = 0
            let nav = UINavigationController()
            nav.setViewControllers([homeVC,notificationVC], animated: true)
            nav.navigationBar.isHidden = true
            appdelegate.window?.rootViewController = nav
            break
        default:
            break
        }
    }
}



enum Language: String {
    
    case none = ""
    case en = "English"
    case es = "Spanish"
    case pt = "Portuguese"
    
}


extension Locale {
    
    static var enLocale: Locale {
        
        return Locale(identifier: "en-EN")
    } // to use in **currentLanguage** to get the localizedString in English
    
    static var currentLanguage: Language? {
        
        guard let code = preferredLanguages.first?.components(separatedBy: "-").last else {
            
            print("could not detect language code")
            
            return nil
        }
        
        guard let rawValue = enLocale.localizedString(forLanguageCode: code) else {
            
            print("could not localize language code")
            
            return nil
        }
        
        guard let language = Language(rawValue: rawValue) else {
            
            print("could not init language from raw value")
            
            return nil
        }
        print("language: \(code)-\(rawValue)")
        
        return language
    }
    static var preferredLanguageCode: String {
        let defaultLanguage = "en"
        let preferredLanguage = preferredLanguages.first ?? defaultLanguage
        return Locale(identifier: preferredLanguage).languageCode ?? defaultLanguage
    }
    
    static var preferredLanguageCodes: [String] {
        return Locale.preferredLanguages.compactMap({Locale(identifier: $0).languageCode})
    }
}
