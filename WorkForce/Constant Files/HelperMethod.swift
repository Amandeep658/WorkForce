//
//  HelperMethod.swift
//  U2 CONNECT
//
//  Created by Apple on 24/Jun/2022
//


import Foundation
import UIKit


var questionnaire = [[String:Any]]()
var questionnaireDict = [String:Any]()
var checkInQuestionnaire = [[String:Any]]()
var checkInQuestionnaireDict = [String:Any]()
var mealNumber = 0
let WDefault = UserDefaults.standard
func validateEmail(_ email:String)->Bool
{
    let emailRegex="[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,7}"
    let emailTest=NSPredicate(format:"SELF MATCHES %@", emailRegex)
    return emailTest.evaluate(with:email)
}
func alert(_ title : String, message : String, view:UIViewController)
{
    let alert = UIAlertController(title:title, message:  message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    view.present(alert, animated: true, completion: nil)
}
func showMessage(title: String, message: String, okButton: String, cancelButton: String, controller: UIViewController, okHandler: (() -> Void)?, cancelHandler: @escaping (() -> Void)) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    
    let dismissAction = UIAlertAction(title: okButton, style: UIAlertAction.Style.default) { (action) -> Void in
        if okHandler != nil {
            okHandler!()
        }
    }
    let cancelAction = UIAlertAction(title: cancelButton, style: UIAlertAction.Style.default) {
        (action) -> Void in
        cancelHandler()
    }
    alertController.addAction(dismissAction)
    alertController.addAction(cancelAction)
    //  UIApplication.shared.windows[0].rootViewController?.present(alertController, animated: true, completion: nil)
    controller.present(alertController, animated: true, completion: nil)
}
func showAlertMessage(title: String, message: String, okButton: String, controller: UIViewController, okHandler: (() -> Void)?){
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    let dismissAction = UIAlertAction(title: okButton, style: UIAlertAction.Style.default) { (action) -> Void in
        if okHandler != nil {
            okHandler!()
        }
    }
    alertController.addAction(dismissAction)
    // UIApplication.shared.windows[0].rootViewController?.present(alertController, animated: true, completion: nil)
    controller.present(alertController, animated: true, completion: nil)
    
}
func storeCredential(email: String, password : String, authT: String){
    UserDefaults.standard.set(email, forKey: "email")
    UserDefaults.standard.set(password, forKey: "password")
    UserDefaults.standard.set(authT, forKey: "authToken")
    UserDefaults.standard.synchronize()
}

func storeLocation(userLocation:String, lat:String, long:String){
    UserDefaults.standard.set(userLocation, forKey: "location")
    UserDefaults.standard.set(lat, forKey: "lat")
    UserDefaults.standard.set(long, forKey: "log")
    UserDefaults.standard.synchronize()
}


func storeUserLocation(currentLatitude:String,currentLongitude:String){
    UserDefaults.standard.set(currentLatitude, forKey: "lat")
    UserDefaults.standard.set(currentLongitude, forKey: "log")
    UserDefaults.standard.synchronize()
}



func removeToken(){
    if  UserDefaults.standard.value(forKey: "authToken") != nil{
        UserDefaults.standard.removeObject(forKey: "authToken")
    }
    UserDefaults.standard.synchronize()
}

func removeCredential(){
    
    if UserDefaults.standard.value(forKey:"username") != nil {
        UserDefaults.standard.removeObject(forKey: "username")
    }
    if UserDefaults.standard.value(forKey: "authtoken") != nil{
        UserDefaults.standard.removeObject(forKey: "authtoken")
    }
    
    if UserDefaults.standard.value(forKey:"password") != nil {
        UserDefaults.standard.removeObject(forKey: "password")
    }
    UserDefaults.standard.synchronize()
}

func addShadowToView(targetView: UIView,shadowOffset: CGSize,shadowOpacity : Float, shadowRadius: CGFloat,shadowColor: CGColor) {
    targetView.layer.masksToBounds = false
    targetView.layer.shadowOffset = shadowOffset
    targetView.layer.shadowOpacity = shadowOpacity
    targetView.layer.shadowRadius = shadowRadius
    targetView.layer.shadowColor = shadowColor
}

func setAppDefaults<T>(_ value:T,key: String) {
    UserDefaults.standard.set(value, forKey: key)
    UserDefaults.standard.synchronize()
}

func getAppDefaults<T>(key:String) -> T? {
    guard let value = UserDefaults.standard.value(forKey: key) as? T else {
        return nil
    }
    return value
}

func getSAppDefault(key:String) -> Any{
    let value = UserDefaults.standard.value(forKey: key)
    return value as Any
}
