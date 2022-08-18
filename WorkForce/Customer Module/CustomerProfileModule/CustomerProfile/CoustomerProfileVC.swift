//
//  CoustomerProfileVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 06/08/22.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift
import SDWebImage

class CoustomerProfileVC: UIViewController {
   
    
    @IBOutlet weak var customerProfileTableView: UITableView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var customerProfileView: UIImageView!
    
    var imageArr = ["re","ic","abb","pp","log"]
    var listArr = ["Recovery Email","Terms of Use","About Us","Privacy Policy","Logout"]
    var companyProfileData:CompanyListingModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hitGetProfileApi()
        customerDataUpdate = {
            self.hitGetProfileApi()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        uiConfigure()
    }

    @IBAction func profileBtn(_ sender: UIButton) {
        let vc = CustomerEditProfileVC()
        vc.customerPDate = companyProfileData
        self.pushViewController(vc, true)
        
    }
    
    func uiConfigure(){
        customerProfileTableView.delegate = self
        customerProfileTableView.dataSource = self
        customerProfileTableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
    }
    
    //    MARK: HIT GET PROFILE API
    func hitGetProfileApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading", view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.getCustomer, params: [:], headers: headers) { response in
            AFWrapperClass.svprogressHudDismiss(view: self)
        print(response)
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aContact = try jsonDecoder.decode(CompanyListingModel.self, from: data!)
                print(aContact)
                self.companyProfileData = aContact
                let status = aContact.status
                let message = aContact.message ?? ""
                if status == 401 {
                    UserDefaults.standard.removeObject(forKey: "authToken")
                    appDel.navigation()
                } else if status == 1{
                    DispatchQueue.main.async { [self] in
                        self.nameLbl.text = aContact.data?.username ?? ""
                        self.addressLbl.text = aContact.data?.city ?? ""
                        var sPhotoStr = aContact.data?.photo ?? ""
                        UserDefaults.standard.set(sPhotoStr, forKey: "CoustomerProfileImage")
                        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                        self.customerProfileView.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
                        self.customerProfileTableView.reloadData()
                        if let tabBar = self.tabBarController as? TabBarVC {
                            print("tab bar is \(tabBar)")
                            tabBar.updateProfileImage()
                        }
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
    
    //    MARK: HIT LOGOUT API
    func hitLogoutApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading", view: self)
        }
        let AToken = AppDefaults.token ?? ""
        print(AToken)
        let headers: HTTPHeaders = ["Token": AToken]
        AFWrapperClass.requestPostWithMultiFormData(kBASEURL + WSMethods.logout, params: nil, headers: headers) { (response) in
            print(response)
            AFWrapperClass.svprogressHudDismiss(view: self)
            let status = response["status"] as? Int ?? 0
            let logMessage = response["message"] as? String ?? ""
            print(status)
            if status == 1 {
                PurchaseHelper.shared.removePurchaseDefaults()
                UserDefaults.standard.removeObject(forKey: "uID")
                UserDefaults.standard.removeObject(forKey: "authToken")
                appDel.navigation()
            }else{
                self.Alert(message:logMessage )
            }
        } failure: { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
        
    
}
extension CoustomerProfileVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath)as! ProfileTableViewCell
        cell.cellImg.image = UIImage(named: imageArr[indexPath.row])
        cell.cellLbl.text = listArr[indexPath.item]
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch listArr[indexPath.row] {
        case "Recovery Email" :
            let email = RecoveryEmailVC()
            self.pushViewController(email, true)
            break
        case "Terms of Use" :
            let terms =  TermsConditionVC()
            self.pushViewController(terms, true)
            break
        case "About Us" :
            let about =  AboutUsVC()
            self.pushViewController(about, true)
            break
        case "Privacy Policy" :
            let privacy =  PrivacyPolicyVC()
            self.pushViewController(privacy, true)
            break
        case "Logout" :
            self.popActionAlert(title: AppAlertTitle.appName.rawValue, message: "Are you sure you want to logout ?", actionTitle: ["Yes","No"], actionStyle: [.default, .cancel], action: [{ ok in
                self.hitLogoutApi()
            },{
                cancel in
                self.dismiss(animated: false, completion: nil)
            }])
            break
        default:
            break
        }
    }
    
}
