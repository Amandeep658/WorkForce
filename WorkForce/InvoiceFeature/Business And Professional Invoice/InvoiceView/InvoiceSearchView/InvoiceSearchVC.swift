//
//  InvoiceSearchVC.swift
//  WorkForce
//
//  Created by apple on 16/06/23.
//

import UIKit
import Alamofire

class InvoiceSearchVC: UIViewController,UISearchBarDelegate {

//    MARK: OUTLETS
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    var invoiceListData = [InvoiceListData]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
    }
    
    //    MARK: SET_TABLE_LIST
    func setTable(){
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(UINib(nibName: "invoicelistCells", bundle: nil), forCellReuseIdentifier: "invoicelistCells")
        searchBar?.delegate = self
        self.searchTableView.setBackgroundView(message: "No invoice list.")

    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //    MARK: SEARCHBAR DELEGATES
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar?.endEditing(true)
        hitInvoiceSearchListApi(invoiceNumber: searchBar.text ?? "")

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        self.filterSearchData(searchText: searchText)
    }
    func filterSearchData(searchText : String){
        if searchText == ""{
            self.invoiceListData.removeAll()
            self.searchTableView.reloadData()
            self.searchTableView.setBackgroundView(message: "No invoice list.")
        }
        else{
            let filterData = invoiceListData.filter{(x) -> Bool in
                (x.invoice_number!.lowercased().range(of: searchText.lowercased()) != nil)
            }
            self.invoiceListData = filterData
            self.searchTableView.reloadData()
        }
    }
    
    
    //    MARK: GET USER LIST FOR INVOICE LIST SCREEN
    func hitInvoiceSearchListApi(invoiceNumber:String){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.invoiceEstimateList, params: ["invoice_number":"\(invoiceNumber)"], headers: headers) { [self] (response) in
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
                    self.invoiceListData = aContact.data!
                    self.searchTableView.setBackgroundView(message: "")
                    self.searchTableView.reloadData()
                }
                else if status == 0{
                    self.searchTableView.setBackgroundView(message: message!)
                    self.invoiceListData.removeAll()
                    self.searchTableView.reloadData()
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
extension InvoiceSearchVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoiceListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "invoicelistCells", for: indexPath) as! invoicelistCells
        cell.lblText.text = invoiceListData[indexPath.row].invoice_number
        return cell

    }
    
    
}
