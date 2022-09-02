//
//  CustomerJobSearchListDetailVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 01/09/22.
//

import UIKit
import Alamofire
import SDWebImage
import IQKeyboardManagerSwift

class CustomerJobSearchListDetailVC: UIViewController {

//    MARK: OUTLETS
    @IBOutlet weak var searchListScrollView: UIScrollView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var jobtypeLbl: UITextField!
    @IBOutlet weak var yesConnectBtn: UIButton!
    @IBOutlet weak var notConnectBtn: UIButton!
    @IBOutlet weak var headerlbl: UILabel!
    
    var customerJobId = ""
    var cat_id = ""
    var CustomerjobDetail:JobDetailByJobIdModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.hitCustomerJobListDetailApi()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.searchListScrollView.roundViewCorners(corners: [.topLeft, .topRight], radius: 20)
        self.searchListScrollView.clipsToBounds = true
        
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.popVC()
    }
    

    @IBAction func yesConnectBtn(_ sender: UIButton) {
        hitCustomerJobLike()
    }
    
    @IBAction func notConnectBtn(_ sender: UIButton) {
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
                            self.categoryLbl.text = "\(CustomerjobDetail?.data?.catagory_details?.first?.category_name ?? "") , \(CustomerjobDetail?.data?.catagory_details?.last?.category_name ?? "") "
                        }
                        else{
                            self.categoryLbl.text = "\(CustomerjobDetail?.data?.catagory_details?.first?.category_name ?? "") "
                        }
                        self.jobtypeLbl.text = CustomerjobDetail?.data?.job_type ?? ""
                        var photoStr = CustomerjobDetail?.data?.job_image ?? ""
                        photoStr = photoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                        self.imgView.sd_setImage(with: URL(string: photoStr ), placeholderImage:UIImage(named:"placeholder"))
                        self.descriptionLbl.text = CustomerjobDetail?.data?.description ?? ""
                        self.headerlbl.text =  CustomerjobDetail?.data?.username ?? ""
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
            let parameters = ["customer_job_id": customerJobId , "cat_id" : cat_id ]
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
