//
//  SearchListVC.swift
//  WorkForce
//
//  Created by apple on 21/06/22.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire
import SDWebImage

class SearchListVC: UIViewController,UISearchBarDelegate {
    
//    MARK: OUTLETS
    @IBOutlet weak var searchListTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var backBtn: UIButton!
    
    var searchjobListArr = [NearWorkerData]()
    var page = 100
    var pageCount = 1
    var currentLocation = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchListTableView.delegate = self
        searchListTableView.dataSource = self
        searchListTableView.register(UINib(nibName: "ConnectTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        searchBar.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
//        self.nearByWorkerList()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == ""{
            showAlert(message: "Please enter category name".localized(), title: AppAlertTitle.appName.rawValue)
        }else{
            self.nearByWorkerList()
            self.searchListTableView.reloadData()
            self.searchBar.endEditing(true)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        self.filterSearchData(searchText: searchText)
    }
    func filterSearchData(searchText : String){
        if searchText == " "{
            self.page = 0
            self.pageCount = 1
            self.searchListTableView.reloadData()
        }
        else{
            let fltr = searchjobListArr.filter({$0.category_name?.lowercased() == searchText.lowercased()})
            self.searchjobListArr = fltr
            self.searchListTableView.reloadData()
        }
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.popVC()
    }
    
    //    MARK: HIT NEAR BY WORKER
        func nearByWorkerList(){
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudShow( title: "LOADING".localized(), view: self)
            }
            let authToken  = AppDefaults.token ?? ""
            let headers: HTTPHeaders = ["Token":authToken]
            print(headers)
            AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.nearByWorker, params: hitnearWorkerListingParameters(), headers: headers) { [self] response in
                AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                    let reqJSONStr = String(data: jsonData, encoding: .utf8)
                    let data = reqJSONStr?.data(using: .utf8)
                    let jsonDecoder = JSONDecoder()
                    let aContact = try jsonDecoder.decode(NearByWorkerModel.self, from: data!)
                    print(aContact)
                    let status = aContact.status ?? 0
                    let message = aContact.message ?? ""
                    if status == 1{
                        self.searchjobListArr = aContact.data!
                        self.searchListTableView.reloadData()
                    } else if status == 0{
                        if searchjobListArr.count > 0 {
                        self.searchListTableView.backgroundView =  nil
                    }else{
                        self.searchListTableView.setBackgroundView(message: message)
                    }
                        
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
    
    func hitnearWorkerListingParameters() -> [String:Any] {
        var parameters : [String:Any] = [:]
        parameters["page_no"] = "1" as AnyObject
        parameters["per_page"] = "100" as AnyObject
        parameters["location"] = currentLocation as AnyObject
        parameters["search"] = searchBar.text!
        parameters["deviceType"] = "1"  as AnyObject
        parameters["deviceToken"] = AppDefaults.deviceToken
        print(parameters)
        return parameters
    }
    
    

}
extension SearchListVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchjobListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConnectTableViewCell
        var sPhotoStr = searchjobListArr[indexPath.row].photo ?? ""
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        cell.cellImg.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
        cell.designerLbl.text = searchjobListArr[indexPath.row].category_name ?? ""
        cell.cellLbl.text = searchjobListArr[indexPath.row].username ?? ""
        if searchjobListArr[indexPath.row].rate_type == "Per Day"{
            if searchjobListArr[indexPath.row].rate_to == ""{
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
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BusinessDesignerViewController()
        vc.userID = searchjobListArr[indexPath.row].user_id ?? ""
        self.pushViewController(vc, true)
    }
    
    
}
