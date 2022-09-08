//
//  JobTypeViewController.swift
//  WorkForce
//
//  Created by Dharmani Apps on 16/05/22.
//

import UIKit
import IQKeyboardManagerSwift

class JobTypeViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var jobTF: UITextField!
    @IBOutlet weak var jobView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var dropDownBtn: UIButton!
    
    var jobType = ["Full Time".localized(), "Part Time".localized(), "Contract".localized(), "Freelance".localized(),"Remote".localized()]
    var countdown = UIPickerView()
    var doneToolBar = UIToolbar()
    var professionalJobDict = [String:Any]()
    var professionalUserDict = SingletonLocalModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        setView()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @IBAction func dropDownBtn(_ sender: UIButton) {
        print("its dropdown")
        doneToolBar.removeFromSuperview()
        countdown.removeFromSuperview()
        self.jobView.borderColor = #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)
        self.countdown.delegate = self
        self.countdown.dataSource = self
        self.countdown.backgroundColor = UIColor.white
        self.countdown.autoresizingMask = .flexibleWidth
        self.countdown.contentMode = .center
        self.countdown.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(countdown)
        self.doneToolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        self.doneToolBar.barStyle = .default
        self.doneToolBar.items = [UIBarButtonItem.init(title: "Done".localized(), style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(doneToolBar)
    }
    
    @objc func onDoneButtonTapped() {
        doneToolBar.removeFromSuperview()
        countdown.removeFromSuperview()
        self.jobView.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
//    MARK: PICKER VIEW DELEGATE
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return jobType.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return jobType[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.jobTF.text = self.jobType[row]
    }
    
    
    
    func setView(){
        jobTF.delegate = self
        jobView.borderColor = .gray
        jobView.borderWidth = 1
        self.jobTF.text = jobType.first ?? ""
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popViewController(true)
    }
    @IBAction func continueAction(_ sender: UIButton) {
        validation()
    }

    //   MARK: VALIDATION
    func validation(){
        if (jobTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter job type.".localized() , okButton: "Ok", controller: self) {
            }
        }
        else{
            if (UserType.userTypeInstance.userLogin == .Bussiness){
                self.professionalUserDict.job_type = self.jobTF.text
                let vc = LocationVC()
                vc.professionalUserDict = self.professionalUserDict
                self.pushViewController(vc, true)
            }else if (UserType.userTypeInstance.userLogin == .Professional){
                self.professionalUserDict.job_type = self.jobTF.text
                let vc = CityViewController()
                vc.professionalUserDict = self.professionalUserDict
                self.pushViewController(vc, true)
            }else{
                self.professionalUserDict.job_type = self.jobTF.text
                let vc = LocationVC()
                vc.professionalUserDict = self.professionalUserDict
                self.pushViewController(vc, true)
            }
           
        }
    }
    
}
