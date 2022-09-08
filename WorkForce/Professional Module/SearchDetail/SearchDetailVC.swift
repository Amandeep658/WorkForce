//
//  SearchDetailVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 09/08/22.
//

import UIKit
import Alamofire
import SDWebImage


class SearchDetailVC: UIViewController {
    
//    MARK: OUTLETS
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
    var jobDetailByJobIdArr:JobDetailByJobIdModel?

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        hitJobListDetailApi()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popViewController(true)
    }
    @IBAction func connectAction(_ sender: UIButton) {
        getCompanyJobLike()
    }
    
    @IBAction func notConnectAction(_ sender: UIButton) {
        self.popViewController(true)
    }

//    MARK: HIT JOB DETAIL
    func hitJobListDetailApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Laoding", view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        var param = [String:Any]()
        param = ["job_id": job_id ] as [String : Any]
        print("isGetJobbyjobid===>>>",param)
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
                        self.jobDetailByJobIdArr = aContact
                        self.headerLbl.text = jobDetailByJobIdArr?.data?.company_name ?? ""
                        if jobDetailByJobIdArr?.data?.catagory_details?.count ?? 0 > 1{
                            self.categoryLbl.text = "\(jobDetailByJobIdArr?.data?.catagory_details?.first?.category_name ?? "") , \(jobDetailByJobIdArr?.data?.catagory_details?.last?.category_name ?? "") "
                        }
                        else{
                            self.categoryLbl.text = "\(jobDetailByJobIdArr?.data?.catagory_details?.first?.category_name ?? "") "
                        }
                        if jobDetailByJobIdArr?.data?.rate_type == "Per Day"{
                            if jobDetailByJobIdArr?.data?.rate_from == "" || jobDetailByJobIdArr?.data?.rate_to == ""{
                                self.amountBtn.setTitle("No rate selected.".localized(), for: .normal)
                            }else{
                                self.amountBtn.setTitle("$\(jobDetailByJobIdArr?.data?.rate_from ?? "")/d - $\(jobDetailByJobIdArr?.data?.rate_to ?? "")/d", for: .normal)}
                        }else if jobDetailByJobIdArr?.data?.rate_type == "Per Hour"{
                            if jobDetailByJobIdArr?.data?.rate_from == "" || jobDetailByJobIdArr?.data?.rate_to == ""{
                                self.amountBtn.setTitle("No rate selected.".localized(), for: .normal)
                            }else{
                                self.amountBtn.setTitle("$\(jobDetailByJobIdArr?.data?.rate_from ?? "")/h - $\(jobDetailByJobIdArr?.data?.rate_to ?? "")/h", for: .normal)}
                        }else{
                            self.amountBtn.setTitle("No rate selected.".localized(), for: .normal)
                        }
                        if jobDetailByJobIdArr?.data?.catagory_details == nil{
                            self.experienceLbl.text = "0 Year".localized()
                        }else{
                            let exp0 = Double(jobDetailByJobIdArr?.data?.catagory_details?.first?.experience ?? "0") ?? 0.0
                            let exp1 = Double(jobDetailByJobIdArr?.data?.catagory_details?.last?.experience ?? "0") ?? 0.0
                            if jobDetailByJobIdArr?.data?.catagory_details?.count ?? 0 > 1 {
                                self.experienceLbl.text = "\(jobDetailByJobIdArr?.data?.catagory_details?.first?.experience ?? "0" ) \(exp0 > 1.0 ? "Years".localized() : "Year".localized())  , \(jobDetailByJobIdArr?.data?.catagory_details?.last?.experience ?? "0") \(exp1 > 1.0 ? "Years".localized() : "Year".localized())"
                            }
                            else{
                                self.experienceLbl.text = "\(jobDetailByJobIdArr?.data?.catagory_details?.first?.experience ?? "0") \(exp0 > 1.0 ? "Years".localized() : "Year".localized())"
                            }
                        }
                        self.locationLbl.text = jobDetailByJobIdArr?.data?.city ?? ""
                        self.jobTypelbl.text = jobDetailByJobIdArr?.data?.job_type ?? ""
                        if jobDetailByJobIdArr?.data?.description != nil{
                            self.descriptionLbl.text = jobDetailByJobIdArr?.data?.description ?? ""
                        }else{
                            self.descriptionLbl.text = "N/A"
                        }
                        var sPhotoStr = jobDetailByJobIdArr?.data?.job_image ?? ""
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

//    MARK: HIT CONNECT API
    func getCompanyJobLike(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        var param = [String:Any]()
        param = ["job_id": jobDetailByJobIdArr?.data?.job_id ?? "" , "cat_id" : jobDetailByJobIdArr?.data?.catagory_details?.first?.cat_id ?? "" ] as [String : Any]
        print(param)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.getjobLikeAndUnlike, params: param, headers: headers) { [self] response in
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
