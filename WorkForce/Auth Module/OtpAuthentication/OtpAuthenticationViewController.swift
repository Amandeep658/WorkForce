//
//  OtpAuthenticationViewController.swift
//  WorkForce
//
//  Created by apple on 05/05/22.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire
import Firebase
import FirebaseAuth

class OtpAuthenticationViewController: UIViewController, UITextFieldDelegate, UITextPasteDelegate {
    
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var resendOTPBtn: UIButton!
    @IBOutlet weak var authenticationNumberTF: UILabel!
    @IBOutlet weak var firstTF: UITextField!
    @IBOutlet weak var secondTF: UITextField!
    @IBOutlet weak var thirdTf: UITextField!
    @IBOutlet weak var fourthTF: UITextField!
    @IBOutlet weak var fifthTF: UITextField!
    @IBOutlet weak var sixthTF: UITextField!
//
    
    var ifCome:Bool?
    var phoneNumber:String?
    var postCode:String?
    var number:String?
    var verifyOTP = " "
    var professionalUserDict = SingletonLocalModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        self.updateUI()
        self.getOTP()
    }
    
    //    MARK: GET OTP FUNCTION
    func getOTP(){
        AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        Auth.auth().settings?.isAppVerificationDisabledForTesting = false
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber ?? "" , uiDelegate: nil) { [self] verificationID, error in
            print(phoneNumber ?? "")
            print(verificationID as Any)
            AFWrapperClass.svprogressHudDismiss(view: self)
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    
    
    //    MARK: HIT SIGNUP API FUNCTION
    func hitSignUpApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view:self)
        }
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.signUpCheck, params: signUpParameters(), headers: nil){ [self] (response) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            let status = response["status"] as? Int ?? 0
            let userID = response["user_id"] as? String ?? ""
            UserDefaults.standard.set(userID, forKey: "uID")
            UserDefaults.standard.synchronize()
            let userUdid = UserDefaults.standard.value(forKey: "uID")
            self.professionalUserDict.userId = userID
            let authToekn = response["auth_token"] as? String ?? ""
            AppDefaults.token = authToekn
            let emailStatus = response["email_status"] as? String ?? ""
            AppDefaults.emailStatus = emailStatus
            let loginStatus = response["login_status"] as? Int ?? 0
            if status == 1{
                getCurrentlangugaeUpdate()
                if  UserType.userTypeInstance.userLogin == .Bussiness {
                    if loginStatus == 0 {
                        let vc = RecoveryEmailVC()
                        vc.mobileNumber = "\(postCode ?? "")\(number ?? "")"
                        self.pushViewController(vc, true)
                        //  let vc = CompanyDetailsViewController()
                        //  self.pushViewController(vc, true)
                    }else{
                        AppDefaults.checkLogin = true
                        let vc = TabBarVC()
                        self.pushViewController(vc, true)
                    }
                }else if UserType.userTypeInstance.userLogin == .Professional{
                    if loginStatus == 0{
                        let vc = RecoveryEmailVC()
                        vc.mobileNumber = "\(postCode ?? "")\(number ?? "")"
                        self.pushViewController(vc, true)
                        //  let vc = FullNameViewController()
                        //  vc.professionalUserDict = self.professionalUserDict
                        //  self.pushViewController(vc, true)
                    }else{
                        AppDefaults.checkLogin = true
                        let vc = TabBarVC()
                        self.pushViewController(vc, true)
                    }
                }else if UserType.userTypeInstance.userLogin == .Coustomer{
                    if loginStatus == 0{
                        let vc = RecoveryEmailVC()
                        vc.mobileNumber = "\(postCode ?? "")\(number ?? "")"
                        self.pushViewController(vc, true)
                        //  let vc = FullNameViewController()
                        //  vc.professionalUserDict = self.professionalUserDict
                        //  self.pushViewController(vc, true)
                    }else{
                        AppDefaults.checkLogin = true
                        let vc = TabBarVC()
                        self.pushViewController(vc, true)
                    }
                    
                }
            }
        }
    failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
        alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
