//
//  CustomerBillingAddressVC.swift
//  WorkForce
//
//  Created by apple on 23/06/23.
//

import UIKit

class CustomerBillingAddressVC: UIViewController {
    
//    MARK: OUTLETS
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var addressSelectBtn: UIButton!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var postalCiodeTF: UITextField!
    @IBOutlet weak var selectImgVw: UIImageView!
    @IBOutlet weak var saveListBtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    
    var UserInvoiceAddressDict = InvoiceCreateModel()
    var iconClick = true
    var selectedAddressitems:[[String:String]] = []
    var is_customer_address = ""
    var navfromPDF:Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        if navfromPDF == true{
            addressTF.text = UserInvoiceAddressDict.customer_address
            cityTF.text = UserInvoiceAddressDict.customer_city
            stateTF.text = UserInvoiceAddressDict.customer_state
            countryTF.text = UserInvoiceAddressDict.customer_country
            if UserInvoiceAddressDict.is_customer_address == "1"{
                selectImgVw.image = UIImage(named: "clickblueTickcircle")
                selectImgVw.contentMode = .scaleAspectFill
                self.is_customer_address = "1"
            }else{
                selectImgVw.image = UIImage(named: "clickbluecircle")
                selectImgVw.contentMode = .scaleAspectFill
                self.is_customer_address = "2"
            }
            return
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.NotificationAct(_:)), name: NSNotification.Name(rawValue: "dataTransferToCustomerScreen"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "dataTransferToCustomerScreen"), object: nil)
    }

    
    
    @objc func NotificationAct(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let userName = userInfo["data"] as? [[String:String]]{
                self.selectedAddressitems = userName
                let selectedAddress = userName.map{ ($0["name"]! as String)}
                self.addressTF.text = selectedAddress.joined(separator: ",")
                let customer_city = userName.map{ ($0["customer_city"]! as String)}
                self.cityTF.text = customer_city.joined(separator: ",")
                let customer_state = userName.map{ ($0["customer_state"]! as String)}
                self.stateTF.text = customer_city.joined(separator: ",")
                let customer_country = userName.map{ ($0["customer_country"]! as String)}
                self.countryTF.text = customer_city.joined(separator: ",")
            }
       }
   }
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func addressSelectBtn(_ sender: UIButton) {
        let vc = CustomerBillingSavedAddressVC()
        vc.selectedAddress = selectedAddressitems
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func saveListBtn(_ sender: UIButton) {
        if(iconClick == true) {
            selectImgVw.image = UIImage(named: "clickblueTickcircle")
            selectImgVw.contentMode = .scaleAspectFill
            self.is_customer_address = "1"
        } else {
            selectImgVw.image = UIImage(named: "clickbluecircle")
            selectImgVw.contentMode = .scaleAspectFill
            self.is_customer_address = "2"
        }
        iconClick = !iconClick
    }
    
    @IBAction func continueBtn(_ sender: UIButton) {
        firstValidation()
    }
    
    
    //    MARK: VALIDATIONS
    func firstValidation(){
        if (addressTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: "U2 CONNECT" , message: "Please enter address." , okButton: "Ok", controller: self) {
            }
        }else if (cityTF.text?.trimWhiteSpace.isEmpty)! {
            showAlertMessage(title: "U2 CONNECT" , message: "Please enter city." , okButton: "Ok", controller: self) {
            }
        }else if (stateTF.text?.trimWhiteSpace.isEmpty)!{
            showAlertMessage(title: "U2 CONNECT", message: "Please enter state." , okButton: "Ok", controller: self) {
            }
        }else if (countryTF.text?.trimWhiteSpace.isEmpty)!{
            showAlertMessage(title: "U2 CONNECT", message: "Please enter country." , okButton: "Ok", controller: self) {
            }
        }else{
            if navfromPDF == true{
                UserInvoiceAddressDict.customer_address = addressTF.text ?? ""
                UserInvoiceAddressDict.customer_city = cityTF.text ?? ""
                UserInvoiceAddressDict.customer_state = stateTF.text ?? ""
                UserInvoiceAddressDict.customer_country = countryTF.text ?? ""
                UserInvoiceAddressDict.is_customer_address = self.is_customer_address
                let vc = ShippingAddressVC()
                vc.UserInvoiceAddressDict = UserInvoiceAddressDict
                vc.navfromPDF = true
                self.navigationController?.pushViewController(vc, animated: false)

            }else{
                UserInvoiceAddressDict.customer_address = addressTF.text ?? ""
                UserInvoiceAddressDict.customer_city = cityTF.text ?? ""
                UserInvoiceAddressDict.customer_state = stateTF.text ?? ""
                UserInvoiceAddressDict.customer_country = countryTF.text ?? ""
                UserInvoiceAddressDict.is_customer_address = self.is_customer_address
                let vc = ShippingAddressVC()
                vc.UserInvoiceAddressDict = UserInvoiceAddressDict
                self.navigationController?.pushViewController(vc, animated: false)

            }
        
        }
    }
}
