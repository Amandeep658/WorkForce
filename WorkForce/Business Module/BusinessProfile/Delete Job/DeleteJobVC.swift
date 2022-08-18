//
//  DeleteJobVC.swift
//  WorkForce
//
//  Created by apple on 07/07/22.
//

import UIKit
import Alamofire
import SDWebImage
protocol DidBackDelegate {
    func userDidPressCancel()
}

class DeleteJobVC: UIViewController {
    
    //    MARK: OUTLETS
    @IBOutlet weak var cancelbtn: UIButton!
    @IBOutlet weak var yesbtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var jobExpiredView: UIView!
    
    
    var jobID = ""
    var isDelete = ""
    var crossDelegate : DidBackDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("here is JobId ---->>>>",jobID)
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
                self.crossDelegate?.userDidPressCancel()
            }
        }else{
            self.dismiss(animated: true)
        }
    }
    
    //    MARK: HIT JOB DETAIL API
    
    func hitJobListDetailApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow( title: "Loading", view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let param = ["job_id": jobID ] as [String : Any]
        print(param)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.deleteJob, params: param, headers: headers) { [self] response in
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


