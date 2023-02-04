//
//  EnterEmailVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 24/08/22.
//

import UIKit

class EnterEmailVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var continueBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        uiUpdate()
    }
    
    //    MARK: UI CONFIGURE
    func uiUpdate(){
        emailView.layer.borderWidth = 1.5
        emailView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        emailTF.delegate = self
    }
    
    //    MARK: TEXT FIELD DELEGATES
    func textFieldDidBeginEditing(_ textField: UITextField) {
        emailView.layer.borderColor = textField == emailTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        emailView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//    MARK: VALIDATION
    func validation(){
        if emailTF.text == "" {
            showAlert(message: "ENTER_EMAIL".localized(), title: AppAlertTitle.appName.rawValue)
        }else if emailTF.text!.isValidEmail == false{
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "ENTER_VALID_EMAIL".localized() , okButton: "Ok", controller: self) {}
        }else{
            if UserType.userTypeInstance.userLogin == .Bussiness{
                hitRecoverEmailApi()
            }else if UserType.userTypeInstance.userLogin == .Professional{
                hitRecoverEmailApi()
            }else{
                hitRecoverEmailApi()
            }
        }
    }
    
    //    MARK: BUTTON ACTION
    @IBAction func backBtn(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func continueBtn(_ sender: UIButton) {
        validation()
    }
    
    
// MARK: HIT RECOVER EMAIL API
    func hitRecoverEmailApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.getRecoverEmail, params: getRecoverEmailAccountgeneratingParameters(), headers: nil) { [self] (response) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            AFWrapperClass.svprogressHudDismiss(view: self)
            let status = response["status"] as? Int ?? 0
            let message = response["message"] as? String ?? ""
            print(status)
            if status == 0 {
                showAlert(message: message, title: AppAlertTitle.appName.rawValue)
            }else if status == 1 {
                let recoverEmailOTP = RecoverVerifyScreenVC()
                recoverEmailOTP.enterEmail = emailTF.text ?? ""
                self.pushViewController(recoverEmailOTP, true)
            }
        } failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }

    }
    
    //MARK: Generating Login Check Parameters
    func getRecoverEmailAccountgeneratingParameters() -> [String:AnyObject] {
        var parameters : [String:AnyObject] = [:]
        parameters["email"] = emailTF.text  as AnyObject
        if Locale.current.languageCode == "es"{
            parameters["is_language"] = "1"  as AnyObject
        }else if Locale.current.languageCode == "pt"{
            parameters["is_language"] = "2"  as AnyObject
        }else if Locale.current.languageCode == "en"{
            parameters["is_language"] = "0"  as AnyObject
        }
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
extension String {
    func itisValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
