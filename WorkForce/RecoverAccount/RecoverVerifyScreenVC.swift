//
//  RecoverVerifyScreenVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 25/08/22.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire

class RecoverVerifyScreenVC: UIViewController,UITextFieldDelegate  {
    
    //    MARK: OUTLETS
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var firstTF: UITextField!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var secondTF: UITextField!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var thirdTF: UITextField!
    @IBOutlet weak var fourthView: UIView!
    @IBOutlet weak var fourthTF: UITextField!
    @IBOutlet weak var fifthView: UIView!
    @IBOutlet weak var fifthTF: UITextField!
    @IBOutlet weak var sixthView: UIView!
    @IBOutlet weak var sixthTF: UITextField!
    
    var verifyOTP = ""
    var enterEmail = ""
    let customerVC = CoustomerProfileVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uiConfigure()
    }
    
    //    MARK: UI_CONFIGURE
    func uiConfigure(){
        self.firstTF.delegate = self
        self.secondTF.delegate = self
        self.thirdTF.delegate = self
        self.fourthTF.delegate = self
        self.fifthTF.delegate = self
        self.sixthTF.delegate = self
    }
    
    //    MARK: TEXTFIELD_DELEGATES
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count > 0 {
            textField.text = (string as NSString).substring(to: 1)
            if textField == firstTF {
                secondTF.becomeFirstResponder()
            } else if textField == secondTF {
                thirdTF.becomeFirstResponder()
            }else if textField == thirdTF {
                fourthTF.becomeFirstResponder()
            }else if textField == fourthTF {
                fifthTF.becomeFirstResponder()
            }else if textField == fifthTF {
                sixthTF.becomeFirstResponder()
            }else if textField == sixthTF {
                self.dismisKeyboard()
            }
        }
        return true
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text == ""{
            switch textField{
            case firstTF: break
            case secondTF:
                firstTF.becomeFirstResponder()
            case thirdTF:
                secondTF.becomeFirstResponder()
            case fourthTF:
                thirdTF.becomeFirstResponder()
            case fifthTF:
                fourthTF.becomeFirstResponder()
            case sixthTF:
                fifthTF.becomeFirstResponder()
            default:
                break
            }
        }
        else{
            switch textField{
            case firstTF:
                secondTF.becomeFirstResponder()
            case secondTF:
                thirdTF.becomeFirstResponder()
            case thirdTF:
                fourthTF.becomeFirstResponder()
            case fourthTF:
                fifthTF.becomeFirstResponder()
            case fifthTF:
                sixthTF.becomeFirstResponder()
            case sixthTF:
                sixthTF.becomeFirstResponder()
            default:
                break
            }
        }
    }
    
    func dismisKeyboard(){
        self.verifyOTP = "\(self.firstTF.text ?? "")\(self.secondTF.text ?? "")\(self.thirdTF.text ?? "")\(self.fourthTF.text ?? "")\(self.fifthTF.text ?? "")\(self.sixthTF.text ?? "")"
        print(self.verifyOTP)
        self.view.endEditing(true)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func submitBtn(_ sender: UIButton) {
        if UserType.userTypeInstance.userLogin == .Bussiness{
            self.hitVerifyOTPNumberApi()
        }else if UserType.userTypeInstance.userLogin == .Professional{
            self.hitVerifyOTPNumberApi()
        }else{
            self.hitVerifyOTPNumberApi()
        }
    }
    
//    MARK: VERIFY OTP
    func hitVerifyOTPNumberApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.updateMobileNumber, params: getOtpverifyGeneratingParameters(), headers: nil) {  [self] (response) in
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
                    let vc = PhoneNumberVC()
                    vc.OTPNumber = verifyOTP
                    vc.emailUpdated = enterEmail
                    self.pushViewController(vc, true)
                }else if UserType.userTypeInstance.userLogin == .Professional{
                    let vc = PhoneNumberVC()
                    vc.OTPNumber = verifyOTP
                    vc.emailUpdated = enterEmail
                    self.pushViewController(vc, true)
                }else if UserType.userTypeInstance.userLogin == .Coustomer{
                    let vc = PhoneNumberVC()
                    vc.OTPNumber = verifyOTP
                    vc.emailUpdated = enterEmail
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
    func getOtpverifyGeneratingParameters() -> [String:AnyObject] {
        var parameters : [String:AnyObject] = [:]
        parameters["email"] = enterEmail as AnyObject
        parameters["code"] = verifyOTP as AnyObject
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
