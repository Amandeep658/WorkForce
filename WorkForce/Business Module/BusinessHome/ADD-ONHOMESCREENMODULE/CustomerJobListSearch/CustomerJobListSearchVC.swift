//
//  CustomerJobListSearchVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 30/08/22.
//

import UIKit
import Alamofire
import SDWebImage

class CustomerJobListSearchVC: UIViewController,UISearchBarDelegate  {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var customersearchBar: UISearchBar!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var customerShowTableView: UITableView!

    var jobNearMeArr = [ProfessionalListJobData]()
    var page = 100
    var pageCount = 1


    override func viewDidLoad() {
        super.viewDidLoad()
        self.customerShowTableView.delegate = self
        self.customerShowTableView.dataSource = self
        self.customerShowTableView.register(UINib(nibName: "companiesTableViewCell", bundle: nil), forCellReuseIdentifier: "companiesTableViewCell")
        self.customersearchBar.delegate = self
        self.countLbl.text  = "0 \("Customers Opportunity".localized())"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.popVC()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == ""{
            showAlert(message: "Please enter company name".localized(), title: AppAlertTitle.appName.rawValue)
            self.customerShowTableView.reloadData()
        }else{
            self.hitCoustomerListingApi()
            self.customerShowTableView.reloadData()
            self.customersearchBar.endEditing(true)
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
            self.jobNearMeArr.removeAll()
            self.countLbl.text  = "0 \("Customers Opportunity".localized())"
            self.customerShowTableView.reloadData()
        }
        else{
            let fltr = jobNearMeArr.filter({$0.company_name?.lowercased() == searchText.lowercased()})
            self.jobNearMeArr = fltr
            self.customerShowTableView.reloadData()
        }
    }
    
    
    //    MARK: HIT COUSTOMER JOB LISTING API
        func hitCoustomerListingApi(){
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
            }
            let authToken  = AppDefaults.token ?? ""
            let headers: HTTPHeaders = ["Token":authToken]
            print(headers)
            AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.nearCustomerByJobs, params: hitCustomerJobListingParameters(), headers: headers) { [self] response in
                AFWrapperClass.svprogressHudDismiss(view: self)
                print(response)
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                    let reqJSONStr = String(data: jsonData, encoding: .utf8)
                    let data = reqJSONStr?.data(using: .utf8)
                    let jsonDecoder = JSONDecoder()
                    let aContact = try jsonDecoder.decode(ProfessionalmoduleHome.self, from: data!)
                    print(aContact)
                    let status = aContact.status ?? 0
                    let message =  aContact.message ?? ""
                    if status == 401 {
                        UserDefaults.standard.removeObject(forKey: "authToken")
                        appDel.navigation()
                    }else if status == 1 {
                        self.jobNearMeArr = aContact.data!
                        if jobNearMeArr.count > 0 {
                            self.customerShowTableView.backgroundView =  nil
                            self.countLbl.text = "\(jobNearMeArr.count) \("Customers Opportunity".localized())"
                        }else{
                            self.countLbl.text = "0 \("Customers Opportunity".localized())"
                            self.customerShowTableView.setBackgroundView(message: message)
                        }
                        self.customerShowTableView.reloadData()
                    }else if status == 0{
                        self.customerShowTableView.setBackgroundView(message: message)
                        self.customerShowTableView.reloadData()
                    }else{
                        print("")
                    }
                }
                catch let parseError {
                    print("JSON Error \(parseError.localizedDescription)")
                }
                
            } failure: { error in
                AFWrapperClass.svprogressHudDismiss(view: self)
            }
        }
    
//    MARK: GET CUSTOMER JOB LIST PARAMETERS
    func hitCustomerJobListingParameters() -> [String:Any] {
        var parameters : [String:Any] = [:]
        parameters["page_no"] = "1" as AnyObject
        parameters["per_page"] = "100" as AnyObject
        parameters["search"] = customersearchBar.text!
        parameters["deviceType"] = "1"  as AnyObject
        parameters["deviceToken"] = AppDefaults.deviceToken
        print(parameters)
        return parameters
    }


}

extension CustomerJobListSearchVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobNearMeArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "companiesTableViewCell", for: indexPath) as! companiesTableViewCell
        var sPhotoStr = jobNearMeArr[indexPath.row].job_image ?? ""
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        cell.imgView.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
        if jobNearMeArr[indexPath.row].catagory_details?.count ?? 0 > 1{
            cell.locationLbl.text = "\(jobNearMeArr[indexPath.row].catagory_details?.first?.category_name ?? "") , \(jobNearMeArr[indexPath.row].catagory_details?.last?.category_name ?? "") "
        }
        else{
            cell.locationLbl.text = "\(jobNearMeArr[indexPath.row].catagory_details?.first?.category_name ?? "") "
        }
        cell.companyNameLbl.text = jobNearMeArr[indexPath.row].username ?? ""
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CustomerJobSearchListDetailVC()
        vc.cat_id =  jobNearMeArr[indexPath.row].catagory_details?.first?.cat_id ?? ""
        vc.customerJobId = jobNearMeArr[indexPath.row].customer_job_id ?? ""
        self.pushViewController(vc, true)
    }
}
