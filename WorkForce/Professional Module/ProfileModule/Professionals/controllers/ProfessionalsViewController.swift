//
//  ProfessionalsViewController.swift
//  WorkForce
//
//  Created by apple on 06/05/22.
//

import UIKit
import IQKeyboardManagerSwift

class ProfessionalsViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var professionalView: UIView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var firstTF: UITextField!
    @IBOutlet weak var hoursDayView: UIView!
    @IBOutlet weak var dayBtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var perHoursBtn: UIButton!
    
    var isselect:Bool = Bool()
    var professionalUserDict = SingletonLocalModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
         view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        print(dayBtn.isSelected , perHoursBtn.isSelected)
    }

    
    @IBAction func perHoursBtn(_ sender: UIButton) {
        isselect = true
        if isselect {
            self.professionalUserDict.rate_type = "Per Hour"
            perHoursBtn.setTitleColor(UIColor(red: 58, green: 148, blue: 184), for: .normal)
            dayBtn.setTitleColor(.gray, for: .normal)
        }
    }
    
    @IBAction func dayAction(_ sender: UIButton) {
        isselect = false
        if !isselect  {
            self.professionalUserDict.rate_type = "Per Day"
            dayBtn.setTitleColor(UIColor(red: 58, green: 148, blue: 184), for: .normal)
            perHoursBtn.setTitleColor(.gray, for: .normal)
        }

    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popViewController(true)
    }
    
  
    @IBAction func continueAction(_ sender: Any) {
//        self.professionalUserDict.rate_to = firstTF.text ?? ""
//        let vc = JobTypeViewController()
//        vc.professionalUserDict = self.professionalUserDict
//        self.pushViewController(vc, true)
        validation()
    }
    
    func setView(){
        firstTF.delegate = self
        firstView.layer.borderWidth = 1.5
        hoursDayView.layer.borderWidth = 1.5
        firstView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        hoursDayView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        dayBtn.setTitleColor(.gray, for: .normal)
        perHoursBtn.setTitleColor(.gray, for: .normal)
        self.perHoursBtn.isEnabled = false
        self.dayBtn.isEnabled = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        firstView.layer.borderColor = textField == firstTF  ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        hoursDayView.layer.borderColor = textField == firstTF  ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        firstView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        hoursDayView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        if firstTF.text != "" {
            self.perHoursBtn.isEnabled = true
            self.dayBtn.isEnabled = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let firstName = firstTF
        if textField == firstName {
            let allowedCharacters = "1234567890"
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
            if firstTF.text != "" {
                self.perHoursBtn.isEnabled = true
                self.dayBtn.isEnabled = true
                checkRateButton()
            }else{
                self.professionalUserDict.rate_to = firstTF.text ?? ""
                let vc = JobTypeViewController()
                vc.professionalUserDict = self.professionalUserDict
                self.pushViewController(vc, true)
            }
        }
    
    func checkRateButton() {
        if professionalUserDict.rate_type != "" && professionalUserDict.rate_type?.count ?? 0 > 0 {
                professionalUserDict.rate_to = firstTF.text ?? ""
                let vc = JobTypeViewController()
                vc.professionalUserDict = self.professionalUserDict
                self.pushViewController(vc, true)
        } else {
            showAlert(message: "please select rate type.", title: AppAlertTitle.appName.rawValue)
        }
    }
}

