//
//  DobViewController.swift
//  WorkForce
//
//  Created by apple on 05/05/22.
//

import UIKit
class ActualGradientButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = self.bounds
        l.colors = [#colorLiteral(red: 0.1984136999, green: 0.6973106265, blue: 0.8806249499, alpha: 1).cgColor, #colorLiteral(red: 0.1712574661, green: 0.6269177794, blue: 0.8018994331, alpha: 1).cgColor]
        l.startPoint = CGPoint(x: 0, y: 0.5)
        l.endPoint = CGPoint(x: 1, y: 0.5)
        l.cornerRadius = 7
        layer.insertSublayer(l, at: 0)
        return l
    }()
}

class DobViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var dobView: UIView!
    @IBOutlet weak var dobTF: UITextField!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    
    let datePicker = UIDatePicker()
    var pUseriD:Int?
    var professionalUserDict = SingletonLocalModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dobTF.delegate = self
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        setView()
        createDatePicker()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    }
    
    func createDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        dobTF.inputAccessoryView = toolbar
        datePicker.datePickerMode = .date
        self.datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        dobTF.inputView = datePicker
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    @objc func donePressed() {
        if dobTF.isFirstResponder {
            let formatter: DateFormatter = DateFormatter()
            formatter.dateStyle = .full
            formatter.timeStyle = .none
//            formatter.dateFormat = "dd-MM-yyyy"
            formatter.dateFormat = "yyyy-MM-dd"
            dobTF.text = formatter.string(from: datePicker.date)
        }
        self.view.endEditing(true)
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        validation()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popViewController(true)
    }
    
    func setView(){
        dobView.layer.borderWidth = 1.5
        dobView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
//    MARK: TEXTFIELD DELEGATES
    func textFieldDidBeginEditing(_ textField: UITextField) {
        dobView.layer.borderColor = textField == dobTF ?  #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)  :  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        dobView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //   MARK: VALIDATION
        func validation(){
            if (dobTF.text?.trimWhiteSpace.isEmpty)! {
                showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter date of birth." , okButton: "Ok", controller: self) {
                }
            }else{
                if UserType.userTypeInstance.userLogin == .Coustomer{
                    self.professionalUserDict.date_of_birth = self.dobTF.text?.replacingOccurrences(of: "/", with: "-")
                }else{
                    self.professionalUserDict.date_of_birth = self.dobTF.text?.replacingOccurrences(of: "/", with: "-")
                    let vc = SkillsViewController()
                    vc.professionalUserDict = self.professionalUserDict
                    self.pushViewController(vc, true)
                }
            }
        }
}
