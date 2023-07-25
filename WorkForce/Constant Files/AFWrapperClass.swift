//
// AFWrapperClass.swift
//  U2 CONNECT
//
//  Created by Apple on 24/Jun/2022
//
//
import Foundation
import UIKit
import Alamofire
import SVProgressHUD
//import NVActivityIndicatorView

class AFWrapperClass{
    class func requestPOSTURL(_ strURL : String, params : Parameters,headers : HTTPHeaders?, success:@escaping (NSDictionary) -> Void, failure:@escaping (NSError) -> Void){
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        print(urlwithPercentEscapes)
        AF.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        success(JSON as NSDictionary)
                    }
                case .failure(let error):
                    let error : NSError = error as NSError
                    print("error is ******* \(error)")
                    failure(error)
                }
        }
    }
    
    
    class func requestPOSTUrl(_ strURL : String, params : Parameters?, success:@escaping (NSDictionary) -> Void, failure:@escaping (NSError) -> Void){
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        print(token,"tooo")
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        AF.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Token":token])
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        success(JSON as NSDictionary)
                    }

                case .failure(let error):
                    let error : NSError = error as NSError
                    failure(error)
                }
            }
    }

    
    class func requestUrlEncodedPOSTURL(_ strURL : String, params : Parameters, success:@escaping (NSDictionary) -> Void, failure:@escaping (NSError) -> Void){
           let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        AF.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: URLEncoding.default, headers: ["Content-Type":"application/x-www-form-urlencoded"])
               .responseJSON { (response) in
                   switch response.result {
                   case .success(let value):
                       if let JSON = value as? [String: Any] {
                        if response.response?.statusCode == 200{
                           success(JSON as NSDictionary)
                        }else if response.response?.statusCode == 400{
                            let error : NSError = NSError(domain: "invalid user details", code: 400, userInfo: [:])
                            failure(error)
                       }
                    }
                   case .failure(let error):
                       let error : NSError = error as NSError
                       failure(error)
                   }
           }
       }
    
    
    class func requestGETURL(_ strURL: String, params : [String : AnyObject]?,headers : HTTPHeaders?, success:@escaping (AnyObject) -> Void, failure:@escaping (NSError) -> Void) {
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        AF.request(urlwithPercentEscapes!, method: .get, parameters: params, encoding: JSONEncoding.default,headers: headers)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    if let JSON = value as? Any {
                        success(JSON as AnyObject)
                    }
                case .failure(let error):
                    let error : NSError = error as NSError
                    failure(error)
                }
        }
    }
    
    
    class func requestPostWithMultiFormData(_ strURL : String, params : [String : Any]?, headers : HTTPHeaders?, success:@escaping (NSDictionary) -> Void, failure:@escaping (NSError) -> Void){
             let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
             AF.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { response in
              switch response.result {
                 case .success(let value):
                     if let JSON = value as? [String: Any] {
                         success(JSON as NSDictionary)
                     }
                 case .failure(let error):
                     let error : NSError = error as NSError
                     failure(error)
                 }
             }
         }
    class func svprogressHudShow(title:String,view:UIViewController) -> Void
    {
        SVProgressHUD.show(withStatus: title)
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.native)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
        SVProgressHUD.setRingThickness(2)
        DispatchQueue.main.async {
            view.view.isUserInteractionEnabled = false;
        }
    }
    class func svprogressHudDismiss(view: UIViewController) -> Void
    {
        SVProgressHUD.dismiss();
        view.view.isUserInteractionEnabled = true;
    }
}

extension UIViewController {
    func isValidUsername(testStr:String) -> Bool
    {
        let emailRegEx = ".*[^A-Za-z].*"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
