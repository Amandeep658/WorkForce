//
//  CustomerManageJobListDetailVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 22/08/22.
//

import UIKit
import Alamofire
import SDWebImage

class CustomerManageJobListDetailVC: UIViewController,DoBackDelegate {
    func userDoPressCancel() {
        self.navigationController?.popViewController(animated: true)
    }

//    MARK: OUTLETS
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var catLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var rateLblBtn: UIButton!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var experienceLbl: UITextField!
    @IBOutlet weak var jobtypeLbl: UITextField!
    @IBOutlet weak var contentView: UIView!
    
    var CustomerjobDetail:JobDetailByJobIdModel?
    var customerJobId  = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden =  true
        self.hitCustomerJobListDetailApi()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.contentView.setCornerRadius(topLeft: 40, topRight: 40, bottomLeft: 0, bottomRight: 0)
        self.contentView.clipsToBounds = true
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func rateBtn(_ sender: UIButton) {
        let vc = CustomerDeleteJob()
        vc.customerjobID = CustomerjobDetail?.data?.customer_job_id ?? ""
        vc.modalPresentationStyle = .fullScreen
        vc.deleteDelegate = self
        self.present(vc, true)
    }
    
    @IBAction func editBtn(_ sender: UIButton) {
        let vc = CustomerManageEditJobVC()
        vc.jobDetailByJobdict = CustomerjobDetail
        vc.jobID = CustomerjobDetail?.data?.customer_job_id ?? ""
        self.pushViewController(vc, true)
    }
    
//    MARK: CUSTOMER JOB DETAIL
    func hitCustomerJobListDetailApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading", view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let param = ["customer_job_id": customerJobId] as [String : Any]
        print(param)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.customerGetJobDetailsByJobId, params: param, headers: headers) { [self] response in
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
                        self.CustomerjobDetail = aContact
                        self.locationLbl.text = CustomerjobDetail?.data?.location ?? ""
                        if CustomerjobDetail?.data?.catagory_details?.count ?? 0 > 1{
                            self.catLbl.text = "\(CustomerjobDetail?.data?.catagory_details?.first?.category_name ?? "") , \(CustomerjobDetail?.data?.catagory_details?.last?.category_name ?? "") "
                        }
                        else{
                            self.catLbl.text = "\(CustomerjobDetail?.data?.catagory_details?.first?.category_name ?? "") "
                        }
                        if CustomerjobDetail?.data?.rate_type == "Per Day"{
                            if  CustomerjobDetail?.data?.rate_from == "" {
                                self.rateLblBtn.setTitle("No rate selected.", for: .normal)
                            }else{
                                self.rateLblBtn.setTitle("$\(CustomerjobDetail?.data?.rate_from ?? "")/d - $\(CustomerjobDetail?.data?.rate_to ?? "")/d", for: .normal)}
                        }else if CustomerjobDetail?.data?.rate_type == "Per Hour"{
                            if  CustomerjobDetail?.data?.rate_from == "" {
                                self.rateLblBtn.setTitle("No rate selected.", for: .normal)
                            }else{
                                self.rateLblBtn.setTitle("$\(CustomerjobDetail?.data?.rate_from ?? "")/h - $\(CustomerjobDetail?.data?.rate_to ?? "")/h", for: .normal)}
                        }else{
                            self.rateLblBtn.setTitle("No rate selected.", for: .normal)
                        }
                        self.jobtypeLbl.text = CustomerjobDetail?.data?.job_type ?? ""
                        var photoStr = CustomerjobDetail?.data?.job_image ?? ""
                        photoStr = photoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                        self.userImgView.sd_setImage(with: URL(string: photoStr ), placeholderImage:UIImage(named:"placeholder"))
                        self.descriptionLbl.text = CustomerjobDetail?.data?.description ?? ""
                        if CustomerjobDetail?.data?.catagory_details == nil{
                            self.experienceLbl.text = "0 Year"
                        }else{
                            let exp0 = Double(CustomerjobDetail?.data?.catagory_details?.first?.experience ?? "0") ?? 0.0
                            let exp1 = Double(CustomerjobDetail?.data?.catagory_details?.last?.experience ?? "0") ?? 0.0
                            if CustomerjobDetail?.data?.catagory_details?.count ?? 0 > 1 {
                                self.experienceLbl.text = "\(CustomerjobDetail?.data?.catagory_details?.first?.experience ?? "0" ) \(exp0 > 1.0 ? "Years" : "Year")  , \(CustomerjobDetail?.data?.catagory_details?.last?.experience ?? "0") \(exp1 > 1.0 ? "Years" : "Year")"
                            }
                            else{
                                self.experienceLbl.text = "\(CustomerjobDetail?.data?.catagory_details?.first?.experience ?? "0") \(exp0 > 1.0 ? "Years" : "Year")"
                            }
                        }
                        self.headerLbl.text =  CustomerjobDetail?.data?.username ?? ""
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
