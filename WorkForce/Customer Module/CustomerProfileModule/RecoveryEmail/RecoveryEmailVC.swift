//
//  RecoveryEmailVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 16/08/22.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire

class RecoveryEmailVC: UIViewController,UITextFieldDelegate {

//    MARK: OUTLETS
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var continueBtn: UIButton!
    
    var mobileNumber = ""
    var isFromAccount: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        uiUpdate()
    }
    
//    MARK: UI_UPDATES
    func uiUpdate(){
        emailTF.delegate = self
        emailView.layer.borderWidth =  1.5
        emailView.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func continueBtn(_ sender: UIButton) {
        emailValidation()
    }
    
//    MARK: TEXTFIELD DELEGATES
    func textFieldDidBeginEditing(_ textField: UITextField) {
        emailView.layer.borderColor = textField == emailTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        emailView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//    MARK: VALIDATIONS
    func emailValidation(){
        if (emailTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter email address." , okButton: "Ok", controller: self) {
            }
        }else if emailTF.text!.isValidEmail == false{
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter vaild email." , okButton: "Ok", controller: self) {}
        }else{
            self.hitRecoveryEmailAPI()
        }
    }
    
//    MARK: HIT RECOVERY EMAIL API
    func hitRecoveryEmailAPI(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading..", view: self)
        }
        let AToken = AppDefaults.token ?? ""
        print(AToken)
        let headers: HTTPHeaders = ["Token": AToken]
        var param = [String:Any]()
        if UserType.userTypeInstance.userLogin == .Bussiness{
            param = ["user_id": UserDefaults.standard.string(forKey: "uID") ?? "","email":emailTF.text ?? "", "mobile_no": mobileNumber,"type":"1"] as [String : Any]
        }else if UserType.userTypeInstance.userLogin == .Professional{
             param = ["user_id": UserDefaults.standard.string(forKey: "uID") ?? "","email":emailTF.text ?? "", "mobile_no": mobileNumber,"type":"2"] as [String : Any]
        }else{
            param = ["user_id": UserDefaults.standard.string(forKey: "uID") ?? "","email":emailTF.text ?? "", "mobile_no": mobileNumber,"type":"3"] as [String : Any]
        }
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.ResentVerficationEmail, params: param, headers: headers) { (response) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            let status = response["status"] as? Int ?? 0
            let logMessage = response["message"] as? String ?? ""
            print(status)
            if status == 1 {
                self.showAlert(message: logMessage, title: AppAlertTitle.appName.rawValue) {
                    if UserType.userTypeInstance.userLogin == .Bussiness{
                        print("its Business")
                        let vc = EmailOtpVC()
                        vc.isFromAccount = self.isFromAccount
                        self.pushViewController(vc, true)
                    }else if UserType.userTypeInstance.userLogin == .Professional{
                        print("its Professional")
                        let vc = EmailOtpVC()
                        vc.isFromAccount = self.isFromAccount
                        self.pushViewController(vc, true)
                    }else{
                        print("its customer")
                        let vc = EmailOtpVC()
                        vc.isFromAccount = self.isFromAccount
                        self.pushViewController(vc, true)
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