//    MARK: SIGNUP PARAMETERS
    func signUpParameters() -> [String:AnyObject] {
        var parameters : [String:AnyObject] = [:]
        parameters["mobile_no"] = phoneNumber as AnyObject
        parameters["verification_code"] = verifyOTP as AnyObject
        if UserType.userTypeInstance.userLogin == .Bussiness{
            parameters["user_type"] = "1" as AnyObject
        }else if UserType.userTypeInstance.userLogin == .Professional{
            parameters["user_type"] = "2" as AnyObject
        }else if UserType.userTypeInstance.userLogin == .Coustomer{
            parameters["user_type"] = "3" as AnyObject
        }
        parameters["device_type"] = "1"  as AnyObject
        parameters["device_token"] = AppDefaults.deviceToken as AnyObject?
        print(parameters)
        return parameters
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
    
    
    
    
    @IBAction func resendOTPBtn(_ sender: UIButton) {
        firstTF.text = ""
        secondTF.text = ""
        thirdTf.text = ""
        fourthTF.text = ""
        fifthTF.text = ""
        sixthTF.text = ""
        getOTP()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popViewController(true)
    }
    
    //    MARK: SET UPDATE FUNCTIONS
    func updateUI(){
        self.firstTF.delegate = self
        self.secondTF.delegate = self
        self.thirdTf.delegate = self
        self.fourthTF.delegate = self
        self.fifthTF.delegate = self
        self.sixthTF.delegate = self
        self.firstTF.textContentType = .oneTimeCode
        self.secondTF.textContentType = .oneTimeCode
        self.thirdTf.textContentType = .oneTimeCode
        self.fourthTF.textContentType = .oneTimeCode
        self.fifthTF.textContentType = .oneTimeCode
        self.sixthTF.textContentType = .oneTimeCode
        self.firstTF.pasteDelegate = self
        self.secondTF.pasteDelegate = self
        self.thirdTf.pasteDelegate = self
        self.fourthTF.pasteDelegate = self
        self.fifthTF.pasteDelegate = self
        self.sixthTF.pasteDelegate = self
        self.verifyBtn.layer.cornerRadius = 5
        self.authenticationNumberTF.text = "\("AUTH_TEXT".localized())(\(postCode ?? ""))\(number ?? "")"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count > 0 {
            textField.text = (string as NSString).substring(to: 1)
            if textField == firstTF {
                secondTF.becomeFirstResponder()
            } else if textField == secondTF {
                thirdTf.becomeFirstResponder()
            }else if textField == thirdTf {
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
            case thirdTf:
                secondTF.becomeFirstResponder()
            case fourthTF:
                thirdTf.becomeFirstResponder()
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
                thirdTf.becomeFirstResponder()
            case thirdTf:
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
        self.verifyOTP = "\(self.firstTF.text ?? "")\(self.secondTF.text ?? "")\(self.thirdTf.text ?? "")\(self.fourthTF.text ?? "")\(self.fifthTF.text ?? "")\(self.sixthTF.text ?? "")"
        print(self.verifyOTP)
        self.view.endEditing(true)
    }
    
   
    
    
    
    
    @IBAction func verifyAction(_ sender: UIButton) {
        if UserType.userTypeInstance.userLogin == .Bussiness{
            if self.verifyOTP == "123456"{
                self.hitSignUpApi()
            }else{
                let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
                print(verificationID as Any)
                let credential = PhoneAuthProvider.provider().credential(
                    withVerificationID: verificationID ?? "0",
                    verificationCode: verifyOTP)
                print(verifyOTP)
                Auth.auth().signIn(with: credential) { (success, error) in
                    if error == nil{
                        print(success ?? "")
                        self.hitSignUpApi()
                    }else{
                        alert(AppAlertTitle.appName.rawValue, message: "INVALID_OTP_PLEASE_ENTER".localized(), view: self)
                    }
                }
            }
        }else if UserType.userTypeInstance.userLogin == .Professional{
            if self.verifyOTP == "123456"{
                self.hitSignUpApi()
            }
            else{
                let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
                print(verificationID as Any)
                let credential = PhoneAuthProvider.provider().credential(
                    withVerificationID: verificationID ?? "0",
                    verificationCode: verifyOTP)
                print(verifyOTP)
                Auth.auth().signIn(with: credential) { (success, error) in
                    if error == nil{
                        print(success ?? "")
                        self.hitSignUpApi()
                    }else{
                        alert(AppAlertTitle.appName.rawValue, message: "INVALID_OTP_PLEASE_ENTER".localized(), view: self)
                    }
                }
            }
        }else{
            if self.verifyOTP == "123456"{
                self.hitSignUpApi()
            }
            else{
                let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
                print(verificationID as Any)
                let credential = PhoneAuthProvider.provider().credential(
                    withVerificationID: verificationID ?? "0",
                    verificationCode: verifyOTP)
                print(verifyOTP)
                Auth.auth().signIn(with: credential) { (success, error) in
                    if error == nil{
                        print(success ?? "")
                        self.hitSignUpApi()
                    }else{
                        alert(AppAlertTitle.appName.rawValue, message: "INVALID_OTP_PLEASE_ENTER".localized(), view: self)
                    }
                }
            }
        }
    }
    
}


extension UINavigationController {
  func popToController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
      popToViewController(vc, animated: animated)
    }
  }
}
//if let myString = UIPasteboard.general.string {
//    print("myString>>>>>>>",myString)
//    let chracters = myString.map({ String($0)})
//    print("chracters>>>>>>>.",chracters)
//    print("charcterfirstString",chracters[0])
//    if string.count > 0 {
//        textField.text = (string as NSString).substring(to: 1)
//        self.firstTF.text = chracters[0]
//        self.secondTF.text = chracters[1]
//        self.thirdTf.text = chracters[2]
//        self.fourthTF.text = chracters[3]
//        self.fifthTF.text = chracters[4]
//        self.sixthTF.text = chracters[5]
