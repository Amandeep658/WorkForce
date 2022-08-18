//
//  CoustomerConnectVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 06/08/22.
//

import UIKit
import Alamofire

class CoustomerConnectVC: UIViewController {

//    MARK: OUTLETS
    
    @IBOutlet weak var companiesTableView: UITableView!
    
    var customerConnectArr = [BusinessConnectCompanyListData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden =  false
        companiesTableView.delegate = self
        companiesTableView.dataSource = self
        companiesTableView.register(UINib(nibName: "customerConnectListCell", bundle: nil), forCellReuseIdentifier: "customerConnectListCell")
        self.hitCompaniesListApi()
    }
    
    //    MARK: GET JOB LIST
    func hitCompaniesListApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading", view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let parameter = ["user_id": UserDefaults.standard.string(forKey: "uID") ?? "","page_no":"1","per_page":"100"] as [String : Any]
        print(parameter)

        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.getCompanyLikeCustomer, params: parameter, headers: headers) { [self] response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aContact = try jsonDecoder.decode(BusinessConnectComapnyModel.self, from: data!)
                print(aContact)
                let status = aContact.status ?? 0
                let connectmessage = aContact.message ?? ""
                if status == 1{
                        self.companiesTableView.setBackgroundView(message: "")
                        self.customerConnectArr = aContact.data!
                        self.companiesTableView.reloadData()
                }else if status == 0{
                        self.companiesTableView.setBackgroundView(message: connectmessage)
                    self.companiesTableView.reloadData()
                }else{
                    print("Its connect view controller")
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
extension CoustomerConnectVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customerConnectArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerConnectListCell", for: indexPath) as! customerConnectListCell
        var sPhotoStr = customerConnectArr[indexPath.row].photo ?? ""
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        cell.customeImgView.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
        cell.companyName.text = customerConnectArr[indexPath.row].company_name ?? ""
        cell.locationLbl.text = customerConnectArr[indexPath.row].location ?? ""
        cell.cellView.layer.cornerRadius =  8.0
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ConnectListDetailVC()
        vc.user_iD =  customerConnectArr[indexPath.row].user_id ?? ""
        self.pushViewController(vc, true)
    }
   
    
}
