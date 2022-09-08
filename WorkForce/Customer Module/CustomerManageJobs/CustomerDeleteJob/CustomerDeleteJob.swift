//
//  CustomerDeleteJob.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 24/08/22.
//

import UIKit
import Alamofire
import SDWebImage

protocol DoBackDelegate {
    func userDoPressCancel()
}

class CustomerDeleteJob: UIViewController {
    
// MARK: OUTLETS
    @IBOutlet weak var cancelbtn: UIButton!
    @IBOutlet weak var yesbtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var jobExpiredView: UIView!
    
    var customerjobID = ""
    var isDelete = ""
    var deleteDelegate: DoBackDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        jobExpiredView.isHidden = true
    }


    @IBAction func yesbtn(_ sender: UIButton) {
        hitJobListDetailApi()
    }
    
    @IBAction func noBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelbtn(_ sender: UIButton) {
        if isDelete == "1"{
            self.dismiss(animated: true) {
                self.deleteDelegate?.userDoPressCancel()
            }
        }else{
            self.dismiss(animated: true)
        }
    }

    //    MARK: HIT JOB DETAIL API
    func hitJobListDetailApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow( title: "LOADING".localized(), view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let param = ["customer_job_id": customerjobID ] as [String : Any]
        print(param)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.deletetCustomerManageJob, params: param, headers: headers) { [self] response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            AFWrapperClass.svprogressHudDismiss(view: self)
            let status = response["status"] as? Int ?? 0
            let alertMessage = response["message"] as? String ?? ""
            print(status)
            if status == 1 {
                self.jobExpiredView.isHidden = false
                self.isDelete = "1"
            }
            else{
                jobExpiredView.isHidden = true
                alert(AppAlertTitle.appName.rawValue, message: alertMessage, view: self)
            }
        } failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }

}
