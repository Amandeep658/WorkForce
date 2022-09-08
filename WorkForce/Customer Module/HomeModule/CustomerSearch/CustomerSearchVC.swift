//
//  CustomerSearchVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 26/08/22.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift
import SDWebImage

class CustomerSearchVC: UIViewController,UISearchBarDelegate {

//    MARK: OUTLETS
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var opportunityCountLbl: UILabel!
    @IBOutlet weak var customerSearchListTable: UITableView!
    
    var searchCompanyListArr = [NearWorkerData]()
    var page = 100
    var pageCount = 1
    var currentLocation = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customerSearchListTable.delegate = self
        self.customerSearchListTable.dataSource = self
        self.customerSearchListTable.register(UINib(nibName: "companiesTableViewCell", bundle: nil), forCellReuseIdentifier: "companiesTableViewCell")
        self.searchBar.delegate = self
        self.opportunityCountLbl.text  = "0 \("Companies Opportunity".localized())"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.popVC()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == ""{
            showAlert(message: "ENTER_COMPANY_NAME".localized(), title: AppAlertTitle.appName.rawValue)
            self.customerSearchListTable.reloadData()
        }else{
            self.homeSearchJobListing()
            self.customerSearchListTable.reloadData()
            self.searchBar.endEditing(true)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        self.filterSearchData(searchText: searchText)
//        homeSearchJobListing()
    }
    func filterSearchData(searchText : String){
        if searchText == ""{
            self.page = 100
            self.pageCount = 1
            self.searchCompanyListArr.removeAll()
            self.opportunityCountLbl.text  = "0 \("Companies Opportunity".localized())"
            self.customerSearchListTable.reloadData()
        }
        else{
            let fltr = searchCompanyListArr.filter({$0.company_name?.lowercased() == searchText.lowercased()})
            self.searchCompanyListArr = fltr
            self.customerSearchListTable.reloadData()
        }
    }
    
    
    //    MARK: HIT JOB LISTNING API
    func homeSearchJobListing(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "", view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.getNearByCompanyListing, params: hitJobListingParameters(), headers: headers) { [self] response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aContact = try jsonDecoder.decode(JobNearMeModel.self, from: data!)
                print(aContact)
                let status = aContact.status ?? 0
                let message = aContact.message ?? ""
                if status == 1{
                    self.searchCompanyListArr =  aContact.data!
                    if searchCompanyListArr.count > 0 {
                        self.customerSearchListTable.backgroundView =  nil
                        self.opportunityCountLbl.text = "\(searchCompanyListArr.count) Companies Opportunity"
                    }else{
                        self.opportunityCountLbl.text = "0 \("Companies Opportunity".localized())"
                        self.customerSearchListTable.setBackgroundView(message: message)
                    }
                    self.customerSearchListTable.reloadData()
                }else{
                    self.searchCompanyListArr.removeAll()
                    self.customerSearchListTable.reloadData()
                    showAlert(message: message, title: AppAlertTitle.appName.rawValue)
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
    func hitJobListingParameters() -> [String:Any] {
        var parameters : [String:Any] = [:]
        parameters["page_no"] = "1" as AnyObject
        parameters["per_page"] = "100" as AnyObject
        parameters["search"] = searchBar.text!
        parameters["deviceType"] = "1"  as AnyObject
        parameters["deviceToken"] = AppDefaults.deviceToken
        print(parameters)
        return parameters
    }
    
}
extension CustomerSearchVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchCompanyListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "companiesTableViewCell", for: indexPath) as! companiesTableViewCell
        var sPhotoStr = searchCompanyListArr[indexPath.row].photo ?? ""
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        cell.imgView.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
        cell.locationLbl.text = searchCompanyListArr[indexPath.row].location ?? ""
        cell.companyNameLbl.text = searchCompanyListArr[indexPath.row].company_name ?? ""
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let vc = CustomerSearchDetailVC()
        vc.anyId = searchCompanyListArr[indexPath.row].user_id ?? ""
        self.pushViewController(vc, true)
    }
}

