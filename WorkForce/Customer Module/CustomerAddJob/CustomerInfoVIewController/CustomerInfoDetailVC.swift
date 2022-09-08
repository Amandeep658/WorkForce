//
//  CustomerInfoDetailVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 22/08/22.
//

import UIKit
import Alamofire
import SDWebImage

class CustomerInfoDetailVC: UIViewController {
    
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var jobtypeLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var infoScrollView: UIScrollView!
    
    
    var CustomerjobDetail:CJobListModel?
    var customerJobDataArr = [CJobListData]()
    var customerId = ""

    @IBOutlet weak var backBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hitJobListDetailApi()
    }
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        infoScrollView.roundViewCorners(corners: [.topLeft, .topRight], radius: 20)
        infoScrollView.clipsToBounds = true
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.popViewController(true)
    }
    
//    MARK: CUSTOMER JOB LIST DETAIL
    func hitJobListDetailApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let workersJObID = UserDefaults.standard.string(forKey: "setCustomerWorkerID") ?? ""
        print("customer_job_id ====>>>>",workersJObID as Any)
        let param = ["customer_job_id": customerId] as [String : Any]
        print(param)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.customerGetJobDetailsByJobId, params: param, headers: headers) { [self] response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aContact = try jsonDecoder.decode(CJobListModel.self, from: data!)
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
                        self.userImgView.sd_setImage(with: URL(string: photoStr ), placeholderImage:UIImage(named:"placeholder"))
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
    
    
    
}

