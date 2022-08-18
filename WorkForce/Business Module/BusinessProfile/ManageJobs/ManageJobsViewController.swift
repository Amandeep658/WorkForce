//
//  ManageJobsViewController.swift
//  WorkForce
//
//  Created by Dharmani Apps on 23/05/22.
//

import UIKit
import Alamofire
import SDWebImage

class ManageJobsViewController: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    
    var jobListDataArr = [AddJobData]()
    
    
    @IBOutlet weak var manageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
        hitJobListApi()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        hitJobListApi()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func setTable(){
        manageTableView.delegate = self
        manageTableView.dataSource = self
        manageTableView.register(UINib(nibName: "JobsDesignerTableViewCell", bundle: nil), forCellReuseIdentifier: "JobsDesignerTableViewCell")
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popViewController(true)
    }
    
    //    MARK: JOB LIST API'S
    func hitJobListApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading", view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.getJobListbyUseId, params: [:], headers: headers) { [self] response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aContact = try jsonDecoder.decode(AddJobModel.self, from: data!)
                print(aContact)
                let status = aContact.status
                let message = aContact.message ?? ""
                if status == 1{
                    self.jobListDataArr = aContact.data!
                    self.manageTableView.reloadData()
                }else{
                    self.jobListDataArr.removeAll()
                    self.manageTableView.reloadData()
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
extension ManageJobsViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobListDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobsDesignerTableViewCell", for: indexPath) as! JobsDesignerTableViewCell
//        cell.jobsDesignLbl.text = "\(jobListDataArr[indexPath.row].catagory_details?.first?.category_name ?? "")"
        if jobListDataArr[indexPath.row].catagory_details?.count ?? 0 > 1{
            cell.jobsDesignLbl.text = "\(jobListDataArr[indexPath.row].catagory_details?.first?.category_name ?? "") , \(jobListDataArr[indexPath.row].catagory_details?.last?.category_name ?? "") "
        }
        else{
            cell.jobsDesignLbl.text = "\(jobListDataArr[indexPath.row].catagory_details?.first?.category_name ?? "") "
        }
        if jobListDataArr[indexPath.row].rate_type == "Per Day"{
            cell.jobsPriceLbl.text = "$\(jobListDataArr[indexPath.row].rate_from ?? "")/d - $\(jobListDataArr[indexPath.row].rate_to ?? "")/d"
        }else if jobListDataArr[indexPath.row].rate_type == "Per Hour"{
            cell.jobsPriceLbl.text = "$\(jobListDataArr[indexPath.row].rate_from ?? "")/h - $\(jobListDataArr[indexPath.row].rate_to ?? "")/h"
        }else{
            cell.jobsPriceLbl.text = ""
        }
        var sPhotoStr = jobListDataArr[indexPath.row].job_image ?? ""
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        cell.jobsImg.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ManagerJobsDesignerViewController()
        vc.jobId = jobListDataArr[indexPath.row].job_id ?? ""
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc, true)
    }
    
}
