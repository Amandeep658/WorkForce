//
//  ConnectDetailVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 13/07/22.
//

import UIKit
import Alamofire
import SDWebImage

class ConnectDetailVC: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var amountBtn: UIButton!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var experinceLbl: UITextField!
    @IBOutlet weak var jobTypeLbl: UITextField!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var descriptionView: UIView!
    
    var user_iD = ""
    var connectJobjobId = ""
    var isbool:Bool?
    var workerDetailUserDate:ProfessionalProfileData?
    var jobDetailByJobId:JobDetailByJobIdModel?
    var createRoomData:BusinessCreateRoomModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        if isbool == false{
            self.descriptionView.isHidden = true
            self.hitUserListDetailApi()
        }else if isbool == true{
            self.descriptionView.isHidden = false
            self.hitJobListDetailApi()
        }
    }
    
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
                if UserType.userTypeInstance.userLogin == .Bussiness{
                    self.hitRoomCreateApi()
                    print("business")
                }else if UserType.userTypeInstance.userLogin == .Professional{
                    self.hitRoomCreateApi()
                    print("professional")
                }
            }else if status == 0{
                if UserType.userTypeInstance.userLogin == .Bussiness{
                    let vc = SubcribeViewController()
                    vc.VC = self
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, true)
                }else if UserType.userTypeInstance.userLogin == .Professional{
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
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func chatButton(_ sender: UIButton) {
        hitSubscriptionCheckforChatApi()
    }
    
    //    MARK: CHAT ROOM CREATED API
    func hitRoomCreateApi(){
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let param = ["other_id": user_iD ] as [String : Any]
        print(param)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.createRoom, params: param, headers: headers) { [self] response in
            print(response)
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aContact = try jsonDecoder.decode(BusinessCreateRoomModel.self, from: data!)
                print(aContact)
                let status = aContact.status
                let message = aContact.message ?? ""
                if status == 1{
                    self.createRoomData = aContact
                    if UserType.userTypeInstance.userLogin == .Bussiness{
                        let vc = SingleChatController()
                        vc.chatRoomId = createRoomData?.room_id ?? ""
                        vc.user_ID =  createRoomData?.user_detail?.user_id ?? ""
                        vc.userName = workerDetailUserDate?.username ?? ""
                        vc.userProfileImage = createRoomData?.user_detail?.photo ?? ""
                        self.pushViewController(vc, true)
                    }else if UserType.userTypeInstance.userLogin == .Professional{
                        let vc = SingleChatController()
                        vc.chatRoomId = createRoomData?.room_id ?? ""
                        vc.user_ID =  createRoomData?.user_detail?.user_id ?? ""
                        vc.companyname =  createRoomData?.user_detail?.company_name ?? ""
                        vc.userName = workerDetailUserDate?.username ?? ""
                        vc.userProfileImage = createRoomData?.user_detail?.photo ?? ""
                        self.pushViewController(vc, true)
                    }
                }else{
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
        
    
    //      MARK: HIT JOB DETAIL API
    func hitUserListDetailApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Laoding", view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let param = ["user_id": user_iD ] as [String : Any]
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
                        self.headerLbl.text = workerDetailUserDate?.username ?? ""
                        if workerDetailUserDate?.rate_type == "Per Day"{
                            if workerDetailUserDate?.rate_to == ""{
                                self.amountBtn.setTitle("No rate selected.".localized(), for: .normal)
                            }else{
                                self.amountBtn.setTitle("$\(workerDetailUserDate?.rate_to ?? "")/d", for: .normal)
                            }
                        }else if workerDetailUserDate?.rate_type == "Per Hour"{
                            if workerDetailUserDate?.rate_to == ""{
                                self.amountBtn.setTitle("No rate selected.".localized(), for: .normal)
                            }else{
                                self.amountBtn.setTitle("$\(workerDetailUserDate?.rate_to ?? "")/h", for: .normal)
                            }
                        }else{
                            self.amountBtn.setTitle("No rate selected.".localized(), for: .normal)
                        }
                        if workerDetailUserDate?.catagory_details?.count ?? 0 > 1{
                            self.categoryLbl.text = "\(workerDetailUserDate?.catagory_details?.first?.category_name ?? "") , \(workerDetailUserDate?.catagory_details?.last?.category_name ?? "") "
                        }
                        else{
                            self.categoryLbl.text = "\(workerDetailUserDate?.catagory_details?.first?.category_name ?? "") "
                        }
                        self.jobTypeLbl.text = workerDetailUserDate?.job_type ?? ""
                        if workerDetailUserDate?.catagory_details == nil{
                            self.experinceLbl.text = "0 Year".localized()
                        }else{
                            let exp0 = Double(workerDetailUserDate?.catagory_details?.first?.experience ?? "0") ?? 0.0
                            let exp1 = Double(workerDetailUserDate?.catagory_details?.last?.experience ?? "0") ?? 0.0
                            if workerDetailUserDate?.catagory_details?.count ?? 0 > 1 {
                                self.experinceLbl.text = "\(workerDetailUserDate?.catagory_details?.first?.experience ?? "0" ) \(exp0 > 1.0 ? "Years".localized() : "Year".localized()) , \(workerDetailUserDate?.catagory_details?.last?.experience ?? "0") \(exp1 > 1.0 ? "Years".localized() : "Year".localized()) "
                            }
                            else{
                                self.experinceLbl.text = "\(workerDetailUserDate?.catagory_details?.first?.experience ?? "0") \(exp0 > 1.0 ? "Years".localized() : "Year".localized())"
                            }
                        }
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        if let date = dateFormatter.date(from: workerDetailUserDate?.date_of_birth ?? "") {
                            let age = Calendar.current.dateComponents([.year], from: date, to: Date()).year!
                            print(age)
                            self.locationLbl.text =  "\(Int(age)) Years".localized()
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
    
    //      MARK: HIT CONNECT JOB DETAIL API
    func hitJobListDetailApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let param = ["job_id": connectJobjobId ] as [String : Any]
        print(param)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.getJobDetailById, params: param, headers: headers) { [self] response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aContact = try jsonDecoder.decode(JobDetailByJobIdModel.self, from: data!)
                print(aContact)
                let status = aContact.status
                let message = aContact.message ?? ""
                if status == 1{
                    DispatchQueue.main.async { [self] in
                        self.jobDetailByJobId = aContact
                        print("iyts description show time")
                        self.descriptionLbl.text =  jobDetailByJobId?.data?.description ?? ""
                        self.headerLbl.text = jobDetailByJobId?.data?.company_name ?? ""
                        if jobDetailByJobId?.data?.catagory_details?.count ?? 0 > 1{
                            self.categoryLbl.text = "\(jobDetailByJobId?.data?.catagory_details?.first?.category_name ?? "") , \(jobDetailByJobId?.data?.catagory_details?.last?.category_name ?? "") "
                        }
                        else{
                            self.categoryLbl.text = "\(jobDetailByJobId?.data?.catagory_details?.first?.category_name ?? "") "
                        }
                        if jobDetailByJobId?.data?.rate_type == "Per Day"{
                            if jobDetailByJobId?.data?.rate_from == "" || jobDetailByJobId?.data?.rate_to == "" {
                                self.amountBtn.setTitle("No rate selected.".localized(), for: .normal)
                            }else{
                                self.amountBtn.setTitle("$\(jobDetailByJobId?.data?.rate_from ?? "")/d - $\(jobDetailByJobId?.data?.rate_to ?? "")/d", for: .normal)
                            }
                        }else if jobDetailByJobId?.data?.rate_type == "Per Hour"{
                            if jobDetailByJobId?.data?.rate_from == "" || jobDetailByJobId?.data?.rate_to == "" {
                                self.amountBtn.setTitle("No rate selected.".localized(), for: .normal)
                            }else{
                                self.amountBtn.setTitle("$\(jobDetailByJobId?.data?.rate_from ?? "")/h - $\(jobDetailByJobId?.data?.rate_to ?? "")/h", for: .normal)
                            }
                        }else{
                            self.amountBtn.setTitle("No rate selected.".localized(), for: .normal)
                        }
                        if jobDetailByJobId?.data?.catagory_details == nil{
                            self.experinceLbl.text = "0 Year"
                        }else{
                            let exp0 = Double(jobDetailByJobId?.data?.catagory_details?.first?.experience ?? "0") ?? 0.0
                            let exp1 = Double(jobDetailByJobId?.data?.catagory_details?.last?.experience ?? "0") ?? 0.0
                            if jobDetailByJobId?.data?.catagory_details?.count ?? 0 > 1 {
                                self.experinceLbl.text = "\(jobDetailByJobId?.data?.catagory_details?.first?.experience ?? "0" ) \(exp0 > 1.0 ? "Years".localized() : "Year".localized())  , \(jobDetailByJobId?.data?.catagory_details?.last?.experience ?? "0") \(exp1 > 1.0 ? "Years".localized() : "Year".localized())"
                            }
                            else{
                                self.experinceLbl.text = "\(jobDetailByJobId?.data?.catagory_details?.first?.experience ?? "0") \(exp0 > 1.0 ? "Years".localized() : "Year".localized())"
                            }
                        }
                        self.jobTypeLbl.text = jobDetailByJobId?.data?.job_type ?? ""
                        self.locationLbl.text = jobDetailByJobId?.data?.city ?? ""
                        var sPhotoStr = jobDetailByJobId?.data?.job_image ?? ""
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
    
    
}
