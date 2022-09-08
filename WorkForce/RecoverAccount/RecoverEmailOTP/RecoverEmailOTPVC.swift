//
//  RecoverEmailOTPVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 24/08/22.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift

class RecoverEmailOTPVC: UIViewController,UITextFieldDelegate {

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
        let chracters = string.map({ String($0)})
        if chracters.count == 6{
            textField.text = (string as NSString).substring(to: 1)
            self.firstTF.text = chracters[0]
            self.secondTF.text = chracters[1]
            self.thirdTF.text = chracters[2]
            self.fourthTF.text = chracters[3]
            self.fifthTF.text = chracters[4]
            self.sixthTF.text = chracters[5]
            return false
        }
        else if string.count > 0 {
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
                dismisKeyboard()
            }
            return true
        }
        else{
            return false
        }
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
            self.hitVerifyEmailAPI()
        }else if UserType.userTypeInstance.userLogin == .Professional{
            self.hitVerifyEmailAPI()
        }else{
            self.hitVerifyEmailAPI()
        }
    }
    
    //    MARK: HIT VERIFY OTP API
    func hitVerifyEmailAPI(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        let AToken = AppDefaults.token ?? ""
        print(AToken)
        let headers: HTTPHeaders = ["Token": AToken]
        let parameter = ["user_id": UserDefaults.standard.string(forKey: "uID") ?? "","code":verifyOTP] as [String : Any]
        print(parameter)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.verify, params: parameter, headers: headers) { (response) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            let status = response["status"] as? Int ?? 0
            let logMessage = response["message"] as? String ?? ""
            print(status)
            if status == 1 {
                self.showAlert(message: logMessage, title: AppAlertTitle.appName.rawValue) {
                    if UserType.userTypeInstance.userLogin == .Bussiness{
                        let showpop = VerifyEmailVC()
                        showpop.isModalInPresentation = true
                        self.present(showpop, animated: true)
                    }else if UserType.userTypeInstance.userLogin == .Professional {
                        let showpop = VerifyEmailVC()
                        showpop.isModalInPresentation = true
                        self.present(showpop, animated: true)
                    }else{
                        let showpop = VerifyEmailVC()
                        showpop.isModalInPresentation = true
                        self.present(showpop, animated: true)
                    }
                }
            }else{
                self.Alert(message:logMessage )
            }
        } failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
        
    }
    

}
//if string.count > 0 {
//    textField.text = (string as NSString).substring(to: 1)
//    if textField == firstTF {
//        secondTF.becomeFirstResponder()
//    } else if textField == secondTF {
//        thirdTF.becomeFirstResponder()
//    }else if textField == thirdTF {
//        fourthTF.becomeFirstResponder()
//    }else if textField == fourthTF {
//        fifthTF.becomeFirstResponder()
//    }else if textField == fifthTF {
//        sixthTF.becomeFirstResponder()
//    }else if textField == sixthTF {
//        self.dismisKeyboard()
//    }
//}
//return true
