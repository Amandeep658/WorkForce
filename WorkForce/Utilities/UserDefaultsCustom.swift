//
//  UserDefaultsCustom.swift
//  CullintonsCustomer
//
//  Created by Rakesh Kumar on 04/04/18.
//  Copyright © 2018 Rakesh Kumar. All rights reserved.
//

import UIKit
//import FirebaseMessaging
//import FirebaseCore

struct UserDefaultsCustom {
    static let deviceToken = "deviceToken"
    static let accessToken = "auth_token"
    static let userData = "data"
    static let eventFieldsModel = "EventFieldsModel"
    
    
    
    static func getDeviceToken() -> String {
//        let token = Messaging.messaging().fcmToken
//        print("FCM token: \(token ?? "")")
//        return token ?? deviceToken
        if let value = UserDefaults.standard.value(forKey: UserDefaultsCustom.deviceToken) as? String {
            return value
        } else {
            return "auth_token"
        }
    }
    
    static var firstTimeOpen: Bool {
        return UserDefaults.standard.value(forKey: "firstTimeOpen") == nil
    }
    
    static func setValue(value:Any?, for key:String) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
//        static func getToken() -> String {
//            //        let token = Messaging.messaging().fcmToken
//            //        print("FCM token: \(token ?? "")")
//            //        return token ?? deviceToken
//            if let value = UserDefaults.standard.value(forKey: UserDefaultsCustom.Token) {
//                return value as! String
//            } else {
//                return ""
//            }
//        }
    
    static func getAccessToken() -> String {
        if let value = UserDefaults.standard.value(forKey: UserDefaultsCustom.accessToken) {
            return value as! String
        } else {
            return ""
        }
    }
    
    static func getValue(forKey: String) -> String? {
        if let value = UserDefaults.standard.value(forKey: forKey) {
            return value as? String
        }
        return nil
    }
    
    static func setValue(value: Any?, forKey:String) {
        UserDefaults.standard.setValue(value, forKey: forKey)
    }
    
    static func saveUserData(userData: UserData) {
        print("save user data")
        UserDefaults.standard.set(try? PropertyListEncoder().encode(userData), forKey:UserDefaultsCustom.userData)
    }
    
    static func getUserData() -> UserData? {
        if let data = UserDefaults.standard.value(forKey:UserDefaultsCustom.userData) as? Data {
            let userData = try? PropertyListDecoder().decode(UserData.self, from: data)
            return userData
        }
//        if let data = UserDefaults.standard.value(forKey:UserDefaultsCustom.userData) as? Data {
//            do {
//                let decoder = JSONDecoder()
//                let userData = try decoder.decode(UserData.self, from: data)
//                return userData
//            } catch let err {
//                print(err)
//                return nil
//            }
//        }
        return nil
    }
    
    
}


extension UserDefaults {
    class func setValue(value:Any?, for key:String) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
    class func valueFor(key: String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }
    
}
