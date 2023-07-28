//
//  AddProductServiceVC.swift
//  WorkForce
//
//  Created by apple on 23/06/23.
//

import UIKit
import Alamofire


protocol getProductItemDetail{
    func detail(parentDict:AddProductItemModel?,index:Int)
}

var updateTotal: (() -> Void)?
var updateItemTotal: (() -> Void)?



class AddProductServiceVC: UIViewController, getProductItemDetail,UITextFieldDelegate{
    func detail(parentDict: AddProductItemModel?, index: Int) {
        productItemModel[index] = parentDict ?? AddProductItemModel()
        self.productItemModel[index].item = parentDict?.item
        self.productItemModel[index].amount = parentDict?.amount
        self.productItemModel[index].quantity = parentDict?.quantity
        self.productItemModel[index].rate = parentDict?.rate
    }
    
    
//    MARK: OUTLETS
    @IBOutlet weak var lineProgressView: UIProgressView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var ShippingTF: UITextField!
    @IBOutlet weak var totalTF: UITextField!
    @IBOutlet weak var productTableViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var addMoreProductBtn: UIButton!
    
    var productItemModel = [AddProductItemModel()]
    var UserInvoiceAddressDict = InvoiceCreateModel()
    var invoiceAddressList:InvoiceAddressData?
    var imageArr:[String] = ["cross"]
    var item = "cross"
    var index = 0
    var totalValue = Int()
    var navfroPDF:Bool?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
        updateTotal = { [self] in
            calculateTotalAmount()
        }
        if navfroPDF == true{
            self.productItemModel = UserInvoiceAddressDict.product ?? []
            self.ShippingTF.text = UserInvoiceAddressDict.product?[0].shipping ?? ""
            self.totalTF.text = UserInvoiceAddressDict.product?[0].total ?? ""
            return
        }
       
    }
    
    func setTable(){
        self.productTableView.delegate = self
        self.productTableView.dataSource = self
        ShippingTF.delegate = self
        totalTF.delegate = self
        self.totalTF.isUserInteractionEnabled = false
        self.productTableView.register(UINib(nibName: "ProductListItemCell", bundle: nil), forCellReuseIdentifier: "ProductListItemCell")
        self.productTableView.register(CustomHeaderView.self, forHeaderFooterViewReuseIdentifier: "CustomHeader")
    }

    func itemList() -> Bool {
        for model in productItemModel {
            if !(model.item?.count ?? 0 > 0) {
                showAlert(message: "please_enter_item".localized(), title: AppAlertTitle.appName.rawValue)
                return false
            } else if !(model.quantity?.count ?? 0 > 0) {
                showAlert(message: "please_enter_quantity".localized(), title: AppAlertTitle.appName.rawValue)
                return false
            } else if !(model.rate?.count ?? 0 > 0) {
                showAlert(message: "please_enter_rate".localized(), title: AppAlertTitle.appName.rawValue)
                return false
            }
        }
        return true
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }

    @IBAction func submitBtn(_ sender: UIButton) {
        UserInvoiceAddressDict.shipping = ShippingTF.text
        UserInvoiceAddressDict.total = totalTF.text
        UserInvoiceAddressDict.product = productItemModel
        if itemList() == true {
            if ShippingTF.text == "" && totalTF.text == ""  {
                showAlert(message: "please_enter_shipping".localized(), title: AppAlertTitle.appName.rawValue)
            }else{
                hitInvoceSaveAddressApi()
            }
        }
    }
    
    
    @IBAction func addMoreProductBtn(_ sender: UIButton) {
        if itemList() == true{
            if self.productItemModel.count == 10{
                showAlert(message: "you_can_only_add_10_Products".localized(), title: AppAlertTitle.appName.rawValue) {
                    self.dismiss(animated: true)
                }
            }else{
                self.addMoreProductBtn.isUserInteractionEnabled = true
                self.productItemModel.append(AddProductItemModel())
            }
            calculateTotalAmount()
            self.productTableView.reloadData()
            DispatchQueue.main.async {
                self.productTableViewHeightConstraints.constant = self.productTableView.contentSize.height
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case self.ShippingTF:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.calculateTotalAmount()
            }
        default:break
        }
        return true
    }
    
    func calculateTotalAmount() {
        var val = 0
        productItemModel.forEach { item in
            let amountLabel = item.amount
            val += Int(amountLabel ?? "") ?? 0
        }
        if let opop = Int(ShippingTF.text ?? ""),
           opop > 0 {
            val += opop
            print("totalValue of table new sum is here >>>",val)
            self.totalTF.text = "\(val)"
            productItemModel[0].shipping = self.ShippingTF.text ?? ""
            productItemModel[0].total = self.totalTF.text ?? ""
        } else {
            self.totalTF.text = ""

        }
    }
    
    
