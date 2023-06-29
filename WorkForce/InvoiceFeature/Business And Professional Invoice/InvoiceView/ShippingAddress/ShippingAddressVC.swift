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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
                self.addressTF.text = selectedAddress.joined(separator: ",")
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
            sameSelectAddressImgVw.image = UIImage(named: "circleTick")
            sameSelectAddressImgVw.contentMode = .scaleAspectFill
            self.addressTF.text = UserInvoiceAddressDict.customer_address
            self.cityTF.text = UserInvoiceAddressDict.customer_city
            self.stateTF.text = UserInvoiceAddressDict.customer_state
            self.countryTF.text = UserInvoiceAddressDict.customer_country
        } else {
            sameSelectAddressImgVw.image = UIImage(named: "circle")
            sameSelectAddressImgVw.contentMode = .scaleAspectFill
            self.addressTF.text = ""
            self.cityTF.text = ""
            self.stateTF.text = ""
            self.countryTF.text = ""
        }
        iconSameBillingAddress = !iconSameBillingAddress
    }
    
    @IBAction func addressSelectBtn(_ sender: UIButton) {
        let vc = SelectSavedAddressVC()
        vc.selectedAddress = selectedAddressitems
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func saveAddressBtn(_ sender: UIButton) {
        if(iconClick == true) {
            saveListImgVww.image = UIImage(named: "circleTick")
            saveListImgVww.contentMode = .scaleAspectFill
        } else {
            saveListImgVww.image = UIImage(named: "circle")
            saveListImgVww.contentMode = .scaleAspectFill
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
            UserInvoiceAddressDict.customer_address = self.addressTF.text ?? ""
            UserInvoiceAddressDict.customer_city = self.cityTF.text ?? ""
            UserInvoiceAddressDict.customer_state = self.stateTF.text ?? ""
            UserInvoiceAddressDict.customer_country = self.countryTF.text ?? ""
            let vc = AddProductServiceVC()
            vc.UserInvoiceAddressDict = UserInvoiceAddressDict
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
}
