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
    
    
    //    MARK: BUTTON ACTION
    @IBAction func backBtn(_ sender: UIButton) {
        self.popVC()
    }
    
    
    @IBAction func continueBtn(_ sender: UIButton) {
        let vc = RecoverEmailOTPVC()
        self.pushViewController(vc, true)
    }
    
}
