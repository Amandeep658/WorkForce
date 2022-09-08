//
//  CoustomerChatVC.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 06/08/22.
//

import UIKit
import SDWebImage
import Alamofire

class CoustomerChatVC: UIViewController {
    
    @IBOutlet weak var customerChatListTV: UITableView!
    
    var getChatListData:UserChatListModel?
    var getUserListAllUser = [ChatUSerListAll_users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        uiConfigure()
    }
    
    func uiConfigure(){
        customerChatListTV.delegate = self
        customerChatListTV.dataSource = self
        customerChatListTV.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
        getAllChatList()
    }
    
    //    MARK: GET USER LIST FOR CHAT SCREEN
    func getAllChatList(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let param = ["page_no" : "1","per_page" : "40"] as [String : Any]
        print(param)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.getAllChatUser, params: param, headers: headers) { [self] (response) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aContact = try jsonDecoder.decode(UserChatListModel.self, from: data!)
                print(aContact)
                let status = aContact.status
                let message = aContact.message ?? ""
                print("message>>>>>>",message)
                if status == 1{
                    self.getChatListData = aContact
                    self.getUserListAllUser = aContact.all_users!
                    self.customerChatListTV.setBackgroundView(message: "")
                    self.customerChatListTV.reloadData()
                }
                else if status == 0{
                    self.getUserListAllUser.removeAll()
                    self.customerChatListTV.setBackgroundView(message: message)
                    self.customerChatListTV.reloadData()
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
    
    //    MARK: GET CURRENT TIME FROM TIMESTAMP
    func chatConvertTimeStampTodate(dateVal : String) -> String{
        let timeinterval = TimeInterval(dateVal)
        let dateFromServer = Date(timeIntervalSince1970:timeinterval ?? 0)
        print(dateFromServer)
        let dateFormater = DateFormatter()
        dateFormater.timeZone = TimeZone.current
        dateFormater.locale = NSLocale.current
        dateFormater.dateFormat = "hh:mm a"
        return dateFormater.string(from: dateFromServer)
    }
    
    
    
}
extension CoustomerChatVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getUserListAllUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath)as!
        ChatTableViewCell
        cell.nameLbl.text = getUserListAllUser[indexPath.row].company_name ?? ""
        cell.messageLbl.text = getUserListAllUser[indexPath.row].message ?? ""
        var sPhotoStr = getUserListAllUser[indexPath.row].photo ?? ""
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        cell.chatImg.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
        let badgeCount = Int(getUserListAllUser[indexPath.row].unread_count ?? "") ?? 0
        if badgeCount != 0{
            cell.badgecount.text = "\(badgeCount)"
            cell.badgecount.isHidden = false
        }else{
            cell.badgecount.isHidden = true
        }
        let timestamp = getUserListAllUser[indexPath.row].message_time ?? ""
        cell.timelbl.text  = chatConvertTimeStampTodate(dateVal:timestamp) == "" ? "00:00":chatConvertTimeStampTodate(dateVal:timestamp)
        cell.setImage()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SingleChatController()
        vc.chatRoomId = getUserListAllUser[indexPath.row].room_no ?? ""
        vc.userName = getUserListAllUser[indexPath.row].company_name ?? ""
        vc.userProfileImage = getUserListAllUser[indexPath.row].photo ?? ""
        self.pushViewController(vc, true)
    }
}
