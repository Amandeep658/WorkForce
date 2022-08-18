//
//  ProfessionalLikePostViewController.swift
//  WorkForce
//
//  Created by Dharmani Apps on 24/05/22.
//

import UIKit
import Alamofire
import SDWebImage

class ProfessionalLikePostViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var likeTableView: UITableView!
    
    var jobLDatArr = [AddJobData]()
    var jobIdentity = ""
    var professionalWorkerList = [ProfessionalLikeJobPostData]()
    var filterProfessionalLikeListData = [ProfessionalLikeJobPostData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hitprofessionalLikePostApi()
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setTable(){
        likeTableView.delegate = self
        likeTableView.dataSource = self
        likeTableView.register(UINib(nibName: "ConnectTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }

    @IBAction func infoAction(_ sender: UIButton) {
        let vc = InfoViewController()
        vc.specificjobDataArr =  jobLDatArr
        vc.job_id = jobIdentity
        self.pushViewController(vc, true)
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popViewController(true)
    }
    
    func hitprofessionalLikePostApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading", view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let workersJObID = UserDefaults.standard.string(forKey: "setWorkerID") ?? ""
        print("workersjob ID ====>>>>",workersJObID as Any)
        let param = ["job_id": workersJObID as Any] as [String : Any]
        print(param)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.professionalLikePost, params: param, headers: headers) { [self] response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aContact = try jsonDecoder.decode(ProfessionalLikeJobPostModel.self, from: data!)
                print(aContact)
                let status = aContact.status ?? 0
                if status == 1{
                    self.professionalWorkerList = aContact.data!
                    let uniqueLikepostdata = professionalWorkerList.unique { $0.user_id}
                    self.filterProfessionalLikeListData = uniqueLikepostdata
                    self.likeTableView.reloadData()
                }else if status == 0 {
                    if professionalWorkerList.count >  0 {
                        self.likeTableView.backgroundView =  nil
                    }else{
                        self.likeTableView.setBackgroundView(message: "No worker found.")
                    }

                    self.likeTableView.reloadData()
                }else{
                    self.professionalWorkerList.removeAll()
                    self.likeTableView.reloadData()
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
extension ProfessionalLikePostViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterProfessionalLikeListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConnectTableViewCell
        var sPhotoStr = filterProfessionalLikeListData[indexPath.row].photo ?? ""
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        cell.cellImg.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
        cell.cellLbl.text = filterProfessionalLikeListData[indexPath.row].username ?? ""
        if filterProfessionalLikeListData[indexPath.row].catagory_details?.count ?? 0 > 1{
            cell.designerLbl.text = "\(filterProfessionalLikeListData[indexPath.row].catagory_details?.first?.category_name ?? "") , \(filterProfessionalLikeListData[indexPath.row].catagory_details?.last?.category_name ?? "") "
        }
        else{
            cell.designerLbl.text = "\(filterProfessionalLikeListData[indexPath.row].catagory_details?.first?.category_name ?? "") "
        }
        if filterProfessionalLikeListData[indexPath.row].rate_type == "Per Day"{
            cell.priceLbl.text = "$\(filterProfessionalLikeListData[indexPath.row].rate_to ?? "")/d"
        }else if filterProfessionalLikeListData[indexPath.row].rate_type == "Per Hour"{
            cell.priceLbl.text = "$\(filterProfessionalLikeListData[indexPath.row].rate_to ?? "")/h"
        }else{
            cell.priceLbl.text = ""
        }
        cell.contentListView.backgroundColor = .clear
        likeTableView.backgroundColor =  .clear
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let vc = ProfessionalikePostDescriptionController()
            vc.job_id = filterProfessionalLikeListData[indexPath.row].job_id ?? ""
            vc.userNumberId =  filterProfessionalLikeListData[indexPath.row].user_id ?? ""
        vc.cat_ID =  filterProfessionalLikeListData[indexPath.row].catagory_details?.first?.cat_id ?? ""
            vc.userNumberId = filterProfessionalLikeListData[indexPath.row].user_id ?? ""
            self.pushViewController(vc, true)
    }
    
}
