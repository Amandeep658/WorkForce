//
//  CustomerLikeBusinessDetailVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 01/09/22.
//

import UIKit
import Alamofire
import SDWebImage
import IQKeyboardManagerSwift

class CustomerLikeBusinessDetailVC: UIViewController {
    
//    MARK: OUTLETS
    @IBOutlet weak var LikeCompanyScrollView: UIScrollView!
    @IBOutlet weak var imgVIew: UIImageView!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var rateLbl: UIButton!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var experienceLbl: UITextField!
    @IBOutlet weak var jobtypeLbl: UITextField!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    
    
    var job_id = ""
    var cat_ID = ""
    var userNumberId = ""
    var workerDetailUser:ProfessionalProfileData?


    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hitUserListDetailApi()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.LikeCompanyScrollView.roundViewCorners(corners: [.topLeft, .topRight], radius: 20)
        self.LikeCompanyScrollView.clipsToBounds = true
    }

    @IBAction func backBtn(_ sender: UIButton) {
        self.popVC()
    }
    
    
//    MARK: USER LIST DETAIL API
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
                        self.headerLbl.text = "Company Detail"
                        if workerDetailUser?.description != nil{
                            self.descriptionLbl.text = workerDetailUser?.description ?? ""
                        }else{
                            self.descriptionLbl.text = "N/A"
                        }
                        self.categoryLbl.text = workerDetailUser?.company_name ?? ""
                        self.locationLbl.text = workerDetailUser?.location ?? ""
                        var sPhotoStr = workerDetailUser?.photo ?? ""
                        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                        self.imgVIew.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
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
