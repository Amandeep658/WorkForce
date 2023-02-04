//
//  VerifyNumberViewController.swift
//  WorkForce
//
//  Created by apple on 04/05/22.
//

import UIKit
import ADCountryPicker
import IQKeyboardManagerSwift
import Alamofire
import FirebaseAuth

class VerifyNumberViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var numberView: UIView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var sendBtnView: UIView!
    @IBOutlet weak var dropDownCountryPickerBtn: UIButton!
    @IBOutlet weak var flagImgView: UIImageView!
    @IBOutlet weak var codeLbl: UILabel!
    
    
    var isCome: Bool?
    var isUserInastance: Bool?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        uiConfigure()
    }
    
//    MARK: API FUNCTIONS
    
    func hitPhoneNumberVerificationApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized().localized(), view: self)
        }
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.loginCheck, params: generatingParameters(), headers: nil){ [self] (response) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            AFWrapperClass.svprogressHudDismiss(view: self)
            let status = response["status"] as? Int ?? 0
            let message = response["message"] as? String ?? ""
            print(status)
            if status == 0 {
                showAlert(message: message, title: AppAlertTitle.appName.rawValue)
            }else if status == 1 {
                let vc = OtpAuthenticationViewController()
                vc.phoneNumber = "\(codeLbl.text ?? "")\(phoneNumberTextField.text ?? "")"
                vc.postCode = codeLbl.text ?? ""
                vc.number = phoneNumberTextField.text ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                let vc = OtpAuthenticationViewController()
                vc.phoneNumber = "\(codeLbl.text ?? "")\(phoneNumberTextField.text ?? "")"
                vc.postCode = codeLbl.text ?? ""
                vc.number = phoneNumberTextField.text ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
    
    //MARK: Generating Login Check Parameters
    func generatingParameters() -> [String:AnyObject] {
        var parameters : [String:AnyObject] = [:]
        parameters["mobile_no"] = phoneNumberTextField.text  as AnyObject
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
    
    
    
//MARK: BUTTON ACTIONS
    @IBAction func backAction(_ sender: Any) {
        self.popViewController(true)
    }
    
    @IBAction func sendAction(_ sender: UIButton) {
        self.validation()
    }
    
    @IBAction func dropDownCountryPickerBtn(_ sender: UIButton) {
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
    
    //    MARK: FUNCTIONS
    func uiConfigure(){
        phoneNumberTextField.delegate = self
        numberView.layer.borderColor = #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)
        imageView.layer.borderColor = #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)
        numberView.layer.borderWidth = 2.0
        imageView.layer.borderWidth = 2.0
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        numberView.layer.borderColor  = textField == phoneNumberTextField ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        imageView.layer.borderColor = textField == phoneNumberTextField ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        numberView.layer.borderColor = #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)
        imageView.layer.borderColor = #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let firstname = phoneNumberTextField
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
    
    func validation(){
        if phoneNumberTextField.text?.trimWhiteSpace == "" {
            self.Alert(message: "ENTER_PHONE_NUMBER".localized())
        }else{
            self.hitPhoneNumberVerificationApi()
        }
    }
    
}
extension VerifyNumberViewController: ADCountryPickerDelegate{
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        _ = picker.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        print("her is code--->>>>",code)
        let image =  picker.getFlag(countryCode: code)
        flagImgView.image = image
        codeLbl.text = dialCode.localized()
    }
}

extension String{
    var trimWhiteSpace: String{
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var decodeEmoji: String{
        let data = self.data(using: String.Encoding.utf8);
        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
        if let str = decodedStr{
            return str as String
        }
        return self
    }
    var isValidEmail: Bool {
        return NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
}
extension UIViewController{
    func Alert(message:String){
        let clr = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let attributedString = NSAttributedString(string: "U2 CONNECT", attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor : clr
        ])
        let Alert = UIAlertController.init(title: "U2 CONNECT", message: message.localized(), preferredStyle: .alert)
        Alert.setValue(attributedString, forKey: "attributedTitle")
        let ok = UIAlertAction.init(title: "Ok", style: .default, handler: {
            Action in
        })
        Alert.addAction(ok)
        Alert.view.tintColor = clr
        self.present(Alert, animated: true, completion: nil)
    }
}

// MARK: - Gradient
extension CAGradientLayer {
 enum Point {
     case topLeft
     case centerLeft
     case bottomLeft
     case topCenter
     case center
     case bottomCenter
     case topRight
     case centerRight
     case bottomRight
     var point: CGPoint {
         switch self {
         case .topLeft:
             return CGPoint(x: -0.55, y: 0)
         case .centerLeft:
             return CGPoint(x: 0, y: 0.5)
         case .bottomLeft:
             return CGPoint(x: 0, y: 1.0)
         case .topCenter:
             return CGPoint(x: 0.5, y: 0)
         case .center:
             return CGPoint(x: 0.5, y: 0.5)
         case .bottomCenter:
             return CGPoint(x: 0.5, y: 1.0)
         case .topRight:
             return CGPoint(x: 1.0, y: 0.0)
         case .centerRight:
             return CGPoint(x: 1.0, y: 0.5)
         case .bottomRight:
             return CGPoint(x: 0.5, y: 1.5)
         }
     }
 }
 convenience init(start: Point, end: Point, colors: [CGColor], type: CAGradientLayerType) {
     self.init()
     self.startPoint = start.point
     self.endPoint = end.point
     self.colors = colors
     self.locations = (0..<colors.count).map(NSNumber.init)
     self.type = type
 }
}

extension String {
 func localized() -> String{
     if Locale.current.languageCode == "es" {
         let path = Bundle.main.path(forResource: "es", ofType: "lproj")
         let bundle = Bundle(path: path!)
         return NSLocalizedString(self, tableName: nil, bundle: bundle!,value: "", comment: "")
     }else if Locale.current.languageCode == "pt"{
         let path = Bundle.main.path(forResource: "pt-PT", ofType: "lproj")
         let bundle = Bundle(path: path!)
         return NSLocalizedString(self, tableName: nil, bundle: bundle!,value: "", comment: "")
     }else{
         let path = Bundle.main.path(forResource: "en", ofType: "lproj")
         let bundle = Bundle(path: path!)
         return NSLocalizedString(self, tableName: nil, bundle: bundle!,value: "", comment: "")
     }
//     let path = Bundle.main.path(forResource: Locale.current.languageCode, ofType: "lproj")
//     let bundle = Bundle(path: path!)
//     return NSLocalizedString(self, tableName: nil, bundle: bundle!,value: "", comment: "")
   }
 }
