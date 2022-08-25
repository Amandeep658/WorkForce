//
//  PhoneNumberVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 24/08/22.
//

import UIKit
import Alamofire
import SDWebImage

class PhoneNumberVC: UIViewController {
    
//    MARK: OUTLETS
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var mobileNumberView: UIView!
    @IBOutlet weak var mobileNumberTF: UITextField!
    @IBOutlet weak var continueBtn: UIButton!
    
    var OTPNumber = ""
    var emailUpdated = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        print("********>>>>>>>", OTPNumber)
        print("********>>>>>>>", emailUpdated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func continueBtn(_ sender: UIButton) {
        if mobileNumberTF.text == "" {
            showAlert(message: "Please enter mobile number.", title: AppAlertTitle.appName.rawValue)
        }else{
            hitVerifyPhoneNumberApi()
        }
    }
    
    func hitVerifyPhoneNumberApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading..", view: self)
        }
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.updateMobileNumber, params: getUpdatePhoneGeneratingParameters(), headers: nil) {  [self] (response) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            AFWrapperClass.svprogressHudDismiss(view: self)
            let authToekn = response["auth_token"] as? String ?? ""
            AppDefaults.token = authToekn
            let status = response["status"] as? Int ?? 0
            let message = response["message"] as? String ?? ""
            print(status)
            if status == 0 {
                showAlert(message: message, title: AppAlertTitle.appName.rawValue)
            }else if status == 1 {
                if  UserType.userTypeInstance.userLogin == .Bussiness {
                        AppDefaults.checkLogin = true
                        let vc = TabBarVC()
                        self.pushViewController(vc, true)
                }else if UserType.userTypeInstance.userLogin == .Professional{
                        AppDefaults.checkLogin = true
                        let vc = TabBarVC()
                        self.pushViewController(vc, true)
                }else if UserType.userTypeInstance.userLogin == .Coustomer{
                        AppDefaults.checkLogin = true
                        let vc = TabBarVC()
                        self.pushViewController(vc, true)
                }
            }else{
                print("its worked on")
            }
        } failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }

    }
    
    //MARK: Generating Login Check Parameters
    func getUpdatePhoneGeneratingParameters() -> [String:AnyObject] {
        var parameters : [String:AnyObject] = [:]
        parameters["email"] = emailUpdated as AnyObject
        parameters["code"] = OTPNumber as AnyObject
        parameters["mobile_no"] = mobileNumberTF.text as AnyObject
        if UserType.userTypeInstance.userLogin == .Bussiness{
            parameters["type"] = "1" as AnyObject
        }else if UserType.userTypeInstance.userLogin == .Professional{
            parameters["type"] = "2" as AnyObject
        }else if UserType.userTypeInstance.userLogin == .Coustomer{
            parameters["type"] = "3" as AnyObject
        }
        parameters["deviceType"] = "1"  as AnyObject
        parameters["deviceToken"] = AppDefaults.deviceToken as AnyObject?
        print(parameters)
        return parameters
    }
 
}
