//
//  BusinessDesignerViewController.swift
//  WorkForce
//
//  Created by Dharmani Apps on 02/06/22.
//

import UIKit
import Alamofire

class BusinessDesignerViewController: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var connectBtn: UIButton!
    @IBOutlet weak var notConnectBtn: UIButton!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var categoryNameLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var btnHourAmountlbl: UIButton!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var experienceLbl: UITextField!
    @IBOutlet weak var jobTypeLbl: UITextField!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionHeader: UILabel!
    
    var userID = ""
    var workerDetailUserDate:ProfessionalProfileData?
    var jobWorkerDetailArr = [NearWorkerData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        self.hitUserListDetailApi()
        self.descriptionView.isHidden = true
        self.descriptionLbl.isHidden = true
        self.descriptionHeader.isHidden = true
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popViewController(true)
    }
    
    @IBAction func connectAction(_ sender: UIButton) {
        getCompanyWorkerLike()
    }
    
    @IBAction func notConnectAction(_ sender: UIButton) {
        self.popViewController(true)
    }
    
    //    MARK: HIT USERDETAIL
    func hitUserListDetailApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading", view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let param = ["user_id": userID ] as [String : Any]
        print(param)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.getWorkerDetail, params: param, headers: headers) { [self] response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aContact = try jsonDecoder.decode(ApiModel<ProfessionalProfileData>.self, from: data!)
                print(aContact)
                let status = aContact.status
                let message = aContact.message ?? ""
                if status == 1{
                    DispatchQueue.main.async { [self] in
                        self.workerDetailUserDate = aContact.data
                        self.userNameLbl.text = workerDetailUserDate?.username ?? ""
                        if workerDetailUserDate?.description != nil{
                            self.descriptionLbl.text = workerDetailUserDate?.description ?? ""
                        }else{
                            self.descriptionLbl.text = "N/A"
                        }
                        
                        if workerDetailUserDate?.rate_type == "Per Day"{
                            if workerDetailUserDate?.rate_to == "" {
                                self.btnHourAmountlbl.setTitle("No rate selected.", for: .normal)
                            }else{
                                self.btnHourAmountlbl.setTitle("$\(workerDetailUserDate?.rate_to ?? "")/d", for: .normal)
                            }
                        }else if workerDetailUserDate?.rate_type == "Per Hour"{
                            if workerDetailUserDate?.rate_to == "" {
                                self.btnHourAmountlbl.setTitle("No rate selected.", for: .normal)
                            }else{
                                self.btnHourAmountlbl.setTitle("$\(workerDetailUserDate?.rate_to ?? "")/h", for: .normal)
                            }
                        }else{
                            self.btnHourAmountlbl.setTitle("No rate selected.", for: .normal)
                        }
                        if workerDetailUserDate?.catagory_details?.count ?? 0 > 1{
                            self.categoryNameLbl.text = "\(workerDetailUserDate?.catagory_details?.first?.category_name ?? "") , \(workerDetailUserDate?.catagory_details?.last?.category_name ?? "") "
                        }
                        else{
                            self.categoryNameLbl.text = "\(workerDetailUserDate?.catagory_details?.first?.category_name ?? "") "
                        }
                        self.jobTypeLbl.text = workerDetailUserDate?.job_type ?? ""
                        if workerDetailUserDate?.catagory_details == nil{
                            self.experienceLbl.text = "0 Year"
                        }else{
                            let exp0 = Double(workerDetailUserDate?.catagory_details?.first?.experience ?? "0") ?? 0.0
                            let exp1 = Double(workerDetailUserDate?.catagory_details?.last?.experience ?? "0") ?? 0.0
                            if workerDetailUserDate?.catagory_details?.count ?? 0 > 1 {
                                self.experienceLbl.text = "\(workerDetailUserDate?.catagory_details?.first?.experience ?? "0" ) \(exp0 > 1.0 ? "Years" : "Year") , \(workerDetailUserDate?.catagory_details?.last?.experience ?? "0") \(exp1 > 1.0 ? "Years" : "Year") "
                            }
                            else{
                                self.experienceLbl.text = "\(workerDetailUserDate?.catagory_details?.first?.experience ?? "0") \(exp0 > 1.0 ? "Years" : "Year")"
                            }
                        }
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        if let date = dateFormatter.date(from: workerDetailUserDate?.date_of_birth ?? "") {
                            let age = Calendar.current.dateComponents([.year], from: date, to: Date()).year!
                            print(age)
                            self.ageLbl.text =  "\(Int(age)) Years"
                        }
                        var sPhotoStr = workerDetailUserDate?.photo ?? ""
                        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                        self.userImgView.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
                    }
                }else{
                    alert(AppAlertTitle.appName.rawValue, message: message, view: self)
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
    
//    MARK: GET COMPANY WORKER CONNECT
    func getCompanyWorkerLike(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading", view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let param = ["other_id": userID , "cat_id" : workerDetailUserDate?.catagory_details?.first?.cat_id ?? "" ] as [String : Any]
        print(param)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.workerLikeOrUnlike, params: param, headers: headers) { [self] response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            let status = response["status"] as? Int ?? 0
            let message = response["message"] as? String ?? ""
            if status == 1 {
                let navVC = tabBarController?.viewControllers![1] as! UINavigationController//
                let cartTableViewController = navVC.topViewController as! BusinessConnectViewController
                cartTableViewController.currentIndex = 0
                print("cartTableViewController.currentIndex*****************>>>>>>>>>",cartTableViewController.currentIndex)
                self.tabBarController?.selectedIndex = 1
                }else{
                    print(message)
            }
        
        } failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
}
