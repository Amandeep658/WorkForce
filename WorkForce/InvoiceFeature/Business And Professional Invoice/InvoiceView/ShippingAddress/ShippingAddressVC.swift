//
//  ShippingAddressVC.swift
//  WorkForce
//
//  Created by apple on 23/06/23.
//

import UIKit

class ShippingAddressVC: UIViewController {

    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var sameSelectAddressImgVw: UIImageView!
    @IBOutlet weak var sameSelectAddressBtn: UIButton!
    @IBOutlet weak var addressSelectBtn: UIButton!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var postalTF: UITextField!
    @IBOutlet weak var saveListImgVww: UIImageView!
    @IBOutlet weak var saveAddressBtn: UIButton!
    
    var UserInvoiceAddressDict = InvoiceCreateModel()
    var iconClick = true
    var iconSameBillingAddress = true
    var selectedAddressitems:[[String:String]] = []
    var is_shipping_address = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.NotificationAct(_:)), name: NSNotification.Name(rawValue: "dataTransferToShippingScreen"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "dataTransferToShippingScreen"), object: nil)
    }

    
    
    @objc func NotificationAct(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let userName = userInfo["data"] as? [[String:String]]{
                self.selectedAddressitems = userName
                let selectedAddress = userName.map{ ($0["name"]! as String)}
                self.addressTF.text = selectedAddress.joined(separator: ",")
                let shipping_city = userName.map{ ($0["shipping_city"]! as String)}
                self.cityTF.text = shipping_city.joined(separator: ",")
                let shipping_state = userName.map{ ($0["shipping_state"]! as String)}
                self.stateTF.text = shipping_state.joined(separator: ",")
                let shipping_country = userName.map{ ($0["shipping_country"]! as String)}
                self.countryTF.text = shipping_country.joined(separator: ",")
            }
       }
   }
    
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueBtn(_ sender: UIButton) {
        firstValidation()
    }
    
    @IBAction func sameSelectAddressBtn(_ sender: UIButton) {
        if(iconSameBillingAddress == true) {
            sameSelectAddressImgVw.image = UIImage(named: "blackTickCircle")
            sameSelectAddressImgVw.contentMode = .scaleAspectFill
            self.addressTF.text = UserInvoiceAddressDict.customer_address
            self.cityTF.text = UserInvoiceAddressDict.customer_city
            self.stateTF.text = UserInvoiceAddressDict.customer_state
            self.countryTF.text = UserInvoiceAddressDict.customer_country
        } else {
            sameSelectAddressImgVw.image = UIImage(named: "blackHitCircle")
            sameSelectAddressImgVw.contentMode = .scaleAspectFill
            self.addressTF.text = ""
            self.cityTF.text = ""
            self.stateTF.text = ""
            self.countryTF.text = ""
        }
        iconSameBillingAddress = !iconSameBillingAddress
    }
    
    @IBAction func addressSelectBtn(_ sender: UIButton) {
        let vc = ShippingBillingSavedAddressVC()
        vc.selectedAddress = selectedAddressitems
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func saveAddressBtn(_ sender: UIButton) {
        if(iconClick == true) {
            saveListImgVww.image = UIImage(named: "clickblueTickcircle")
            saveListImgVww.contentMode = .scaleAspectFill
            self.is_shipping_address = "1"
        } else {
            saveListImgVww.image = UIImage(named: "clickbluecircle")
            saveListImgVww.contentMode = .scaleAspectFill
            self.is_shipping_address = "2"
        }
        iconClick = !iconClick
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
            UserInvoiceAddressDict.shipping_address = self.addressTF.text ?? ""
            UserInvoiceAddressDict.shipping_city = self.cityTF.text ?? ""
            UserInvoiceAddressDict.shipping_state = self.stateTF.text ?? ""
            UserInvoiceAddressDict.shipping_country = self.countryTF.text ?? ""
            UserInvoiceAddressDict.is_shipping_address = self.is_shipping_address
            let vc = AddProductServiceVC()
            vc.UserInvoiceAddressDict = UserInvoiceAddressDict
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
}
