//
//  ShippingBillingSavedAddressVC.swift
//  WorkForce
//
//  Created by apple on 29/06/23.
//

import UIKit
import Alamofire
import SVProgressHUD

class ShippingBillingSavedAddressVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //  MARK: OUTLETS
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var selectTableVw: UITableView!
    @IBOutlet weak var selectHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var doneBtn: UIButton!
    
    var selectedAddress:[[String:String]] = []
    var invSavedListArr = [InvoiceSavedAddressData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
        self.selectedAddress = []
    }
    //    MARK: SET_TABLE_LIST
    func setTable(){
        selectTableVw.delegate = self
        selectTableVw.dataSource = self
        selectTableVw.register(UINib(nibName: "SelectCityAddressCell", bundle: nil), forCellReuseIdentifier: "SelectCityAddressCell")
        hitSelectSavedAddressApi()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "dataTransferToShippingScreen"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func doneBtn(_ sender: UIButton) {
        if selectedAddress.count == 0{
            alert(AppAlertTitle.appName.rawValue, message: "Please select the address", view: self)
        }else if selectedAddress.count > 1{
            alert(AppAlertTitle.appName.rawValue, message: "Please select only one address", view: self)
        }else{
            self.navigationController?.backViewController(animated: true, completion: {
                let data:[String: Any] = ["data": self.selectedAddress]
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "dataTransferToShippingScreen"), object: nil,userInfo: data)
            })
        }
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
//    MARK: HIT BILLING ADDRESS
    
    func hitSelectSavedAddressApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let param = ["page_no" : "1","per_page" : "40"] as [String : Any]
        print(param)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.invoiceShippingAddressList, params: [:], headers: headers) { [self] (response) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aContact = try jsonDecoder.decode(InvoiceSavedAddressModel.self, from: data!)
                print(aContact)
                let status = aContact.status
                let message = aContact.message
                if status == 1{
                    self.invSavedListArr = aContact.data!
                    self.selectTableVw.setBackgroundView(message: "")
                    self.selectTableVw.reloadData()
                    let selectedAddressID = selectedAddress.map{ ($0["id"]! as String)}
                    for i in 0..<self.invSavedListArr.count {
                        for j in 0..<selectedAddressID.count {
                            if self.invSavedListArr[i].id == selectedAddressID[j]{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    self.tableView(self.selectTableVw, didSelectRowAt: IndexPath(row: i, section: 0))
                                    self.selectTableVw.reloadData()
                                }
                            }
                        }
                    }
                }
                else{
                    self.selectTableVw.setBackgroundView(message: message!)
                    self.invSavedListArr.removeAll()
                    self.selectTableVw.reloadData()
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
    
    //    MARK: TABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invSavedListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCityAddressCell", for: indexPath) as! SelectCityAddressCell
        cell.addressLbl.text = invSavedListArr[indexPath.row].shipping_address
        cell.addressLbl2.text = "\(invSavedListArr[indexPath.row].shipping_city ?? ""),\(invSavedListArr[indexPath.row].shipping_state ?? ""),\(invSavedListArr[indexPath.row].shipping_country ?? "")"
        cell.isSelected = false
        cell.selectBtn.setImage(UIImage(named: "circle"), for: .normal)
        DispatchQueue.main.async{
            self.selectHeightConstraints.constant = self.selectTableVw.contentSize.height
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as!SelectCityAddressCell
        cell.selectBtn.setImage(UIImage(named: "circleTick"), for: .normal)
        if (selectedAddress.firstIndex(where: {$0["id"]! == invSavedListArr[indexPath.row].id ?? ""}) == nil){
            let selectedDict = ["name":invSavedListArr[indexPath.row].shipping_address ?? "","id":invSavedListArr[indexPath.row].id ?? "","shipping_city":invSavedListArr[indexPath.row].shipping_city ?? "","country_code":invSavedListArr[indexPath.row].country_code ?? "","dial_code":invSavedListArr[indexPath.row].dial_code ?? "","shipping_state":invSavedListArr[indexPath.row].shipping_state ?? "","shipping_country":invSavedListArr[indexPath.row].shipping_country ?? ""]
            selectedAddress.append(selectedDict)
        }
        print(selectedAddress)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SelectCityAddressCell
        cell.selectBtn.setImage(UIImage(named: "circle"), for: .normal)
        if let index = selectedAddress.firstIndex(where: {$0["id"]! == invSavedListArr[indexPath.row].id ?? ""}) {
            selectedAddress.remove(at: index)
        }
        print(selectedAddress)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98
    }
}
