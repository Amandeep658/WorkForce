//
//  AddProductServiceVC.swift
//  WorkForce
//
//  Created by apple on 23/06/23.
//

import UIKit
import Alamofire

class AddProductServiceVC: UIViewController {
    
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
    var invoiceAddressList:InvoiceAddAddressData?
    var imageArr:[String] = ["cross","cross","cross","cross","cross","cross","cross","cross","cross","cross"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
    }
    
    func setTable(){
        self.productTableView.delegate = self
        self.productTableView.dataSource = self
        self.productTableView.register(UINib(nibName: "ProductListItemCell", bundle: nil), forCellReuseIdentifier: "ProductListItemCell")
        self.productTableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: "HeaderView")
        self.productTableView.register(CustomHeaderView.self, forHeaderFooterViewReuseIdentifier: "CustomHeader")

    }
    

    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }

    @IBAction func submitBtn(_ sender: UIButton) {
        UserInvoiceAddressDict.product = productItemModel
        UserInvoiceAddressDict.product?[0].shipping = ShippingTF.text ?? ""
        UserInvoiceAddressDict.product?[0].total = totalTF.text ?? ""
        if ShippingTF.text == "" && totalTF.text == "" {
            showAlert(message: "Please fill all detail", title: AppAlertTitle.appName.rawValue)
        }else{
            hitInvoceSaveAddressApi()
        }
    }
    
    @IBAction func addMoreProductBtn(_ sender: UIButton) {
        let section = sender.tag
        if self.productItemModel.count == 10{
            self.productItemModel.remove(at: 1)
        }
        else{
            self.productItemModel.append(AddProductItemModel())
            
        }
        self.productTableView.reloadData()
        DispatchQueue.main.async {
            self.productTableViewHeightConstraints.constant = self.productTableView.contentSize.height
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
        let param = ["page_no" : "1","per_page" : "40"] as [String : Any]
        print(param)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.addinvoiceList, params: UserInvoiceAddressDict.convertModelToDict() as! Parameters , headers: headers) { [self] (response) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aContact = try jsonDecoder.decode(InvoiceAddAddressModel.self, from: data!)
                print(aContact)
                let status = aContact.status
                let message = aContact.message
                if status == 1{
                    showAlert(message: message ?? "", title: AppAlertTitle.appName.rawValue) { [self] in
                        let vc = InvoiceBillViewVC()
                        vc.UserInvoiceAddressDict = UserInvoiceAddressDict
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

extension AddProductServiceVC:UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productItemModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListItemCell", for: indexPath) as! ProductListItemCell
        cell.itemTF.text = self.productItemModel[indexPath.row].item
        cell.quantityTF.text = self.productItemModel[indexPath.row].quantity
        cell.rateTF.text = self.productItemModel[indexPath.row].rate
        cell.amountTF.text = self.productItemModel[indexPath.row].amount
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeader") as? CustomHeaderView
        header?.buttonAction = { [self] in
                 if let cell = productTableView as? ProductListItemCell {
                     if let indexPath = tableView.indexPath(for: cell) {
                         // Remove the item from the data array
                         productItemModel.remove(at: indexPath.row)
            
                         // Update the table view
                         tableView.deleteRows(at: [indexPath], with: .automatic)
                     }
                 }
             }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else{
            return 44
        }
    }
    
}



class HeaderView: UITableViewHeaderFooterView {

    var productItemModel = [AddProductItemModel()]

    let headerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "AddItem")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(hex: "#578BB8")
        
        return button
    }()
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = label.font.bold()
        label.textColor = UIColor(r: 87, g: 139, b: 184, a: 1)
        label.textColor = UIColor(hex: "#578BB8")
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(headerButton)
        addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerButton.topAnchor.constraint(equalTo: topAnchor),
            headerButton.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            headerButton.widthAnchor.constraint(equalToConstant: 60),
            headerButton.heightAnchor.constraint(equalToConstant: 60),
            
            headerLabel.centerYAnchor.constraint(equalTo: headerButton.centerYAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: headerButton.trailingAnchor, constant: 2),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
