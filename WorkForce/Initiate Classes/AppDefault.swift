//
//  AppDefault.swift
//  WorkForce
//
//  Created by apple on 05/07/22.
//

import Foundation

struct AppDefaults {
    static var userID:String?{
        set{
            UserDefaults.standard.set(newValue, forKey: "uID")
        }
        get{
            return UserDefaults.standard.string(forKey: "uID")
        }
    }
    
    static var token:String?{
        set{
            UserDefaults.standard.set(newValue, forKey: "authToken")
        }
        get{
            return UserDefaults.standard.string(forKey: "authToken")
        }
    }
    
    static var userName:String?{
        set{
            UserDefaults.standard.set(newValue, forKey: "user_id")
        }
        get{
            return UserDefaults.standard.string(forKey: "user_id")
        }
    }

    static var checkLogin:Bool?{
        set{
            UserDefaults.standard.set(newValue, forKey: "checkLogin")
        }
        get{
            return UserDefaults.standard.bool(forKey: "checkLogin") ?? false
        }
    }
  
    
    static var deviceToken:String?{
        set{
            UserDefaults.standard.set(newValue, forKey: "deviceToken")
        }
        get{
            return UserDefaults.standard.string(forKey: "deviceToken") ?? "1234"
        }
    }
}