//    MARK: OUTLETS
    func hitInvoceSaveAddressApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.addinvoicev2, params: UserInvoiceAddressDict.convertModelToDict() as! Parameters , headers: headers) { [self] (response) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aContact = try jsonDecoder.decode(InvoiceAddProductSerModel.self, from: data!)
                print(aContact)
                let status = aContact.status
                let message = aContact.message
                if status == 1{
                    showAlert(message: message ?? "", title: AppAlertTitle.appName.rawValue) { [self] in
                        let vc = InvoiceBillViewVC()
                        vc.UserInvoiceAddressDict = UserInvoiceAddressDict
                        vc.invoiceHitId = aContact.data?.id ?? ""
                        self.navigationController?.pushViewController(vc, animated: false)
                    }
                }else{
                    showAlert(message: message ?? "", title: AppAlertTitle.appName.rawValue)
                }
            }
            catch let parseError {
                print("JSON Error \(parseError.localizedDescription)")
            }
            
        } failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
        
    }

}

extension AddProductServiceVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productItemModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListItemCell", for: indexPath) as! ProductListItemCell
       
        cell.itemTF.text = self.productItemModel[indexPath.row].item
        cell.quantityTF.text = self.productItemModel[indexPath.row].quantity
        cell.rateTF.text = self.productItemModel[indexPath.row].rate
        cell.amountTF.text = self.productItemModel[indexPath.row].amount
        cell.getProductitemDelegate = self
        cell.itemTF.tag = indexPath.row
        cell.quantityTF.tag = indexPath.row
        cell.rateTF.tag = indexPath.row
        cell.amountTF.tag = indexPath.row
        cell.amountTF.isUserInteractionEnabled = false

        if indexPath.row == 0 {
            cell.crossView.isHidden = true
            cell.crossViewHeightConstraint.constant = 0
        }else{
            cell.crossView.isHidden = false
            cell.crossViewHeightConstraint.constant =  30
        }
        cell.crossBtn.tag = indexPath.row
        cell.crossBtn.addTarget(self, action: #selector(hitCrossBtn), for: .touchUpInside)
        DispatchQueue.main.async {
            self.productTableViewHeightConstraints.constant = self.productTableView.contentSize.height
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func hitCrossBtn(sender : UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: productTableView)
        if let indexPath = productTableView.indexPathForRow(at: buttonPosition) {
            productItemModel.remove(at: indexPath.row)
            productTableView.deleteRows(at: [indexPath], with: .automatic)
            calculateTotalAmount()
            productTableView.reloadData()
            if self.productItemModel.count == 10{
                self.addMoreProductBtn.isUserInteractionEnabled = false
            }else{
                self.addMoreProductBtn.isUserInteractionEnabled = true
            }
        }
        DispatchQueue.main.async {
            self.productTableViewHeightConstraints.constant = self.productTableView.contentSize.height
        }
    }
}


extension UIFont {
    func withTraits(traits:UIFontDescriptor.SymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }

    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
}

