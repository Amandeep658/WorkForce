//
//  NotificationViewController.swift
//  WorkForce
//
//  Created by apple on 07/05/22.
//

import UIKit
import Alamofire
import SDWebImage
import KRPullLoader

class NotificationViewController: UIViewController {

    @IBOutlet weak var bachBtn: UIButton!
    @IBOutlet weak var notificationTableView: UITableView!
    
    var notificationListData = [ProfessionalNotificationData]()
    var pageCount = Int()
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationTableView.delegate = self
        notificationTableView.dataSource = self
        notificationTableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        page = 1
        pageCount = 1
        let loadMoreView = KRPullLoadView()
        loadMoreView.delegate = self
        notificationTableView.addPullLoadableView(loadMoreView, type: .loadMore)
        hitNotificationList()
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.popViewController(true)
    }
    
    func hitNotificationList(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.professionalNotificationList, params: hitJobListingParameters(), headers: headers) { [self] response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aContact = try jsonDecoder.decode(ProfessionalNotificationModel.self, from: data!)
                print(aContact)
                let status = aContact.status ?? 0
                let message = aContact.message ?? ""
                if status == 1{
                    self.pageCount = self.pageCount + 1
                    self.notificationListData.append(contentsOf: aContact.data!)
                    self.notificationTableView.setBackgroundView(message: "")
                    self.notificationTableView.reloadData()
                }else{
                    self.notificationListData.removeAll()
                    self.notificationTableView.setBackgroundView(message: message)
                    self.notificationTableView.reloadData()
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
    func hitJobListingParameters() -> [String:Any] {
        var parameters : [String:Any] = [:]
        parameters["page_no"] = pageCount as AnyObject
        parameters["per_page"] = "10" as AnyObject
        parameters["deviceToken"] = AppDefaults.deviceToken
        print(parameters)
        return parameters
    }
    
    //    MARK: GET CURRENT TIME FROM TIMESTAMP
        func chatConvertTimeStampTodate(dateVal : String) -> String{
            let timeinterval = TimeInterval(dateVal)
            let dateFromServer = Date(timeIntervalSince1970:timeinterval ?? 0)
            print(dateFromServer)
            let dateFormater = DateFormatter()
            dateFormater.timeZone = TimeZone.current
            dateFormater.locale = NSLocale.current
            dateFormater.dateFormat = "d MMM yyyy hh:mm a"
            return dateFormater.string(from: dateFromServer)
        }

}
extension NotificationViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as? NotificationTableViewCell
        cell?.notificationLbl.text = notificationListData[indexPath.row].message ?? ""
        var sPhotoStr = notificationListData[indexPath.row].photo ?? ""
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        cell?.notificationImg.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"placeholder"))
        let timestamp = notificationListData[indexPath.row].creation_date ?? ""
        cell?.timeLbl.text  = chatConvertTimeStampTodate(dateVal:timestamp) == "" ? "00:00":chatConvertTimeStampTodate(dateVal:timestamp)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notificationListData[indexPath.row]
        guard notification.notification_type == "1" else { return }
        let chat  = SingleChatController()
        chat.userName = notification.username ?? ""
        chat.chatRoomId = notification.room_id ?? ""
        chat.companyname = notification.username ?? ""
        self.navigationController?.pushViewController(chat, animated: true)
    }
    
    
}
extension NotificationViewController:KRPullLoadViewDelegate{
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        if type == .loadMore {
            switch state {
            case let .loading(completionHandler):
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    completionHandler()
                    self.hitNotificationList()
                }
            default: break
            }
            return
        }
        switch state {
        case .none:
            pullLoadView.messageLabel.text = ""
            
        case let .pulling(offset, threshould):
            if offset.y > threshould {
                pullLoadView.messageLabel.text = "Pull more. offset: \(Int(offset.y)), threshould: \(Int(threshould)))"
            } else {
                pullLoadView.messageLabel.text = "Release to refresh. offset: \(Int(offset.y)), threshould: \(Int(threshould)))"
            }
        case let .loading(completionHandler):
            pullLoadView.messageLabel.text = "Updating..."
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                completionHandler()
                
                
            }
        }
    }
    
    
}
