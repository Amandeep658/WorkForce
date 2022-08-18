//
//  JobsDesignerViewController.swift
//  WorkForce
//
//  Created by Dharmani Apps on 18/05/22.
//

import UIKit
import Alamofire
import SDWebImage

class JobsDesignerViewController: UIViewController {

    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var jobsTableView: UITableView!
    @IBOutlet weak var imgView: UIView!
    
    var jobListDataArr = [AddJobData]()
    var jobId: String?
    var jobDetailId: String?
    var professionalUserDict = SingletonLocalModel()
    var isJobPhoto:Bool?
    var workerJObId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        self.hitJobListApi()

    }
    
    func setTable(){
        jobsTableView.delegate = self
        jobsTableView.dataSource = self
        jobsTableView.register(UINib(nibName: "JobsDesignerTableViewCell", bundle: nil), forCellReuseIdentifier: "JobsDesignerTableViewCell")
    }

    @IBAction func addAction(_ sender: UIButton) {
        if (UserType.userTypeInstance.userLogin == .Bussiness){
            let vc = SkillsViewController()
            self.pushViewController(vc, true)
        }else if UserType.userTypeInstance.userLogin == .Professional{
            let vc = SkillsViewController()
            self.pushViewController(vc, true)
        }else{
            let vc = CustomerSkillVC()
            self.pushViewController(vc, true)
        }
    }
    
    
    func hitBusinessJObSubCheckApi(){
        let authToken = AppDefaults.token ?? ""
        let header: HTTPHeaders = ["Token": authToken]
        print("subscriptionStatus == >>>>", header)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.subscriptionstatus, params: [:], headers: header) { [self] (response) in
            print(response)
            let status = response["status"] as? Int ?? 0
            print(status)
            if status == 1 {
                let vc = ProfessionalLikePostViewController()
                self.pushViewController(vc, true)
            }else if status == 0{
                let vc = SubcribeViewController()
                vc.VC = self
                vc.modalPresentationStyle = .fullScreen
                vc.subcriptionType = "Professional Design"
                vc.jobLDataArr = jobListDataArr
                self.present(vc, true)
            }
        } failure: { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
            }

        
    }
    
//    MARK: JOB LIST API'S
    func hitJobListApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading..", view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let param = ["job_id": jobId ] as [String : Any]
        print(param)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.getJobListbyUseId, params: param, headers: headers) { [self] response in
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
                if status == 1{
                    self.jobListDataArr = aContact.data!
                    if jobListDataArr.count > 0{
                        self.imgView.isHidden = true
                    }else{
                        self.imgView.isHidden = false
                    }
                    self.jobsTableView.reloadData()
                }else if status == 0{
                    self.jobListDataArr = aContact.data!
                    if jobListDataArr.count > 0{
                        self.imgView.isHidden = true
                    }else{
                        self.imgView.isHidden = false
                    }
                    self.jobsTableView.reloadData()
                }else{
                    self.jobListDataArr.removeAll()
                    self.jobsTableView.reloadData()
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
@available(iOS 15, *)
extension JobsDesignerViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobListDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobsDesignerTableViewCell", for: indexPath) as! JobsDesignerTableViewCell
        if jobListDataArr[indexPath.row].catagory_details?.count ?? 0 > 1{
            cell.jobsDesignLbl.text = "\(jobListDataArr[indexPath.row].catagory_details?.first?.category_name ?? "") , \(jobListDataArr[indexPath.row].catagory_details?.last?.category_name ?? "") "
        }
        else{
            cell.jobsDesignLbl.text = "\(jobListDataArr[indexPath.row].catagory_details?.first?.category_name ?? "") "
        }
        if jobListDataArr[indexPath.row].rate_type == "Per Day"{
            cell.jobsPriceLbl.text = "$\(jobListDataArr[indexPath.row].rate_from ?? "")/d , $\(jobListDataArr[indexPath.row].rate_to ?? "")/d"
        }else if jobListDataArr[indexPath.row].rate_type == "Per Hour"{
            cell.jobsPriceLbl.text = "$\(jobListDataArr[indexPath.row].rate_from ?? "")/h , $\(jobListDataArr[indexPath.row].rate_to ?? "")/h"
        }else{
            cell.jobsPriceLbl.text = ""
        }
        var sPhotoStr = jobListDataArr[indexPath.row].job_image ?? ""
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        cell.jobsImg.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.workerJObId =  jobListDataArr[indexPath.row].job_id ?? ""
        UserDefaults.standard.set(workerJObId, forKey: "setWorkerID")
        hitBusinessJObSubCheckApi()
    }
    
}
