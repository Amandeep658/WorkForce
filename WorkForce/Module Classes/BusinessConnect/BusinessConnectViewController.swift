//
//  BusinessConnectViewController.swift
//  WorkForce
//
//  Created by Dharmani Apps on 17/05/22.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift
import SDWebImage

class BusinessConnectViewController: UIViewController {
    
    @IBOutlet weak var connectTableView: UITableView!
    @IBOutlet weak var connectSegmentControl: UISegmentedControl!
    
    var currentIndex = Int()
    var connectCompanyList = [BusinessConnectCompanyListData]()
    var connectlikeCompanyList = [BusinessConnectCompanyListData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        self.connectSegmentControl.selectedSegmentIndex = self.currentIndex
        if connectSegmentControl.selectedSegmentIndex == 0{
            self.getConnectHitList()
            self.connectTableView.reloadData()
        }else if connectSegmentControl.selectedSegmentIndex == 1{
            self.getConnectCompanyList()
            self.connectTableView.reloadData()
        }
        connectSegmentControl.addTarget(self, action: #selector(BusinessConnectViewController.indexChanged(_:)), for: .valueChanged)
        self.connectTableView.reloadData()
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        self.currentIndex = sender.selectedSegmentIndex
        if connectSegmentControl.selectedSegmentIndex == 0 {
            self.getConnectHitList()
            self.connectTableView.reloadData()
        } else if connectSegmentControl.selectedSegmentIndex == 1 {
            self.getConnectCompanyList()
            self.connectTableView.reloadData()
        }else{
            self.connectTableView.reloadData()
        }
    }
    
    //    MARK: UPDATES
    func uiConfigure(){
        // register tableview
        self.connectTableView.delegate = self
        self.connectTableView.dataSource = self
        self.connectTableView.register(UINib(nibName: "connectListViewCell", bundle: nil), forCellReuseIdentifier: "connectListViewCell")
        // selected option color
        self.connectSegmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        // color of other options
        self.connectSegmentControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        self.connectSegmentControl.backgroundColor = .white
    }

    
//    MARK: CONNECT LIST API
    func getConnectHitList(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.getComapnyConnectList, params: [:], headers: headers) { [self] response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aContact = try jsonDecoder.decode(BusinessConnectComapnyModel.self, from: data!)
                print(aContact)
                let status = aContact.status ?? 0
                let message = aContact.message ?? ""
                if status == 1{
                    self.connectTableView.setBackgroundView(message: "")
                        self.connectCompanyList = aContact.data!
                        let uniqueListData = self.connectCompanyList.unique { $0.user_id}
                        self.connectlikeCompanyList = uniqueListData
                        self.connectTableView.reloadData()
                }else if status == 0{
                    self.connectTableView.setBackgroundView(message: message)
                    self.connectTableView.reloadData()
                }else{
                    print("its connect controller")
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
    
    //    MARK: GET All CUSTOMER JOB LIKE
    func getConnectCompanyList(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.getAllcustomerJobLike, params: [:], headers: headers) { [self] response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aContact = try jsonDecoder.decode(BusinessConnectComapnyModel.self, from: data!)
                print(aContact)
                let status = aContact.status ?? 0
                let message = aContact.message ?? ""
                if status == 1{
                    self.connectCompanyList.removeAll()
                    DispatchQueue.main.async {
                        self.connectTableView.setBackgroundView(message: "")
                        self.connectCompanyList = aContact.data!
                        self.connectTableView.reloadData()
                    }
                }else if status == 0{
                    self.connectTableView.setBackgroundView(message: message)
                    self.connectCompanyList.removeAll()
                    self.connectTableView.reloadData()
                }else{
                    print("")
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
extension BusinessConnectViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if connectSegmentControl.selectedSegmentIndex == 0 {
            return connectlikeCompanyList.count
        }else if connectSegmentControl.selectedSegmentIndex == 1 {
            return connectCompanyList.count
        }else{
            return Int()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "connectListViewCell", for: indexPath) as! connectListViewCell
        if connectSegmentControl.selectedSegmentIndex == 0 {
            var sPhotoStr = connectlikeCompanyList[indexPath.row].photo ?? ""
            sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            cell.workerImgView.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
            cell.workerName.text = connectlikeCompanyList[indexPath.row].username ?? ""
            if connectlikeCompanyList[indexPath.row].catagory_details?.count ?? 0 > 1{
                cell.categoryLbl.text = "\(connectlikeCompanyList[indexPath.row].catagory_details?.first?.category_name ?? "") , \(connectlikeCompanyList[indexPath.row].catagory_details?.last?.category_name ?? "") "
            }
            else{
                cell.categoryLbl.text = "\(connectlikeCompanyList[indexPath.row].catagory_details?.first?.category_name ?? "") "
            }
            if connectlikeCompanyList[indexPath.row].rate_type == "Per Day"{
                if connectlikeCompanyList[indexPath.row].rate_to == "" {
                    cell.rateLbl.text = ""
                }else{
                    cell.rateLbl.text = "$\(connectlikeCompanyList[indexPath.row].rate_to ?? "")/d"
                }
            }else if connectlikeCompanyList[indexPath.row].rate_type == "Per Hour"{
                if connectlikeCompanyList[indexPath.row].rate_to == "" {
                    cell.rateLbl.text = ""
                }else{
                    cell.rateLbl.text = "$\(connectlikeCompanyList[indexPath.row].rate_to ?? "")/h"
                }
            }else{
                cell.rateLbl.text = ""
            }
        }else if connectSegmentControl.selectedSegmentIndex == 1 {
            var sPhotoStr = connectCompanyList[indexPath.row].job_image ?? ""
            sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            cell.workerImgView.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
            cell.workerName.text = connectCompanyList[indexPath.row].username ?? ""
            if connectCompanyList[indexPath.row].catagory_details?.count ?? 0 > 1{
                cell.categoryLbl.text = "\(connectCompanyList[indexPath.row].catagory_details?.first?.category_name ?? "") , \(connectCompanyList[indexPath.row].catagory_details?.last?.category_name ?? "") "
            }
            else{
                cell.categoryLbl.text = "\(connectCompanyList[indexPath.row].catagory_details?.first?.category_name ?? "") "
            }
            cell.rateLbl.text = ""
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if connectSegmentControl.selectedSegmentIndex == 0 {
            let vc = ConnectDetailVC()
            vc.isbool = false
            vc.user_iD = connectlikeCompanyList[indexPath.row].user_id ?? ""
            self.pushViewController(vc, true)
        }else if connectSegmentControl.selectedSegmentIndex == 1 {
            let vc = ConnectCustomerJobListDetailVC()
            vc.user_iD =  connectCompanyList[indexPath.row].user_id ?? ""
            vc.customerJObID = connectCompanyList[indexPath.row].customer_job_id ?? ""
            self.pushViewController(vc, true)
        }
    }
    
}
