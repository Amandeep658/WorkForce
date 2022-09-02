//
//  PhoneNumberVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 24/08/22.
//

import UIKit
import Alamofire
import ADCountryPicker
import SDWebImage

class PhoneNumberVC: UIViewController,UITextFieldDelegate {
    
//    MARK: OUTLETS
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var postView: UIView!
    @IBOutlet weak var NumberView: UIView!
    @IBOutlet weak var flagImg: UIImageView!
    @IBOutlet weak var dropdownBtn: UIButton!
    @IBOutlet weak var postCodeLbl: UILabel!
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
        uiConfigure()
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
    @IBAction func dropDownBtn(_ sender: UIButton) {
        let picker = ADCountryPicker(style: .grouped)
        picker.delegate = self
        picker.showCallingCodes = true
        picker.didSelectCountryClosure = { name, code in
            _ = picker.navigationController?.popToRootViewController(animated: true)
            print(code)
        }
        let pickerNavigationController = UINavigationController(rootViewController: picker)
        self.present(pickerNavigationController, animated: true, completion: nil)
    }
    
    func uiConfigure(){
        mobileNumberTF.delegate = self
        NumberView.layer.borderColor = #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)
        postView.layer.borderColor = #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)
        NumberView.layer.borderWidth = 2.0
        postView.layer.borderWidth = 2.0
    }
    
//    MARK: TEXTFIELD DELEGATES
    func textFieldDidBeginEditing(_ textField: UITextField) {
        NumberView.layer.borderColor  = textField == mobileNumberTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        postView.layer.borderColor = textField == mobileNumberTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        NumberView.layer.borderColor = #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)
        postView.layer.borderColor = #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let firstname = mobileNumberTF
        if textField == firstname {
            let allowedCharacters = "1234567890"
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            return alphabet
        }else{
            return true
        }
    }
    
//    MARK: HIT VERIFY PHONE NUMBER
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
        parameters["mobile_no"] = "\(postCodeLbl.text ?? "")\(mobileNumberTF.text ?? "")" as AnyObject
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
extension PhoneNumberVC: ADCountryPickerDelegate{
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        _ = picker.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        print("her is code--->>>>",code)
        let image =  picker.getFlag(countryCode: code)
        flagImg.image = image
        postCodeLbl.text = dialCode
        let xx =  picker.getCountryName(countryCode: code)
        let xxx =  picker.getDialCode(countryCode: code)
    }
}
