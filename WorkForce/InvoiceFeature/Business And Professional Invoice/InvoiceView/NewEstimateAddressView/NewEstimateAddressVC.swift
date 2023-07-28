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
    let countryPicker = ADCountryPicker()
    var countryFlagCode = ""
    var estimateNumber = ""
    var invoiceListData = [InvoiceListData]()
    var navFromPDF:Bool?
    var invoiceId = ""
    var is_invoice = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        createDatePicker()
        countryPicker.delegate = self
        
        if invoiceListData.count != 0 {
            let value = (Int(estimateNumber) ?? 0) + 1
            print("value is here >>>>",value)
            self.estimateNumberTF.text = "\(value)"
        }else{
            let date = Date()
            let milliseconds = Int(date.timeIntervalSince1970 * 1000)
            print(milliseconds)
            self.estimateNumberTF.text = "1"
        }
        
        self.estimateNumberTF.isUserInteractionEnabled = false
        if navFromPDF == true{
            UserInvoiceAddressDict.id = invoiceId
            self.invoiceNameTF.text = UserInvoiceAddressDict.business_name
            self.invoiceNameTF.text = UserInvoiceAddressDict.invoice_number
            self.businessAddressTF.text = UserInvoiceAddressDict.business_address
            let flagImage = countryPicker.getFlag(countryCode: UserInvoiceAddressDict.country_code ?? "")
            self.countryImgView.image = flagImage
            self.countryFlagCode = UserInvoiceAddressDict.country_code ?? ""
            self.countryCodeLbl.text = UserInvoiceAddressDict.dial_code
            self.phonnumberTF.text = UserInvoiceAddressDict.business_phone_number
            self.websiteTF.text = UserInvoiceAddressDict.website
            self.is_invoice = UserInvoiceAddressDict.is_invoice ?? ""
            self.estimateNumberTF.text = UserInvoiceAddressDict.estimate_no
            self.dateTF.text = UserInvoiceAddressDict.date
            
            if UserInvoiceAddressDict.is_business_address == "1"{
                selectImgVw.image = UIImage(named: "clickblueTickcircle")
                selectImgVw.contentMode = .scaleAspectFill
                self.is_business_address = "1"
            }else{
                selectImgVw.image = UIImage(named: "clickbluecircle")
                selectImgVw.contentMode = .scaleAspectFill
                self.is_business_address = "2"
            }
            return
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        phonnumberTF.delegate = self
        dateTF.delegate = self
        estimateNumberTF.delegate = self
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
                let dial_code = userName.map{ ($0["dial_code"]! as String)}
                print("countryCode is here",dial_code)
                self.countryCodeLbl.text = "\(dial_code.first ?? "")"
                
                let countryCode = userName.map{ ($0["country_code"]! as String)}
                print("countryCode is here",countryCode)
                self.countryFlagCode =  countryCode.first ?? ""
                let flagImage =  countryPicker.getFlag(countryCode: "\(countryCode.first ?? "")")
                print("flagImage",flagImage as Any)
                self.countryImgView.image = flagImage
                
//
//                let dialingCode =  countryPicker.getDialCode(countryCode: code)
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
            showAlertMessage(title: "U2 CONNECT" , message: "business_name".localized() , okButton: "Ok", controller: self) {
            }
        }else if (businessAddressTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: "U2 CONNECT" , message: "please_enter_business_address".localized() , okButton: "Ok", controller: self) {
            }
        }else if (phonnumberTF.text?.trimWhiteSpace.isEmpty)!{
            showAlertMessage(title: "U2 CONNECT", message: "Please_enter_number".localized() , okButton: "Ok", controller: self) {
            }
        }else if (self.websiteTF.text?.count ?? 0 > 0  && validateWebsiteURL("\(websiteTF.text ?? "")") == false){
            showAlertMessage(title: "U2 CONNECT", message: "please_enter_valid_website".localized() , okButton: "Ok", controller: self) {
            }
        }else if (estimateNumberTF.text?.trimWhiteSpace.isEmpty)!{
            showAlertMessage(title: "U2 CONNECT", message: "please_enter_estimate_no".localized() , okButton: "Ok", controller: self) {
            }
        }else if (dateTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: "U2 CONNECT", message: "please_enter_date".localized() , okButton: "Ok", controller: self) {
            }
        }else{
            if navFromPDF == true{
                UserInvoiceAddressDict.id = invoiceId
                UserInvoiceAddressDict.business_name = self.invoiceNameTF.text ?? ""
                UserInvoiceAddressDict.invoice_number = self.invoiceNameTF.text ?? ""
                UserInvoiceAddressDict.business_address = self.businessAddressTF.text ?? ""
                UserInvoiceAddressDict.country_code = countryFlagCode
                UserInvoiceAddressDict.dial_code = "\(self.countryCodeLbl.text ?? "")"
                UserInvoiceAddressDict.business_phone_number = "\(self.phonnumberTF.text ?? "")"
                UserInvoiceAddressDict.website = self.websiteTF.text ?? ""
                UserInvoiceAddressDict.estimate_no = self.estimateNumberTF.text ?? ""
                UserInvoiceAddressDict.date =  self.dateTF.text ?? ""
                UserInvoiceAddressDict.is_business_address = self.is_business_address
                let vc = CustomerBillingAddressVC()
                vc.UserInvoiceAddressDict = UserInvoiceAddressDict
                vc.navfromPDF = true
                self.navigationController?.pushViewController(vc, animated: false)
            }else{
                UserInvoiceAddressDict.business_name = self.invoiceNameTF.text ?? ""
                UserInvoiceAddressDict.invoice_number = self.invoiceNameTF.text ?? ""
                UserInvoiceAddressDict.business_address = self.businessAddressTF.text ?? ""
                if countryFlagCode == "" {
                    UserInvoiceAddressDict.country_code = "US"
                }else{
                    UserInvoiceAddressDict.country_code = self.countryFlagCode
                }
                UserInvoiceAddressDict.dial_code = "\(self.countryCodeLbl.text ?? "")"
                UserInvoiceAddressDict.business_phone_number = "\(self.phonnumberTF.text ?? "")"
                UserInvoiceAddressDict.website = self.websiteTF.text ?? ""
                UserInvoiceAddressDict.is_invoice = "1"
                UserInvoiceAddressDict.estimate_no = self.estimateNumberTF.text ?? ""
                UserInvoiceAddressDict.date =  self.dateTF.text ?? ""
                UserInvoiceAddressDict.is_business_address =  self.is_business_address
                let vc = CustomerBillingAddressVC()
                vc.UserInvoiceAddressDict = UserInvoiceAddressDict
                self.navigationController?.pushViewController(vc, animated: false)
            }
            
        }
    }
    
    func validateWebsiteURL(_ urlString: String) -> Bool {
        let websiteURLRegEx = "^(([s]?))?(www\\.)?[a-zA-Z0-9]+\\.[a-zA-Z]{2,}(\\.[a-zA-Z]{2,})?$"
        let websiteURLPredicate = NSPredicate(format: "SELF MATCHES %@", websiteURLRegEx)
        return websiteURLPredicate.evaluate(with: urlString)
    }
}
extension NewEstimateAddressVC: UITextFieldDelegate,ADCountryPickerDelegate{
    
//    MARK: COUNTRY PICKER DELEGATE
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        _ = picker.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        print("her is code--->>>>",code)
        self.countryFlagCode = code
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
