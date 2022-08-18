//
//  Singleton.swift
//  WalkinsAvailable
//
//  Created by apple on 02/05/22.
//

import Foundation
import UIKit


class Singleton: NSObject {
    
    static var window: UIWindow?
    
//    class func setHomeScreenView(userType: USER_TYPE) {
//        let viewController = TabBarVC(userType: userType)
//        let nav = NavigationController(rootViewController: viewController)
//        nav.isNavigationBarHidden = true
//        Singleton.window?.rootViewController = nav
//        Singleton.window?.makeKeyAndVisible()
//    }
    
    class func setLoginScreenView() {
        let viewController = BusinessesViewController()
        let nav = UINavigationController(rootViewController: viewController)
        Singleton.window?.rootViewController = nav
        Singleton.window?.makeKeyAndVisible()
    }
    
    
}
