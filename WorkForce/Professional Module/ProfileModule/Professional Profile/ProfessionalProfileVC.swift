//
//  ProfessionalProfileVC.swift
//  WorkForce
//
//  Created by apple on 29/06/22.
//

import UIKit
import Alamofire
import SDWebImage

class ProfessionalProfileVC: UIViewController {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var editProfile: UIButton!
    @IBOutlet weak var professionalTableView: UITableView!
    
    let imageArr = ["re","sb","ic","abb","pp","deleteUser","log"]
    let Label = ["Recovery Email".localized(),"Update Subscription Plan".localized(),"Terms of Use".localized(),"About Us".localized(),"Privacy Policy".localized(),"Delete Account".localized(),"Logout".localized()]
    
    var professionalUserDate:ProfessionalProfileData?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTable()
        self.hitCompanyListing()
        professionalDataUpdate = {
            self.hitCompanyListing()
        }
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    func setTable(){
        professionalTableView.delegate = self
        professionalTableView.dataSource = self
        professionalTableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
    }
    

    @IBAction func editProfile(_ sender: UIButton) {
        let vc = EditProfileDesignerViewController()
        vc.professionalUserDate =  self.professionalUserDate
        vc.skillUserIdKey = professionalUserDate?.user_id ?? ""
        self.pushViewController(vc, true)
    }

    @IBAction func imageTapBtn(_ sender: UIButton) {
        let vc = ProfileDesignViewController()
        vc.professionalUserDate = self.professionalUserDate
        self.pushViewController(vc, true)
    }
    
    //    MARK: BUSINESSN PROFILE API
        
    func hitCompanyListing(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.getProfessionalProfile, params: [:], headers: headers) { response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aContact = try jsonDecoder.decode(ApiModel<ProfessionalProfileData>.self, from: data!)
                self.professionalUserDate = aContact.data
                let status = aContact.status
                let message = aContact.message ?? ""
                if status == 401 {
                    UserDefaults.standard.removeObject(forKey: "authToken")
                    appDel.navigation()
                } else if status == 1{
                    self.professionalUserDate =  aContact.data!
                    DispatchQueue.main.async { [self] in
                        self.nameLbl.text =  aContact.data?.username ?? ""
                        self.emailLbl.text = aContact.data?.email ?? ""
                        var sPhotoStr = aContact.data?.photo ?? ""
                        UserDefaults.standard.set(sPhotoStr, forKey: "ProfessionalProfileImage")
                        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                        self.userImgView.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
                        self.professionalTableView.reloadData()
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
//    MARK: HIT DELETE ACCOUNT API
    func hitDeleteprofessionalAccountApi(){
        let AToken = AppDefaults.token ?? ""
        print(AToken)
        let headers: HTTPHeaders = ["Token": AToken]
        let parameter = ["user_id": UserDefaults.standard.string(forKey: "uID") ?? "","type":"2"] as [String : Any]
        print(parameter)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.deleteUserAccount, params: parameter, headers: headers) { (response) in
            print(response)
            let status = response["status"] as? Int ?? 0
            let logMessage = response["message"] as? String ?? ""
            print(status)
            if status == 1 {
                self.hitprofessionalLogoutApi()
            }else{
               self.Alert(message:logMessage )
            }
        } failure: { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
            }
    }
    
//    MARK: LOGOUT API
    func hitprofessionalLogoutApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        let AToken = AppDefaults.token ?? ""
        print(AToken)
        let headers: HTTPHeaders = ["Token": AToken]
        AFWrapperClass.requestPostWithMultiFormData(kBASEURL + WSMethods.logout, params: nil, headers: headers) { (response) in
            print(response)
            AFWrapperClass.svprogressHudDismiss(view: self)
            let status = response["status"] as? Int ?? 0
            let logoutMessage = response["message"] as? String ?? ""
            print(status)
            if status == 1 {
                UserDefaults.standard.removeObject(forKey: "uID")
                UserDefaults.standard.removeObject(forKey: "subscribed")
                UserDefaults.standard.removeObject(forKey: "SubscriptionID")
                UserDefaults.standard.removeObject(forKey: "authToken")
                UserDefaults.standard.removeObject(forKey: "pid")
                UserDefaults.standard.removeObject(forKey: "ProfessionalProfileImage")
                appDel.navigation()
            }else{
                self.Alert(message:logoutMessage )
            }
        } failure: { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
            }
    }
    
}
extension ProfessionalProfileVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Label.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
        cell.cellImg.image = UIImage(named: imageArr[indexPath.row])
        cell.cellLbl.text = Label[indexPath.item]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Label[indexPath.row] {
        case "Recovery Email".localized():
            if professionalUserDate?.verified == "1"{
                showAlert(message: "Email already registered".localized(), title: AppAlertTitle.appName.rawValue)
            }else{
                let vc = RecoveryEmailVC()
                vc.isFromAccount = true
                self.pushViewController(vc, true)
            }
            break
        case "Update Subscription Plan".localized():
            print("its update")
            let vc = SubscribePlanViewController()
            vc.hidesBottomBarWhenPushed = true
             self.pushViewController(vc,true)
        case "Terms of Use".localized():
            let terms =  TermsConditionVC()
            self.pushViewController(terms, true)
            break
        case "About Us".localized():
            let about =  AboutUsVC()
            self.pushViewController(about, true)
            break
        case "Privacy Policy".localized():
            let privacy =  PrivacyPolicyVC()
            self.pushViewController(privacy, true)
            break
        case "Delete Account".localized():
            self.popActionAlert(title: AppAlertTitle.appName.rawValue, message: "Are you sure you want to delete your account?".localized(), actionTitle: ["Yes".localized(),"No".localized()], actionStyle: [.default, .cancel], action: [{ ok in
                self.hitDeleteprofessionalAccountApi()
            },{
                cancel in
                self.dismiss(animated: false, completion: nil)
            }])
            break
        case "Logout".localized() :
            self.popActionAlert(title: AppAlertTitle.appName.rawValue, message: "Are you sure you want to logout ?".localized(), actionTitle: ["Yes".localized(),"No".localized()], actionStyle: [.default, .cancel], action: [{ ok in
                self.hitprofessionalLogoutApi()
            },{
                cancel in
                self.dismiss(animated: false, completion: nil)
            }])
        default:
            break
        }
      
    
}
}
