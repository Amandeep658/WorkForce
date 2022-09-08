//
//  SearchVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 12/07/22.
//

import UIKit
import Alamofire
import SDWebImage
import IQKeyboardManagerSwift

class SearchVC: UIViewController,UISearchBarDelegate {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchListTableView: UITableView!
    @IBOutlet weak var countLabel: UILabel!
    
    var searchjobListArr = [NearWorkerData]()
    var page = 100
    var pageCount = 1
    var currentLocation = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchListTableView.delegate = self
        self.searchListTableView.dataSource = self
        self.searchListTableView.register(UINib(nibName: "ConnectTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.searchBar.delegate = self
        self.countLabel.text  = "0 \("Job Opportunity".localized())"
        self.searchListTableView.setBackgroundView(message: "No Job found.".localized())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.popVC()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == ""{
            showAlert(message: "Please enter category name".localized(), title: AppAlertTitle.appName.rawValue)
            self.searchListTableView.reloadData()
        }else{
            self.homeSearchJobListing()
            self.searchListTableView.reloadData()
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
            self.searchjobListArr.removeAll()
            self.countLabel.text  = "0 \("Job Opportunity".localized())"
            self.searchListTableView.reloadData()
        }
        else{
            let fltr = searchjobListArr.filter({$0.category_name?.lowercased() == searchText.lowercased()})
            self.searchjobListArr = fltr
            self.searchListTableView.reloadData()
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
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.jobListing, params: hitJobListingParameters(), headers: headers) { [self] response in
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
                    self.searchjobListArr =  aContact.data!
                    if searchjobListArr.count > 0 {
                        self.searchListTableView.backgroundView =  nil
                        self.countLabel.text = "\(searchjobListArr.count) \("Job Opportunity".localized())"
                    }else{
                        self.countLabel.text = "0 \("Job Opportunity".localized())"
                        self.searchListTableView.setBackgroundView(message: message)
                    }
                    self.searchListTableView.reloadData()
                }else{
                    self.searchjobListArr.removeAll()
                    self.searchListTableView.reloadData()
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
extension SearchVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchjobListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConnectTableViewCell
        let singleTap = UITapGestureRecognizer(target: self,action:  #selector(imageTapped))
        cell.cellImg.isUserInteractionEnabled = true
        cell.cellImg.addGestureRecognizer(singleTap)
        cell.viewLeading.constant = 15
        cell.viewTop.constant = 15
        cell.viewTrailing.constant = 15
        cell.viewBottom.constant = 2
        cell.layer.cornerRadius = 15
        var sPhotoStr = searchjobListArr[indexPath.row].job_image ?? ""
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        cell.cellImg.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
        cell.designerLbl.text = searchjobListArr[indexPath.row].category_name ?? ""
        cell.cellLbl.text = searchjobListArr[indexPath.row].company_name ?? ""
        if searchjobListArr[indexPath.row].rate_type == "Per Day"{
            if searchjobListArr[indexPath.row].rate_to == "" {
                cell.priceLbl.text = ""
            }else{
                cell.priceLbl.text = "$\(searchjobListArr[indexPath.row].rate_to ?? "")/d"
            }
        }else if searchjobListArr[indexPath.row].rate_type == "Per Hour"{
            if searchjobListArr[indexPath.row].rate_to == ""{
                cell.priceLbl.text = ""
            }else{
            cell.priceLbl.text = "$\(searchjobListArr[indexPath.row].rate_to ?? "")/h"
            }
        }else{
            cell.priceLbl.text = ""
        }
        cell.contentListView.backgroundColor = .clear
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SearchDetailVC()
        vc.job_id = searchjobListArr[indexPath.row].job_id ?? ""
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc, true)
    }
    @objc func imageTapped() {
        let vc = ITServicesViewController()
        self.pushViewController(vc, true)
    }
}
