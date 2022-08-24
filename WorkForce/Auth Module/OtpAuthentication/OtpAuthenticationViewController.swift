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

class OtpAuthenticationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var firstTF: UITextField!
    @IBOutlet weak var secondTF: UITextField!
    @IBOutlet weak var thirdTf: UITextField!
    @IBOutlet weak var fourthTF: UITextField!
    @IBOutlet weak var fifthTF: UITextField!
    @IBOutlet weak var sixthTF: UITextField!
    @IBOutlet weak var resendOTPBtn: UIButton!
    @IBOutlet weak var authenticationNumberTF: UILabel!
    
    
    var ifCome:Bool?
    var phoneNumber:String?
    var postCode:String?
    var number:String?
    var verifyOTP = ""
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
        AFWrapperClass.svprogressHudShow(title: "Loading", view: self)
        Auth.auth().settings?.isAppVerificationDisabledForTesting = false
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber ?? "" , uiDelegate: nil) { [self] verificationID, error in
            print(phoneNumber ?? "")
            print(verificationID)
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
            AFWrapperClass.svprogressHudShow(title: "Loading", view:self)
        }
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.signUpCheck, params: signUpParameters(), headers: nil){ [self] (response) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            let status = response["status"] as? Int ?? 0
            let verifyMessage = response["message"] as? String ?? ""
            let userID = response["user_id"] as? String ?? ""
            print(" before UserId ***********=== >>>>", userID )
            UserDefaults.standard.set(userID, forKey: "uID")
            UserDefaults.standard.synchronize()
            let userUdid = UserDefaults.standard.value(forKey: "uID")
            print("after UserId ***********=== >>>>", userUdid )
            self.professionalUserDict.userId = userID
            let authToekn = response["auth_token"] as? String ?? ""
            AppDefaults.token = authToekn
            let loginStatus = response["login_status"] as? Int ?? 0
            if status == 1{
                if  UserType.userTypeInstance.userLogin == .Bussiness {
                    if loginStatus == 0{
                        let vc = CompanyDetailsViewController()
                        self.pushViewController(vc, true)
                    }else{
                        AppDefaults.checkLogin = true
                        let vc = TabBarVC()
                        self.pushViewController(vc, true)
                    }
                }else if UserType.userTypeInstance.userLogin == .Professional{
                    if loginStatus == 0{
                        let vc = FullNameViewController()
                        vc.professionalUserDict = self.professionalUserDict
                        self.pushViewController(vc, true)
                    }else{
                        AppDefaults.checkLogin = true
                        let vc = TabBarVC()
                        self.pushViewController(vc, true)
                    }
                }else if UserType.userTypeInstance.userLogin == .Coustomer{
                    if loginStatus == 0{
                        let vc = FullNameViewController()
                        vc.professionalUserDict = self.professionalUserDict
                        self.pushViewController(vc, true)
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
        firstTF.delegate = self
        secondTF.delegate = self
        thirdTf.delegate = self
        fourthTF.delegate = self
        fifthTF.delegate = self
        sixthTF.delegate = self
        verifyBtn.layer.cornerRadius = 5
        authenticationNumberTF.text = "An authentication code has been sent to (\(postCode ?? ""))\(number ?? "")"
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
                dismisKeyboard()
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
//            if self.verifyOTP == "123456"{
//                self.hitSignUpApi()
//            }else{
                let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
                print(verificationID)
                let credential = PhoneAuthProvider.provider().credential(
                    withVerificationID: verificationID ?? "0",
                    verificationCode: verifyOTP)
                print(verifyOTP)
                Auth.auth().signIn(with: credential) { (success, error) in
                    if error == nil{
                        print(success ?? "")
                        self.hitSignUpApi()
                    }else{
                        alert(AppAlertTitle.appName.rawValue, message: "Invalid OTP please enter again", view: self)
                    }
                }
//            }
        }else if UserType.userTypeInstance.userLogin == .Professional{
//            if self.verifyOTP == "123456"{
//                self.hitSignUpApi()
//            }
//            else{
                let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
                print(verificationID)
                let credential = PhoneAuthProvider.provider().credential(
                    withVerificationID: verificationID ?? "0",
                    verificationCode: verifyOTP)
                print(verifyOTP)
                Auth.auth().signIn(with: credential) { (success, error) in
                    if error == nil{
                        print(success ?? "")
                        self.hitSignUpApi()
                    }else{
                        alert(AppAlertTitle.appName.rawValue, message: "Invalid OTP please enter again", view: self)
                    }
                }
//            }
        }else{
//            if self.verifyOTP == "123456"{
//                self.hitSignUpApi()
//            }
//            else{
                let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
                print(verificationID)
                let credential = PhoneAuthProvider.provider().credential(
                    withVerificationID: verificationID ?? "0",
                    verificationCode: verifyOTP)
                print(verifyOTP)
                Auth.auth().signIn(with: credential) { (success, error) in
                    if error == nil{
                        print(success ?? "")
                        self.hitSignUpApi()
                    }else{
                        alert(AppAlertTitle.appName.rawValue, message: "Invalid OTP please enter again", view: self)
                    }
                }
//            }
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
