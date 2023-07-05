//
//  NewEstimateAddressVC.swift
//  WorkForce
//
//  Created by apple on 20/06/23.
//

import UIKit
import Alamofire
import ADCountryPicker


class NewEstimateAddressVC: UIViewController {

    
//    MARK: OUTLETS
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var businessAddressTF: UITextField!
    @IBOutlet weak var phonnumberTF: UITextField!
    @IBOutlet weak var websiteTF: UITextField!
    @IBOutlet weak var estimateNumberTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var selectImgVw: UIImageView!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var invoiceNameTF: UITextField!
    @IBOutlet weak var addressSelectBtn: UIButton!
    @IBOutlet weak var countryCodeLbl: UILabel!
    @IBOutlet weak var countryImgView: UIImageView!
    @IBOutlet weak var countryPickerBtn: UIButton!
    
    var iconClick = true
    var selectedAddressitems:[[String:String]] = []
    var UserInvoiceAddressDict = InvoiceCreateModel()
    let datePicker = UIDatePicker()
    var is_business_address = ""




    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        createDatePicker()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        phonnumberTF.delegate = self
        dateTF.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.NotificationAct(_:)), name: NSNotification.Name(rawValue: "dataTransferToEstimateScreen"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "dataTransferToEstimateScreen"), object: nil)
    }

    
    
    @objc func NotificationAct(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let userName = userInfo["data"] as? [[String:String]]{
                self.selectedAddressitems = userName
                let selectedAddress = userName.map{ ($0["name"]! as String)}
                self.businessAddressTF.text = selectedAddress.joined(separator: ",")
                let selectedCategoryID = userName.map{ ($0["business_phone_number"]! as String)}
                self.phonnumberTF.text = selectedCategoryID.joined(separator: ",")
                let selectedWebsite = userName.map{ ($0["website"]! as String)}
                self.websiteTF.text = selectedWebsite.joined(separator: ",")
                self.countryCodeLbl.text = ""
            }
       }
   }
    
    func createDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        dateTF.inputAccessoryView = toolbar
        datePicker.datePickerMode = .date
        dateTF.inputView = datePicker
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    @objc func donePressed() {
        if dateTF.isFirstResponder {
            let formatter: DateFormatter = DateFormatter()
            formatter.dateStyle = .full
            formatter.timeStyle = .none
            formatter.dateFormat = "yyyy-MM-dd"
            dateTF.text = formatter.string(from: datePicker.date)
        }
        self.view.endEditing(true)
    }
    
    
//    MARK: Button Action
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueBtn(_ sender: UIButton) {
        firstValidation()
    }
    
    
    @IBAction func selectBtn(_ sender: UIButton) {
        if(iconClick == true) {
            selectImgVw.image = UIImage(named: "clickblueTickcircle")
            selectImgVw.contentMode = .scaleAspectFill
            self.is_business_address = "1"
        } else {
            selectImgVw.image = UIImage(named: "clickbluecircle")
            selectImgVw.contentMode = .scaleAspectFill
            self.is_business_address = "2"
        }
        iconClick = !iconClick
    }
    
    @IBAction func addressSelectBtn(_ sender: UIButton) {
        let vc = SelectSavedAddressVC()
        vc.selectedAddress = selectedAddressitems
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    @IBAction func countryPickerBtn(_ sender: UIButton) {
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
    

    //    MARK: VALIDATIONS
    func firstValidation(){
        if (invoiceNameTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: "U2 CONNECT" , message: "Please enter business name." , okButton: "Ok", controller: self) {
            }
        }else if (businessAddressTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: "U2 CONNECT" , message: "Please enter business address." , okButton: "Ok", controller: self) {
            }
        }else if (phonnumberTF.text?.trimWhiteSpace.isEmpty)!{
            showAlertMessage(title: "U2 CONNECT", message: "Please enter phone number." , okButton: "Ok", controller: self) {
            }
        }else if (websiteTF.text?.trimWhiteSpace.isEmpty)!{
            showAlertMessage(title: "U2 CONNECT", message: "Please enter website." , okButton: "Ok", controller: self) {
            }
        }else if (estimateNumberTF.text?.trimWhiteSpace.isEmpty)!{
            showAlertMessage(title: "U2 CONNECT", message: "Please enter estimate no." , okButton: "Ok", controller: self) {
            }
        }else if (dateTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: "U2 CONNECT", message: "Please enter date." , okButton: "Ok", controller: self) {
            }
        }else{
            UserInvoiceAddressDict.business_name = self.invoiceNameTF.text ?? ""
            UserInvoiceAddressDict.business_address = self.businessAddressTF.text ?? ""
            UserInvoiceAddressDict.business_phone_number = self.phonnumberTF.text ?? ""
            UserInvoiceAddressDict.website = self.websiteTF.text ?? ""
            UserInvoiceAddressDict.estimate_no = self.estimateNumberTF.text ?? ""
            UserInvoiceAddressDict.date =  self.dateTF.text ?? ""
            UserInvoiceAddressDict.is_business_address =  self.is_business_address
            let vc = CustomerBillingAddressVC()
            vc.UserInvoiceAddressDict = UserInvoiceAddressDict
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
}
extension NewEstimateAddressVC: UITextFieldDelegate,ADCountryPickerDelegate{
    
//    MARK: COUNTRY PICKER DELEGATE
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        _ = picker.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        print("her is code--->>>>",code)
        let image =  picker.getFlag(countryCode: code)
        countryImgView.image = image
        countryCodeLbl.text = dialCode
        phonnumberTF.text = ""
    }
    
//    MARK: TEXTFIELD DELEGATE
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
