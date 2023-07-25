//
//  SelectSavedAddressVC.swift
//  WorkForce
//
//  Created by apple on 23/06/23.
//

import UIKit
import Alamofire
import SVProgressHUD

class SelectSavedAddressVC: UIViewController {

//    MARK: OUTLETS
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var savedAddressTableView: UITableView!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var selectHeightConstraint: NSLayoutConstraint!
    
    var selectedAddress:[[String:String]] = []
    var InvoiceSavedListArr = [InvoiceSavedAddressData]()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
        self.selectedAddress = []
     }
    
    //    MARK: SET_TABLE_LIST
    func setTable(){
        savedAddressTableView.delegate = self
        savedAddressTableView.dataSource = self
        savedAddressTableView.register(UINib(nibName: "SelectSavedAddressCell", bundle: nil), forCellReuseIdentifier: "SelectSavedAddressCell")
//        savedAddressTableView.allowsMultipleSelection = true
        hitSelectSavedAddressApi()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "dataTransferToEstimateScreen"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
        

//    MARK: BUTTONS
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueBtn(_ sender: UIButton) {
        if selectedAddress.count == 0{
            alert(AppAlertTitle.appName.rawValue, message: "Please select the address", view: self)
        }else if selectedAddress.count > 1{
            alert(AppAlertTitle.appName.rawValue, message: "Please select only one address", view: self)
        }else{
            self.navigationController?.backViewController(animated: true, completion: {
                let data:[String: Any] = ["data": self.selectedAddress]
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "dataTransferToEstimateScreen"), object: nil,userInfo: data)
            })
        }
    }
    
    
    func hitSelectSavedAddressApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let param = ["page_no" : "1","per_page" : "40"] as [String : Any]
        print(param)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.invoiceEstimateAddressList, params: [:], headers: headers) { [self] (response) in
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
                    InvoiceSavedListArr.removeAll()
                    self.InvoiceSavedListArr = aContact.data!
                    
                    self.savedAddressTableView.setBackgroundView(message: "")
                    self.savedAddressTableView.reloadData()
                    let selectedAddressID = selectedAddress.map{ ($0["id"]! as String)}
                    for i in 0..<self.InvoiceSavedListArr.count {
                        for j in 0..<selectedAddressID.count {
                            if self.InvoiceSavedListArr[i].id == selectedAddressID[j]{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    self.tableView(self.savedAddressTableView, didSelectRowAt: IndexPath(row: i, section: 0))
                                    self.savedAddressTableView.reloadData()
                                }
                            }
                        }
                    }
                }
                else{
                    self.savedAddressTableView.setBackgroundView(message: message!)
                    self.InvoiceSavedListArr.removeAll()
                    self.savedAddressTableView.reloadData()
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
extension SelectSavedAddressVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InvoiceSavedListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectSavedAddressCell", for: indexPath) as! SelectSavedAddressCell
        cell.addressLbl.text = InvoiceSavedListArr[indexPath.row].business_address
        cell.phoneNumberTF.text = "\(InvoiceSavedListArr[indexPath.row].dial_code ?? "") \(InvoiceSavedListArr[indexPath.row].business_phone_number ?? "")"
        cell.websiteLbl.text = InvoiceSavedListArr[indexPath.row].website
        cell.isSelected = false
        cell.selectBtn.setImage(UIImage(named: "circle"), for: .normal)
        DispatchQueue.main.async{
            self.selectHeightConstraint.constant = self.savedAddressTableView.contentSize.height
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as!SelectSavedAddressCell
        cell.selectBtn.setImage(UIImage(named: "circleTick"), for: .normal)
        if (selectedAddress.firstIndex(where: {$0["id"]! == InvoiceSavedListArr[indexPath.row].id ?? ""}) == nil){
            let selectedDict = ["name":InvoiceSavedListArr[indexPath.row].business_address ?? "","id":InvoiceSavedListArr[indexPath.row].id ?? "","business_phone_number":InvoiceSavedListArr[indexPath.row].business_phone_number ?? "","country_code":InvoiceSavedListArr[indexPath.row].country_code ?? "","dial_code":InvoiceSavedListArr[indexPath.row].dial_code ?? "","website":InvoiceSavedListArr[indexPath.row].website ?? ""]
            selectedAddress.append(selectedDict)
        }
        print(selectedAddress)
        print("Select")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SelectSavedAddressCell
        cell.selectBtn.setImage(UIImage(named: "circle"), for: .normal)
        if let index = selectedAddress.firstIndex(where: {$0["id"]! == InvoiceSavedListArr[indexPath.row].id ?? ""}) {
            selectedAddress.remove(at: index)
        }
        print(selectedAddress)
        print("DeSelect")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98
    }
    
}

extension UINavigationController {
    func pushViewController(viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        pushViewController(viewController, animated: animated)

        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }

    func backViewController(animated: Bool, completion: @escaping () -> Void) {
        popViewController(animated: animated)

        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
}
