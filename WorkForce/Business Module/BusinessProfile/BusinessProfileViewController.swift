//
//  BusinessProfileViewController.swift
//  WorkForce
//
//  Created by Dharmani Apps on 17/05/22.
//

import UIKit
import Alamofire
import SDWebImage

class BusinessProfileViewController: UIViewController {
    
    var company_isselect:Bool = true
    var companyProfileDataArr:CompanyListingModel?
    var detailArr:CompanyListingData?

    var tapGesture = UITapGestureRecognizer()
//    let imageArr = ["re","job-1","sb","ic","abb","pp","deleteUser","log"]
//    let label = ["Recovery Email".localized(),"Manage Jobs".localized(),"Update Subscription Plan".localized(),"Terms of Use".localized(),"About Us".localized(),"Privacy Policy".localized(),"Delete Account".localized(),"Logout".localized()]
    let label = ["Manage Jobs".localized(),"Update Subscription Plan".localized(),"Recovery Email".localized(),"Terms of Use".localized(),"Invoices","About Us".localized(),"Privacy Policy".localized(),"Delete Account".localized(),"Logout".localized()]
    let imageArr = ["job-1","sb","re","ic","InvoiceIcon","abb","pp","deleteUser","log"]

    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var profleImgView: UIImageView!
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var emailLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
        hitCompanyListing()
        companyDataUpdate = {
            self.hitCompanyListing()
        }
        businessDataUpdate = {
            self.hitCompanyListing()
        }
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    //    MARK: UI UPDATE
    func setTable(){
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        let vc = BusinessEditProfileViewController()
        vc.companyEditDataArr = companyProfileDataArr
        self.pushViewController(vc, true)
    }
    
    
    @IBAction func profileInfoBtn(_ sender: UIButton) {
        let vc = NikeIncDesignerViewController()
        vc.companyPArr = companyProfileDataArr
        self.pushViewController(vc, true)
    }
    
//    MARK: COMPANY LISTING API
    func hitCompanyListing(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.getCompanyListing, params: [:], headers: headers) { response in
            AFWrapperClass.svprogressHudDismiss(view: self)
        print(response)
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aContact = try jsonDecoder.decode(CompanyListingModel.self, from: data!)
                print(aContact)
                self.companyProfileDataArr = aContact
                let status = aContact.status
                let message = aContact.message ?? ""
                if status == 401 {
                    UserDefaults.standard.removeObject(forKey: "authToken")
                    appDel.navigation()
                } else if status == 1{
                    self.detailArr =  aContact.data!
                    DispatchQueue.main.async { [self] in
                        self.namelbl.text = aContact.data?.company_name ?? ""
                        self.emailLbl.text = aContact.data?.email ?? ""
                        var sPhotoStr = aContact.data?.photo ?? ""
                        UserDefaults.standard.set(sPhotoStr, forKey: "BusinessProfileImage")
                        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                        self.profleImgView.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
                        self.profileTableView.reloadData()
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
    func hitDeleteAccountApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        let AToken = AppDefaults.token ?? ""
        print(AToken)
        let headers: HTTPHeaders = ["Token": AToken]
        let parameter = ["user_id": UserDefaults.standard.string(forKey: "uID") ?? "","type":"1"] as [String : Any]
        print(parameter)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.deleteUserAccount, params: parameter, headers: headers) { (response) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            let status = response["status"] as? Int ?? 0
            let logMessage = response["message"] as? String ?? ""
            print(status)
            if status == 1 {
                print("its delete")
                PurchaseHelper.shared.removePurchaseDefaults()
                UserDefaults.standard.removeObject(forKey: "subscribed")
                UserDefaults.standard.removeObject(forKey: "SubscriptionID")
                UserDefaults.standard.removeObject(forKey: "uID")
                UserDefaults.standard.removeObject(forKey: "authToken")
                UserDefaults.standard.removeObject(forKey: "pid")
                appDel.navigation()
            }else{
               self.Alert(message:logMessage )
            }
        }  failure: { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
            }
    }
    
    
//    MARK: HIT LOGOUT API
    func hitLogoutApi(){
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
            let logMessage = response["message"] as? String ?? ""
            print(status)
            if status == 1 {
                PurchaseHelper.shared.removePurchaseDefaults()
                UserDefaults.standard.removeObject(forKey: "subscribed")
                UserDefaults.standard.removeObject(forKey: "SubscriptionID")
                UserDefaults.standard.removeObject(forKey: "uID")
                UserDefaults.standard.removeObject(forKey: "BusinessProfileImage")
                UserDefaults.standard.removeObject(forKey: "authToken")
                UserDefaults.standard.removeObject(forKey: "pid")
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
@available(iOS 15, *)
extension BusinessProfileViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return label.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath)as! ProfileTableViewCell
        cell.cellImg.image = UIImage(named: imageArr[indexPath.row])
        cell.cellLbl.text = label[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch label[indexPath.row] {
        case "Recovery Email".localized():
            if detailArr?.verified == "1"{
                showAlert(message: "Email already registered".localized(), title: AppAlertTitle.appName.rawValue)
            }else{
                let vc = RecoveryEmailVC()
                vc.isFromAccount = true
                self.pushViewController(vc, true)
            }
            break
        case "Manage Jobs".localized():
            let vc = ManageJobsViewController()
            self.pushViewController(vc, true)
            break
        case "Update Subscription Plan".localized() :
            let vc = SubscribePlanViewController()
            self.pushViewController(vc, true)
            break
        case "Terms of Use".localized() :
            let terms =  TermsConditionVC()
            self.pushViewController(terms, true)
            break
        case "Invoices":
            let invoice =  InvoiceListVC()
            self.pushViewController(invoice, true)
            break
        case "About Us".localized() :
            let about =  AboutUsVC()
            self.pushViewController(about, true)
            break
        case "Privacy Policy".localized():
            let privacy =  PrivacyPolicyVC()
            self.pushViewController(privacy, true)
            break
        case "Delete Account".localized() :
            self.popActionAlert(title: AppAlertTitle.appName.rawValue, message: "Are you sure you want to delete your account?".localized(), actionTitle: ["Yes".localized(),"No".localized()], actionStyle: [.default, .cancel], action: [{ ok in
                self.hitDeleteAccountApi()
            },{
                cancel in
                self.dismiss(animated: false, completion: nil)
            }])
            break
        case "Logout".localized() :
            self.popActionAlert(title: AppAlertTitle.appName.rawValue, message: "Are you sure you want to logout ?".localized(), actionTitle: ["Yes".localized(),"No".localized()], actionStyle: [.default, .cancel], action: [{ ok in
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

extension UINavigationController {
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(vc, animated: animated)
        }
    }
}
extension UIViewController {
    func popActionAlert(title:String,message:String,actionTitle:[String],actionStyle:[UIAlertAction.Style],action:[(UIAlertAction) -> Void]){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let attributedString = NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        ])
        alert.setValue(attributedString, forKey: "attributedTitle")
        for (index,title) in actionTitle.enumerated(){
            let action = UIAlertAction.init(title: title, style: actionStyle[index], handler: action[index])
            alert.addAction(action)
            alert.view.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
}
