//
//  ConnectCustomerJobListDetailVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 30/08/22.
//

import UIKit
import Alamofire
import SDWebImage
import IQKeyboardManagerSwift

class ConnectCustomerJobListDetailVC: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var connectUserImgView: UIImageView!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var jobTypeLbl: UITextField!
    @IBOutlet weak var connectListScroll: UIScrollView!
    
    var customerJObID = ""
    var CustomerjobDetail:JobDetailByJobIdModel?
    var user_iD = ""
    var createRoomData:BusinessCreateRoomModel?
    var companyProfileDataArr:CompanyListingModel?
    var detailArr:CompanyListingData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.hitCustomerJobListDetailApi()
        self.hitCompanyListing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        connectListScroll.roundViewCorners(corners: [.topLeft, .topRight], radius: 20)
        connectListScroll.clipsToBounds = true
    }

    @IBAction func backBtn(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func chatBtn(_ sender: UIButton) {
        self.hitRoomCreateApi()
    }
    
    //    MARK: CUSTOMER JOB DETAIL
    func hitCustomerJobListDetailApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
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
                            self.categoryLbl.text = "\(CustomerjobDetail?.data?.catagory_details?.first?.category_name ?? "") , \(CustomerjobDetail?.data?.catagory_details?.last?.category_name ?? "") "
                        }
                        else{
                            self.categoryLbl.text = "\(CustomerjobDetail?.data?.catagory_details?.first?.category_name ?? "") "
                        }
                        self.jobTypeLbl.text = CustomerjobDetail?.data?.job_type ?? ""
                        var photoStr = CustomerjobDetail?.data?.job_image ?? ""
                        photoStr = photoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                        self.connectUserImgView.sd_setImage(with: URL(string: photoStr ), placeholderImage:UIImage(named:"placeholder"))
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
    
//    MARK: CHAT ROOM CREATED
    func hitRoomCreateApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let param = ["other_id": user_iD] as [String : Any]
        print(param)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.createRoom, params: param, headers: headers) { [self] response in
            AFWrapperClass.svprogressHudDismiss(view: self)
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
                        print("createRoomdata********>>>>>>>",self.createRoomData)
                        let vc = SingleChatController()
                        vc.chatRoomId = createRoomData?.room_id ?? ""
                        vc.user_ID =  createRoomData?.user_detail?.user_id ?? ""
                        vc.userName = createRoomData?.user_detail?.username ?? ""
                        vc.isNavFromCustomer = "CustomerJobList"
                        vc.userProfileImage = createRoomData?.user_detail?.photo ?? ""
                        self.pushViewController(vc, true)
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
    
    
    //    MARK: COMPANY LISTING API
    func hitCompanyListing(){
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.getCompanyListing, params: [:], headers: headers) { response in
            print(response)
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aContact = try jsonDecoder.decode(CompanyListingModel.self, from: data!)
                print(aContact)
                self.companyProfileDataArr = aContact
                let status = aContact.status
                let message = aContact.message ?? ""
                if status == 401 {
                    UserDefaults.standard.removeObject(forKey: "authToken")
                    appDel.navigation()
                } else if status == 1{
                    self.detailArr =  aContact.data!
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
