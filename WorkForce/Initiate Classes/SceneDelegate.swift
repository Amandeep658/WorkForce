//
//  SceneDelegate.swift
//  WorkForce
//
//  Created by apple on 04/05/22.
//

import UIKit
import FirebaseAuth
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var peofessionalDict = SingletonLocalModel()
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = window
        appDelegate.currentLanguageTrigger()
        appDelegate.checkLogin()
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
      for urlContext in URLContexts {
          let url = urlContext.url
          Auth.auth().canHandle(url)
      }
      // URL not auth related; it should be handled separately.
    }
    
}

//        let authToken  = getSAppDefault(key: "authToken") as? String ?? ""
//        let type = peofessionalDict.type ?? ""
//        print("here is type ----->>>>", type)
//        let checkRole = UserDefaults.standard.value(forKey: "CheckRow") ?? ""
//        if checkRole as! String == "Business" {
//            if type != ""{
//                appDelegate.loginToHomePage()
//            }
//            else{
//                appDelegate.navigation()
//            }
//        }else{
//            if type != ""{
//                appDelegate.loginToProfessionalHomePage()
//            }
//            else{
//                appDelegate.navigation()
//            }
//        }
