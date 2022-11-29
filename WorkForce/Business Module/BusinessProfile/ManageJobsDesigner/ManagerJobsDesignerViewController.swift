//
//  ManagerJobsDesignerViewController.swift
//  WorkForce
//
//  Created by Dharmani Apps on 23/05/22.
//

import UIKit
import Alamofire
import SDWebImage

class ManagerJobsDesignerViewController: UIViewController,DidBackDelegate {
    func userDidPressCancel() {
        self.navigationController?.popViewController(animated: true)
    }

    @IBOutlet weak var editImg: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var headerLb: UILabel!
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var locationlbl: UILabel!
    @IBOutlet weak var hourbtn: UIButton!
    @IBOutlet weak var experiencelbl: UITextField!
    @IBOutlet weak var jobTypeTF: UITextField!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!

    var jobId = ""
    var jobDetailByJobIdArr:JobDetailByJobIdModel?
    var jobDetailByJobIdDataArr = [CategoryData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hitJobListDetailApi()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hitJobListDetailApi()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popViewController(true)
    }
    
    @IBAction func deleteBtn(_ sender: UIButton) {
        let vc = DeleteJobVC()
        vc.jobID = jobDetailByJobIdArr?.data?.job_id ?? ""
        vc.modalPresentationStyle = .fullScreen
        vc.crossDelegate = self
        self.present(vc, true)
    }
    
    
    @IBAction func editProfileAction(_ sender: UIButton) {
        let vc = EditManageprofileView()
        vc.jobDetailByJobdict = jobDetailByJobIdArr
        vc.jobID = jobDetailByJobIdArr?.data?.job_id ?? ""
        self.pushViewController(vc, true)
    }
    
//    MARK: HIT JOB DETAIL API
    
    func hitJobListDetailApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let param = ["job_id": jobId ] as [String : Any]
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
                        self.headerLb.text = jobDetailByJobIdArr?.data?.company_name ?? ""
                        if jobDetailByJobIdArr?.data?.catagory_details?.count ?? 0 > 1{
                            self.categoryLbl.text = "\(jobDetailByJobIdArr?.data?.catagory_details?.first?.category_name ?? "") , \(jobDetailByJobIdArr?.data?.catagory_details?.last?.category_name ?? "") "
                        }
                        else{
                            self.categoryLbl.text = "\(jobDetailByJobIdArr?.data?.catagory_details?.first?.category_name ?? "") "
                        }
                        if jobDetailByJobIdArr?.data?.rate_type == "Per Day"{
                            if jobDetailByJobIdArr?.data?.rate_to == "" || jobDetailByJobIdArr?.data?.rate_from == "" {
                                self.hourbtn.setTitle("No rate selected.".localized(), for: .normal)
                            }else{
                                self.hourbtn.setTitle("$\(jobDetailByJobIdArr?.data?.rate_from ?? "")/d - $\(jobDetailByJobIdArr?.data?.rate_to ?? "")/d", for: .normal)
                            }
                        }else if jobDetailByJobIdArr?.data?.rate_type == "Per Hour"{
                            if jobDetailByJobIdArr?.data?.rate_to == "" || jobDetailByJobIdArr?.data?.rate_from == "" {
                                self.hourbtn.setTitle("No rate selected.".localized(), for: .normal)
                            }else{
                                self.hourbtn.setTitle("$\(jobDetailByJobIdArr?.data?.rate_from ?? "")/h - $\(jobDetailByJobIdArr?.data?.rate_to ?? "")/h", for: .normal)
                            }
                        }else{
                            self.hourbtn.setTitle("No rate selected.".localized(), for: .normal)
                        }
                        if jobDetailByJobIdArr?.data?.catagory_details == nil{
                            self.experiencelbl.text = "0 Year"
                        }else{
                            let exp0 = Double(jobDetailByJobIdArr?.data?.catagory_details?.first?.experience ?? "0") ?? 0.0
                            let exp1 = Double(jobDetailByJobIdArr?.data?.catagory_details?.last?.experience ?? "0") ?? 0.0
                            if jobDetailByJobIdArr?.data?.catagory_details?.count ?? 0 > 1 {
                                self.experiencelbl.text = "\(jobDetailByJobIdArr?.data?.catagory_details?.first?.experience ?? "0" ) \(exp0 > 1.0 ? "Years".localized() : "Year".localized())  , \(jobDetailByJobIdArr?.data?.catagory_details?.last?.experience ?? "0") \(exp1 > 1.0 ? "Years".localized() : "Year".localized())"
                            }
                            else{
                                self.experiencelbl.text = "\(jobDetailByJobIdArr?.data?.catagory_details?.first?.experience ?? "0") \(exp0 > 1.0 ? "Years".localized() : "Year".localized())"
                            }
                        }
                        self.locationlbl.text = jobDetailByJobIdArr?.data?.city ?? ""
                        self.jobTypeTF.text = jobDetailByJobIdArr?.data?.job_type ?? ""
                        self.descriptionLbl.text = jobDetailByJobIdArr?.data?.description ?? ""
                        var sPhotoStr = jobDetailByJobIdArr?.data?.job_image ?? ""
                        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                        self.editImg.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
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
//else if jobDetailByJobIdArr?.data?.rate_type == "" {
//    self.hourbtn.setTitle("No rate selected.", for: .normal)
//}
