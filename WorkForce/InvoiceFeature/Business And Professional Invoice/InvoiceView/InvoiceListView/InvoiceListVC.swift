//
//  InvoiceListVC.swift
//  WorkForce
//
//  Created by apple on 16/06/23.
//

import UIKit
import Alamofire
class InvoiceListVC: UIViewController {
    
//    MARK: OUTLETS
    
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var invoiceListTableView: UITableView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var backbtn: UIButton!
    
    var invoiceListData = [InvoiceListData]()
    var checkBook:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hitInvoiceListApi()
        self.tabBarController?.tabBar.isHidden = true
    }
    
//    MARK: SET_TABLE_LIST
    func setTable(){
        invoiceListTableView.delegate = self
        invoiceListTableView.dataSource = self
        invoiceListTableView.register(UINib(nibName: "invoicelistCells", bundle: nil), forCellReuseIdentifier: "invoicelistCells")
    }
    
    
    @IBAction func backbtn(_ sender: UIButton) {
        if checkBook == true{
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let homeVC = TabBarVC()
            homeVC.selectedIndex = 4
            let nav = UINavigationController()
            nav.setViewControllers([homeVC], animated: true)
            nav.navigationBar.isHidden = true
            appdelegate.window?.rootViewController = nav
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func searchBtnAction(_ sender: UIButton) {
      let vc = InvoiceSearchVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addBtn(_ sender: UIButton) {
        let vc = NewEstimateAddressVC()
        vc.estimateNumber = invoiceListData.first?.estimate_no ?? ""
        vc.invoiceListData = invoiceListData
        self.navigationController?.pushViewController(vc, animated: true)
    }

    //    MARK: GET USER LIST FOR INVOICE LIST SCREEN
    func hitInvoiceListApi() {
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let param = ["page_no" : "1","per_page" : "40"] as [String : Any]
        print(param)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.invoiceEstimateList, params: param, headers: headers) { [self] (response) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aContact = try jsonDecoder.decode(InvoicelistModel.self, from: data!)
                print(aContact)
                let status = aContact.status
                let message = aContact.message
                if status == 1{
                    self.invoiceListData.removeAll()
                    self.invoiceListData = aContact.data!
                    self.invoiceListTableView.setBackgroundView(message: "")
                    self.invoiceListTableView.reloadData()
                }
                else if status == 0{
                    self.invoiceListTableView.setBackgroundView(message: message!)
                    self.invoiceListData.removeAll()
                    self.invoiceListTableView.reloadData()
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
extension InvoiceListVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoiceListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "invoicelistCells", for: indexPath) as! invoicelistCells
        cell.lblText.text = invoiceListData[indexPath.row].invoice_number ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let invoice = InvoiceGetDetailView()
        invoice.invoiceId = invoiceListData[indexPath.row].id ?? ""
        self.navigationController?.pushViewController(invoice, animated: true)
    }
}
