//
//  CustomerDetailVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 08/08/22.
//

import UIKit
import Alamofire
import SDWebImage

class CustomerDetailVC: UIViewController {
    
//    MARK: OUTLETS
    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var companyImgView: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var headerlbl: UILabel!
    @IBOutlet weak var contentView: UIView!
    
//    MARK: VARIABLES
    var customerDtaArr: CustomerDetailData?
    var companyID = ""
    let userID = UserDefaults.standard.string(forKey: "uID") ?? ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.companyImgView.layer.cornerRadius =  6
        self.companyImgView.clipsToBounds = true
        self.hitCustomerDetail()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.contentView.setCornerRadius(topLeft: 40, topRight: 40, bottomLeft: 0, bottomRight: 0)
        self.contentView.clipsToBounds = true
        
    }

    @IBAction func backBtn(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func yesConnectBtn(_ sender: UIButton) {
        hitCompanyLike()
    }
    
    @IBAction func noConnectBtn(_ sender: UIButton) {
        self.popVC()
    }
    
    
    
//    MARK: HIT DETAIL OF CUSTOMER
    func hitCustomerDetail(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading", view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let parameter = ["user_id":companyID] as [String : Any]
        print(parameter)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.getCompanyListingbycompanyId, params: parameter, headers: headers) { [self] response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aContact = try jsonDecoder.decode(CustomerModel.self, from: data!)
                print(aContact)
                let status = aContact.status ?? 0
                let message = aContact.message as? String ?? ""
                if status == 1{
                    self.customerDtaArr =  aContact.data
                    self.companyNameLbl.text = customerDtaArr?.company_name ?? ""
                    self.locationLbl.text = customerDtaArr?.location ?? ""
                    if customerDtaArr?.description != nil{
                        self.descriptionLbl.text =  customerDtaArr?.description ?? ""
                    }else{
                        self.descriptionLbl.text = "N/A"
                    }
                    var sPhotoStr = customerDtaArr?.photo ?? ""
                    UserDefaults.standard.set(sPhotoStr, forKey: "BusinessProfileImage")
                    sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                    self.companyImgView.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
                    if let tabBar = self.tabBarController as? TabBarVC {
                        print("tab bar is \(tabBar)")
                        tabBar.updateProfileImage()
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
    
//       MARK: GET COMPANY CONNECT
        func hitCompanyLike(){
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudShow(title: "Loading", view: self)
            }
            let authToken  = AppDefaults.token ?? ""
            let headers: HTTPHeaders = ["Token":authToken]
            print(headers)
            let parameters = ["company_id": companyID , "user_id" : UserDefaults.standard.string(forKey: "uID") ?? ""]
            print(parameters)
            AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.customerLikeAndUnlikecompany, params: parameters, headers: headers) { [self] response in
                AFWrapperClass.svprogressHudDismiss(view: self)
                print(response)
                let status = response["status"] as? Int ?? 0
                let message = response["message"] as? String ?? ""
                if status == 1 {
                    self.tabBarController?.selectedIndex = 1
                    }else{
                        print("")
                }
            
            } failure: { error in
                AFWrapperClass.svprogressHudDismiss(view: self)
                alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
            }
        }
    
}
