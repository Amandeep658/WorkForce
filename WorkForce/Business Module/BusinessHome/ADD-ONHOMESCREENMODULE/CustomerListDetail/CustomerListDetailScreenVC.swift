//
//  CustomerListDetailScreenVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 30/08/22.
//

import UIKit
import Alamofire
import SDWebImage

class CustomerListDetailScreenVC: UIViewController {
    
//    MARK: OUTLETS
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var customerImgView: UIImageView!
    @IBOutlet weak var categoryNameLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var jobtypeLbl: UILabel!
    @IBOutlet weak var connectJobBtn: UIButton!
    @IBOutlet weak var notConnectJobBtn: UIButton!
    
    var customerJObID = ""
    var cat_id = ""
    var CustomerjobDetail:JobDetailByJobIdModel?
    var specificnav:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden =  true
        self.hitCustomerJobListDetailApi()
    }

    @IBAction func backBtn(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func connectJobBtn(_ sender: UIButton) {
        hitCustomerJobLike()
    }
    
    @IBAction func notConnectJobBtn(_ sender: UIButton) {
        self.popVC()
    }
    
    //    MARK: CUSTOMER JOB DETAIL
    func hitCustomerJobListDetailApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading", view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let param = ["customer_job_id": customerJObID] as [String : Any]
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
                            self.categoryNameLbl.text = "\(CustomerjobDetail?.data?.catagory_details?.first?.category_name ?? "") , \(CustomerjobDetail?.data?.catagory_details?.last?.category_name ?? "") "
                        }
                        else{
                            self.categoryNameLbl.text = "\(CustomerjobDetail?.data?.catagory_details?.first?.category_name ?? "") "
                        }
                        self.jobtypeLbl.text = CustomerjobDetail?.data?.job_type ?? ""
                        var photoStr = CustomerjobDetail?.data?.job_image ?? ""
                        photoStr = photoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                        self.customerImgView.sd_setImage(with: URL(string: photoStr ), placeholderImage:UIImage(named:"placeholder"))
                        self.descriptionLbl.text = CustomerjobDetail?.data?.description ?? ""
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
    
    
//    MARK: CUSTOMER JOB LIKE AND UNLIKE
    
    func hitCustomerJobLike(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading", view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let parameters = ["customer_job_id": customerJObID , "cat_id" : cat_id ]
        print(parameters)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.customerLikeAndUnlike, params: parameters, headers: headers) { [self] response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            let status = response["status"] as? Int ?? 0
            let message = response["message"] as? String ?? ""
            if status == 1 {
                let navVC = tabBarController?.viewControllers![1] as! UINavigationController//
                let cartTableViewController = navVC.topViewController as! BusinessConnectViewController
                cartTableViewController.currentIndex = 1
                print("cartTableViewController.currentIndex *****************>>>>>>>>>",cartTableViewController.currentIndex)
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
