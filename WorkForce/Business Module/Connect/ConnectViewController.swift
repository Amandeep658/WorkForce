//
//  ConnectViewController.swift
//  WorkForce
//
//  Created by apple on 06/05/22.
//

import UIKit
import Alamofire
import SDWebImage
import IQKeyboardManagerSwift

class ConnectViewController: UIViewController {
    
    @IBOutlet weak var jobBtn: UIButton!
    @IBOutlet weak var jobLbl: UILabel!
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var companyBtn: UIButton!
    @IBOutlet weak var connectTableView: UITableView!
        
    var connectjobList = [BusinessConnectCompanyListData]()
    var showConnectJobListArr = [BusinessConnectCompanyListData]()
    var connectcompanyList = [NearWorkerData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        self.uiUpdate()
        self.jobBtn.isSelected = true
        self.companyBtn.isSelected =  false
        self.companyLbl.backgroundColor = UIColor.lightGray
        self.jobLbl.backgroundColor = #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)
        self.getConnectHitList()
        self.connectTableView.reloadData()
    }
    
    func uiUpdate(){
        connectTableView.delegate = self
        connectTableView.dataSource = self
        connectTableView.register(UINib(nibName: "connectListViewCell", bundle: nil), forCellReuseIdentifier: "connectListViewCell")
    }
    
    @IBAction func jobAction(_ sender: UIButton) {
        if !jobBtn.isSelected {
            self.jobBtn.isSelected =  true
            self.companyBtn.isSelected =  false
            self.companyLbl.backgroundColor = UIColor.lightGray
            self.jobLbl.backgroundColor = #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)
            self.getConnectHitList()
            self.connectTableView.reloadData()

        }
    }
    @IBAction func companyAction(_ sender: UIButton) {
        if !companyBtn.isSelected {
            self.jobBtn.isSelected =  false
            self.companyBtn.isSelected =  true
            self.companyLbl.backgroundColor = #colorLiteral(red: 0.2634587288, green: 0.6802290082, blue: 0.8391065001, alpha: 1)
            self.jobLbl.backgroundColor = UIColor.lightGray
            hitSubscriptionCheckforChatApi()
        }
    }
    
    
//    MARK: GET COMPANT LIST CHECK SUBSCRIPTION
    
    func hitSubscriptionCheckforChatApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        let authToken = AppDefaults.token ?? ""
        let header: HTTPHeaders = ["Token": authToken]
        print("subscriptionStatus == >>>>", header)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.subscriptionstatus, params: [:], headers: header) { [self] (response) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            let status = response["status"] as? Int ?? 0
            print(status)
            if status == 1 {
                if UserType.userTypeInstance.userLogin == .Professional{
                    self.getConnectCompanyList()
                    self.connectTableView.reloadData()
                }
            }else if status == 0{
               if UserType.userTypeInstance.userLogin == .Professional{
                    let vc = SubcribeViewController()
                    vc.VC = self
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, true)
                }
            }
        } failure: { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
            }
    }
    
    
    
    //    MARK: GET JOB LIST
    func getConnectHitList(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.getAllJobLike, params: [:], headers: headers) { [self] response in
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
                    self.connectjobList.removeAll()
                    DispatchQueue.main.async {
                        self.connectTableView.setBackgroundView(message: "")
                        self.connectjobList = aContact.data!
//                        let uniqueListData = self.connectjobList.unique { $0.user_id}
                        self.showConnectJobListArr = self.connectjobList
                        self.connectTableView.reloadData()
                    }
                }else if status == 0{
                    self.connectTableView.setBackgroundView(message: message)
                    self.connectTableView.reloadData()
                }else{
                    print("Its connect view controller")
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
    
    //    MARK: GET COMPANIES LIST
    func getConnectCompanyList(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.getCompaniesList, params: [:], headers: headers) { [self] response in
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
                    self.connectcompanyList.removeAll()
                    DispatchQueue.main.async {
                        self.connectTableView.setBackgroundView(message: "")
                        self.connectcompanyList = aContact.data!
                        self.connectTableView.reloadData()
                    }
                }else if status == 0{
                    self.connectTableView.setBackgroundView(message: message)
                    self.connectcompanyList.removeAll()
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
    
//    MARK: BACKGROUND THREAD
    
}
extension ConnectViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if jobBtn.isSelected {
            return showConnectJobListArr.count
        }else{
            return connectcompanyList.count
        }
        return Int()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "connectListViewCell", for: indexPath) as! connectListViewCell
        if jobBtn.isSelected {
            var sPhotoStr = showConnectJobListArr[indexPath.row].job_image ?? ""
            sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            cell.workerImgView.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
            cell.workerName.text = showConnectJobListArr[indexPath.row].company_name ?? ""
            if showConnectJobListArr[indexPath.row].catagory_details?.count ?? 0 > 1{
                cell.categoryLbl.text = "\(showConnectJobListArr[indexPath.row].catagory_details?.first?.category_name ?? "") , \(showConnectJobListArr[indexPath.row].catagory_details?.last?.category_name ?? "") "
            }
            else{
                cell.categoryLbl.text = "\(showConnectJobListArr[indexPath.row].catagory_details?.first?.category_name ?? "") "
            }
            if showConnectJobListArr[indexPath.row].rate_type == "Per Day"{
                if showConnectJobListArr[indexPath.row].rate_from == "" || showConnectJobListArr[indexPath.row].rate_to == "" {
                    cell.rateLbl.text = ""
                    cell.rateLbl.isHidden = true
                }else{
                    cell.rateLbl.isHidden = false
                    cell.rateLbl.text = "$\(showConnectJobListArr[indexPath.row].rate_from ?? "")/d - $\(showConnectJobListArr[indexPath.row].rate_to ?? "")/d"
                }
            }else if showConnectJobListArr[indexPath.row].rate_type == "Per Hour"{
                if showConnectJobListArr[indexPath.row].rate_from == "" || showConnectJobListArr[indexPath.row].rate_to == "" {
                    cell.rateLbl.text = ""
                    cell.rateLbl.isHidden = true
                }else{
                    cell.rateLbl.isHidden = false
                    cell.rateLbl.text = "$\(showConnectJobListArr[indexPath.row].rate_from ?? "")/h - $\(showConnectJobListArr[indexPath.row].rate_to ?? "")/h"
                }
            }else{
                cell.rateLbl.isHidden = true
                cell.rateLbl.text = ""
            }
        }else{
            var sPhotoStr = connectcompanyList[indexPath.row].photo ?? ""
            sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            cell.workerImgView.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
            cell.workerName.text = connectcompanyList[indexPath.row].company_name ?? ""
            cell.rateLbl.isHidden = true
            cell.categoryLbl.text = connectcompanyList[indexPath.row].location ?? ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if jobBtn.isSelected{
            let vc = ConnectDetailVC()
            vc.isbool = true
            vc.user_iD = showConnectJobListArr[indexPath.row].user_id ?? ""
            vc.connectJobjobId = showConnectJobListArr[indexPath.row].job_id ?? ""
            self.pushViewController(vc, true)
        }else{
            let vc = NikeIncDesignerViewController()
            vc.isNav = true
            vc.connectcompanyList = connectcompanyList[indexPath.row]
            self.pushViewController(vc, true)
        }
    
    }
}
//------------------------------------------------------
extension Array {
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }
        
        return arrayOrdered
    }
}

extension DispatchQueue {
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }

}
