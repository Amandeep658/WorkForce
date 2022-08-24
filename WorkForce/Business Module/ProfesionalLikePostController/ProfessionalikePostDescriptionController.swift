//
//  ProfessionalikePostDescriptionController.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 24/07/22.
//

import UIKit
import Alamofire
import SDWebImage

class ProfessionalikePostDescriptionController: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var connectBtn: UIButton!
    @IBOutlet weak var notConnectBtn: UIButton!
    @IBOutlet weak var userimgView: UIImageView!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var amountBtn: UIButton!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var jobTypelbl: UITextField!
    @IBOutlet weak var experienceLbl: UITextField!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionHeading: UILabel!
    
    var job_id = ""
    var cat_ID = ""
    var userNumberId = ""
    var workerDetailUser:ProfessionalProfileData?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        if UserType.userTypeInstance.userLogin == .Bussiness{
            hitUserListDetailApi()
        }else if UserType.userTypeInstance.userLogin == .Coustomer{
            hitUserListDetailApi()
        }
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func connectBtn(_ sender: UIButton) {
        if UserType.userTypeInstance.userLogin == .Bussiness{
            getCompanyLikeWorker()
        }else if UserType.userTypeInstance.userLogin == .Coustomer{
            getCompanyLikeWorker()
        }
    }
    
    @IBAction func disconnectBtn(_ sender: UIButton) {
        self.popVC()
    }
    
    
    
    //    MARK: WORKER DETAIL
    func hitUserListDetailApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow( title: "Loading", view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let param = ["user_id": userNumberId ] as [String : Any]
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
                        self.workerDetailUser = aContact.data
                        self.headerLbl.text = workerDetailUser?.username ?? ""
                        if workerDetailUser?.description != nil{
                            self.descriptionLbl.text = workerDetailUser?.description ?? ""
                        }else{
                            self.descriptionLbl.text = "N/A"
                        }
                        if workerDetailUser?.rate_type == "Per Day"{
                            if workerDetailUser?.rate_to == ""{
                                self.amountBtn.setTitle("No rate selected", for: .normal)
                            }else{
                                self.amountBtn.setTitle("$\(workerDetailUser?.rate_to ?? "")/d", for: .normal)
                            }
                        }else if workerDetailUser?.rate_type == "Per Hour"{
                            if workerDetailUser?.rate_to == ""{
                                self.amountBtn.setTitle("No rate selected", for: .normal)
                            }else{
                                self.amountBtn.setTitle("$\(workerDetailUser?.rate_to ?? "")/h", for: .normal)
                            }
                        }else{
                            self.amountBtn.setTitle("No rate selected", for: .normal)
                        }
                        if workerDetailUser?.catagory_details?.count ?? 0 > 1{
                            self.categoryLbl.text = "\(workerDetailUser?.catagory_details?.first?.category_name ?? "") , \(workerDetailUser?.catagory_details?.last?.category_name ?? "") "
                        }
                        else{
                            self.categoryLbl.text = "\(workerDetailUser?.catagory_details?.first?.category_name ?? "") "
                        }
                        self.jobTypelbl.text = workerDetailUser?.job_type ?? ""
                        if workerDetailUser?.catagory_details == nil{
                            self.experienceLbl.text = "0 Year"
                        }else{
                            let exp0 = Double(workerDetailUser?.catagory_details?.first?.experience ?? "0") ?? 0.0
                            let exp1 = Double(workerDetailUser?.catagory_details?.last?.experience ?? "0") ?? 0.0
                            if workerDetailUser?.catagory_details?.count ?? 0 > 1 {
                                self.experienceLbl.text = "\(workerDetailUser?.catagory_details?.first?.experience ?? "0" ) \(exp0 > 1.0 ? "Years" : "Year") , \(workerDetailUser?.catagory_details?.last?.experience ?? "0") \(exp1 > 1.0 ? "Years" : "Year") "
                            }
                            else{
                                self.experienceLbl.text = "\(workerDetailUser?.catagory_details?.first?.experience ?? "0") \(exp0 > 1.0 ? "Years" : "Year")"
                            }
                        }
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        if let date = dateFormatter.date(from: workerDetailUser?.date_of_birth ?? "") {
                            let age = Calendar.current.dateComponents([.year], from: date, to: Date()).year!
                            print(age)
                            self.locationLbl.text =  "\(Int(age)) Years"
                        }
                        var sPhotoStr = workerDetailUser?.photo ?? ""
                        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                        self.userimgView.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
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
    func getCompanyLikeWorker(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading", view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        var param = [String:Any]()
        param = ["other_id": userNumberId , "cat_id" : cat_ID] as [String : Any]
        print(param)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.workerLikeOrUnlike, params: param, headers: headers) { [self] response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            let status = response["status"] as? Int ?? 0
            let message = response["message"] as? String ?? ""
            if status == 1 {
                self.tabBarController?.selectedIndex = 1
            }else{
                alert(AppAlertTitle.appName.rawValue, message: message, view: self)
            }
            
        } failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
}
