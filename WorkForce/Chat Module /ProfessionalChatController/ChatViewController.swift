//
//  ChatViewController.swift
//  WorkForce
//
//  Created by apple on 06/05/22.
//

import UIKit
import SDWebImage
import Alamofire
import IQKeyboardManagerSwift

class ChatViewController: UIViewController {
    
    @IBOutlet weak var chatTableView: UITableView!
    var getChatListData:UserChatListModel?
    var getMessagesListArr: UserChatList_data?
    var getUserListAllUser = [ChatUSerListAll_users]()
    var selectedIndex = Int()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.chatPressed(_:)), name: Notification.Name(rawValue: "chatPressed"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        self.setTable()
    }
    
    func setTable(){
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
    }
    
    @objc func chatPressed(_ notification : Notification){
        self.hitSubscriptCheckApi()
    }
    
    
    //    MARK: SUBSCRIPTION STAUTS CHECK

    func hitSubscriptCheckApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "", view: self)
        }
        let authToken = AppDefaults.token ?? ""
        let header: HTTPHeaders = ["Token": authToken]
        print("subscriptionStatus == >>>>", header)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.subscriptionstatus, params: [:], headers: header) { [self] (response) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            let status = response["status"] as? Int ?? 0
            print(status)
            if status == 1 {
                self.getAllChatList()
                print("its subscribe")
            }else{
                let vc = SubcribeViewController()
                vc.VC = self
                vc.subcriptionType = "chat"
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, true)
                self.chatTableView.setBackgroundView(message: "Please take subscription plan.".localized())
            }
        } failure: { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
            }

        
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
                let message = aContact.message
                if status == 1{
                    self.getChatListData = aContact
                    self.getMessagesListArr = aContact.user_data!
                    self.getUserListAllUser = aContact.all_users!
                    self.chatTableView.setBackgroundView(message: "")
                    self.chatTableView.reloadData()
                }
                else{
                    self.chatTableView.setBackgroundView(message: message!)
                    self.getUserListAllUser.removeAll()
                    self.chatTableView.reloadData()
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
 extension ChatViewController : UITableViewDelegate , UITableViewDataSource{
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
        let badgeCount = Int(getUserListAllUser[indexPath.row].unread_count ?? "")!
        print("badcount=======>>>>>",badgeCount)
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
        vc.userName = getUserListAllUser[indexPath.row].username ?? ""
        vc.userProfileImage = getUserListAllUser[indexPath.row].photo ?? ""
        vc.companyname = getUserListAllUser[indexPath.row].company_name ?? ""
        self.pushViewController(vc, true)
    }
}
