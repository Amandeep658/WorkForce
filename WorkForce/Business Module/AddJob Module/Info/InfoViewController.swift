//
//  InfoViewController.swift
//  WorkForce
//
//  Created by Dharmani Apps on 24/05/22.
//

import UIKit
import Alamofire
import SDWebImage

class InfoViewController: UIViewController {
    
//    MARK: OUTLETS
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var amountBtn: UIButton!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var experiencelbl: UILabel!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var jobtypeLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    
    var specificjobDataArr = [AddJobData]()
    var jobDetailByJobId:JobDetailByJobIdModel?
    var job_id = ""

    @IBOutlet weak var backBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hitJobListDetailApi()
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.popViewController(true)
    }
    
    func hitJobListDetailApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let workersJObID = UserDefaults.standard.string(forKey: "setWorkerID") ?? ""
        print("workersjob ID ====>>>>",workersJObID as Any)
        let param = ["job_id": workersJObID as Any] as [String : Any]
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
                            self.headerLbl.text = jobDetailByJobId?.data?.company_name ?? ""
                        self.locationLbl.text =  jobDetailByJobId?.data?.city ?? ""
                        if jobDetailByJobId?.data?.catagory_details?.count ?? 0 > 1{
                            self.categoryLbl.text = "\(jobDetailByJobId?.data?.catagory_details?.first?.category_name ?? "") , \(jobDetailByJobId?.data?.catagory_details?.last?.category_name ?? "") "
                        }
                        else{
                            self.categoryLbl.text = "\(jobDetailByJobId?.data?.catagory_details?.first?.category_name ?? "") "
                        }
                        if jobDetailByJobId?.data?.rate_type == "Per Day"{
                            if  jobDetailByJobId?.data?.rate_from == "" {
                                self.amountBtn.setTitle("No rate selected.".localized(), for: .normal)
                            }else{
                                self.amountBtn.setTitle("$\(jobDetailByJobId?.data?.rate_from ?? "")/d - $\(jobDetailByJobId?.data?.rate_to ?? "")/d", for: .normal)}
                        }else if jobDetailByJobId?.data?.rate_type == "Per Hour"{
                            if  jobDetailByJobId?.data?.rate_from == "" {
                                self.amountBtn.setTitle("No rate selected.".localized(), for: .normal)
                            }else{
                                self.amountBtn.setTitle("$\(jobDetailByJobId?.data?.rate_from ?? "")/h - $\(jobDetailByJobId?.data?.rate_to ?? "")/h", for: .normal)}
                        }else{
                            self.amountBtn.setTitle("No rate selected.".localized(), for: .normal)
                        }
                        if jobDetailByJobId?.data?.catagory_details == nil{
                            self.experiencelbl.text = "0 Year"
                        }else{
                            let exp0 = Double(jobDetailByJobId?.data?.catagory_details?.first?.experience ?? "0") ?? 0.0
                            let exp1 = Double(jobDetailByJobId?.data?.catagory_details?.last?.experience ?? "0") ?? 0.0
                            if jobDetailByJobId?.data?.catagory_details?.count ?? 0 > 1 {
                                self.experiencelbl.text = "\(jobDetailByJobId?.data?.catagory_details?.first?.experience ?? "0" ) \(exp0 > 1.0 ? "Years".localized() : "Year".localized())  , \(jobDetailByJobId?.data?.catagory_details?.last?.experience ?? "0") \(exp1 > 1.0 ? "Years".localized() : "Year".localized())"
                            }
                            else{
                                self.experiencelbl.text = "\(jobDetailByJobId?.data?.catagory_details?.first?.experience ?? "0") \(exp0 > 1.0 ? "Years".localized() : "Year".localized())"
                            }
                        }
                        self.jobtypeLbl.text = jobDetailByJobId?.data?.job_type ?? ""
                        if jobDetailByJobId?.data?.description != nil{
                            self.descriptionLbl.text = jobDetailByJobId?.data?.description ?? ""
                        }else{
                            self.descriptionLbl.text = "N/A"
                        }
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
