//
//  FullNameViewController.swift
//  WorkForce
//
//  Created by apple on 05/05/22.
//

import UIKit
import IQKeyboardManagerSwift


class FullNameViewController: UIViewController,UITextFieldDelegate {
    
    var userId:Int?
    
    @IBOutlet weak var firstNameView: UIView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameView: UIView!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    var professionalUserDict = SingletonLocalModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        setView()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    }

    
    @IBAction func continueAction(_ sender: UIButton) {
        validation()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popToViewController(ofClass: VerifyNumberViewController.self)

//        self.popViewController(true)
    }
    
    func setView(){
        firstNameView.layer.borderWidth = 1.5
        lastNameView.layer.borderWidth = 1.5
        firstNameView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lastNameView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        firstNameView.layer.borderColor = textField == firstNameTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lastNameView.layer.borderColor = textField == lastNameTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        firstNameView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lastNameView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let firstName = firstNameTF
        let lastName = lastNameTF
        if textField == firstName {
            let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            return alphabet
        }else if textField == lastName {
            let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            return alphabet
        } else {
            return true
        }
    }
    
//   MARK: VALIDATION
    func validation(){
        if (firstNameTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter first name." , okButton: "Ok", controller: self) {
            }
        }
        else if (lastNameTF.text?.trimWhiteSpace.isEmpty)!{
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter last name." , okButton: "Ok", controller: self) {
            }
        }
        else{
            if UserType.userTypeInstance.userLogin == .Coustomer{
                let vc = CoustomerLocationVC()
                self.professionalUserDict.first_name =  firstNameTF.text
                self.professionalUserDict.last_name = lastNameTF.text
                vc.professionalUserDict =  self.professionalUserDict
                self.pushViewController(vc, true)
            }else{
                let vc = DobViewController()
                self.professionalUserDict.first_name =  firstNameTF.text
                self.professionalUserDict.last_name = lastNameTF.text
                vc.professionalUserDict = self.professionalUserDict
                self.pushViewController(vc, true)
            }
        }
    }
    
    
}
