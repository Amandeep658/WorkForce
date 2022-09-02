//
//  ProfessionalRateViewController.swift
//  WorkForce
//
//  Created by Dharmani Apps on 09/06/22.
//

import UIKit

class ProfessionalRateViewController: UIViewController ,UITextFieldDelegate {
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var firstTF: UITextField!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var secondTF: UITextField!
    @IBOutlet weak var dayHrView: UIView!
    @IBOutlet weak var bachBtn: UIButton!
    @IBOutlet weak var hourBtn: UIButton!
    @IBOutlet weak var dayBtn: UIButton!
    @IBOutlet weak var headerbl: UILabel!
    @IBOutlet weak var continueBtn: ActualGradientButton!
    
    var professionalUserDict = SingletonLocalModel()
    
    var isselect:Bool = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setView()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserType.userTypeInstance.userLogin == .Bussiness{
            headerbl.text = "Professionals rate from"
        }else if UserType.userTypeInstance.userLogin == .Professional{
            headerbl.text = "Professionals rate from"
        }else{
            headerbl.text = "Rate"
        }
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    }
    
    @IBAction func hourAction(_ sender: UIButton) {
        isselect = true
        if isselect {
            self.professionalUserDict.rate_type = "Per Hour"
            hourBtn.setTitleColor(UIColor(red: 58, green: 148, blue: 184), for: .normal)
            dayBtn.setTitleColor(.gray, for: .normal)
        }
    }
    @IBAction func dayAction(_ sender: UIButton) {
        isselect = false
        if !isselect  {
            self.professionalUserDict.rate_type = "Per Day"
            dayBtn.setTitleColor(UIColor(red: 58, green: 148, blue: 184), for: .normal)
            hourBtn.setTitleColor(.gray, for: .normal)
        }
    }
    @IBAction func continueAction(_ sender: UIButton) {
        validationFields()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popViewController(true)
    }
    
    
    
    func setView(){
        firstTF.delegate = self
        secondTF.delegate = self
        firstView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        secondView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        dayHrView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        dayBtn.setTitleColor(.gray, for: .normal)
        hourBtn.setTitleColor(.gray, for: .normal)
        self.hourBtn.isEnabled = false
        self.dayBtn.isEnabled = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == firstTF){
            firstView.layer.borderColor = #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)
        }else if(textField == secondTF){
            secondView.layer.borderColor = #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)
        }else{
            dayHrView.layer.borderColor = #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == firstTF){
            firstView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }else if(textField == secondTF){
            secondView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }else{
            dayHrView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        if firstTF.text != "" || secondTF.text != "" {
            self.hourBtn.isEnabled = true
            self.dayBtn.isEnabled = true
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let firstName = firstTF
        let second = secondTF
        if textField == firstName {
            let allowedCharacters = "1234567890"
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            return alphabet
        } else if textField ==  second {
            let allowedCharacters = "1234567890"
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            return alphabet
        }else {
            return true
        }
    }
    
    
//    MARK: VALIDATIONS
    func validationFields(){
        if firstTF.text != "" {
            if secondTF.text != "" || professionalUserDict.rate_type == ""{
                self.hourBtn.isEnabled = true
                self.dayBtn.isEnabled = true
                checkRateButton()
            } else {
                showAlert(message: "Please enter second rate.", title: AppAlertTitle.appName.rawValue)
            }
            print("its test 23")
        } else if secondTF.text != "" {
            if firstTF.text != "" {
                self.hourBtn.isEnabled = true
                self.dayBtn.isEnabled = true
                checkRateButton()
            } else {
                showAlert(message: "Please enter first rate.", title: AppAlertTitle.appName.rawValue)
            }
            print("its test 4")
        } else{
            if (UserType.userTypeInstance.userLogin == .Professional){
                professionalUserDict.rate_from = firstTF.text ?? ""
                professionalUserDict.rate_to = secondTF.text ?? ""
                let vc = JobTypeViewController()
                vc.professionalUserDict = self.professionalUserDict
                self.pushViewController(vc, true)
            }else{
                professionalUserDict.rate_from = firstTF.text ?? ""
                professionalUserDict.rate_to = secondTF.text ?? ""
                let vc = JobTypeViewController()
                vc.professionalUserDict = self.professionalUserDict
                self.pushViewController(vc, true)
            }
        }
    }
    
    func checkRateButton() {
        if professionalUserDict.rate_type != "" && professionalUserDict.rate_type?.count ?? 0 > 0 {
            if (UserType.userTypeInstance.userLogin == .Professional) {
                professionalUserDict.rate_from = firstTF.text ?? ""
                professionalUserDict.rate_to = secondTF.text ?? ""
                let vc = JobTypeViewController()
                vc.professionalUserDict = self.professionalUserDict
                self.pushViewController(vc, true)
            }else{
                professionalUserDict.rate_from = firstTF.text ?? ""
                professionalUserDict.rate_to = secondTF.text ?? ""
                let vc = JobTypeViewController()
                vc.professionalUserDict = self.professionalUserDict
                self.pushViewController(vc, true)
            }
        } else {
            showAlert(message: "please select rate type.", title: AppAlertTitle.appName.rawValue)
        }
    }
    
    
}

