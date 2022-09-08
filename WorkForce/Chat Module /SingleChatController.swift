//
//  SingleChatController.swift
//  WorkFirce
//
//  Created by Aman on 07/10/20.
//  Copyright © 2022 Aman. All rights reserved.
//

import UIKit
import GrowingTextView
import IQKeyboardManagerSwift
import Alamofire
import SDWebImage
import SocketIO

let SCREEN_SIZE = UIScreen.main.bounds
class SingleChatController: UIViewController{
    
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextView: GrowingTextView!
    @IBOutlet weak var sendButton: LoadingButton!
    @IBOutlet weak var chatTable: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var firstTimeLoadCell: Bool = true
    var isAllReadMessage:Bool = false
    var typingTimer:Timer?
    var pageCompleted:Bool = false
    var updating:Bool = false
    var nameLbl: String?
    var pushNav = Bool()
    var chatStatus:ChatDataModel?
    var chatHistory = [ChatAllMessages]()
    var companyProfileDataArr:CompanyListingModel?
    var userDetailData:CompanyListingData?
    var ChatReceiver_detailArr:ChatReceiver_detail?
    var headerView: UIView!
    var user_ID = ""
    var userName = ""
    var chatRoomId = ""
    var userProfileImage = ""
    var companyname = ""
    var page_size: Int = 50
    var page_no: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSocket()
        self.setGrowingTextView()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setTableView()
        self.setControllerData()
        IQKeyboardManager.shared.enable = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.scrollToBottom()
        self.tableHeaderView()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "endSessionNotification"), object: nil)
    }
    
    //    MARK: BACK BUTTON ACTION
    @IBAction func backAction(_ sender: Any) {
        if pushNav == true{
            print("its simple true back")
            self.popVC()
        }else{
            print("its simple nav back")
            self.popVC()
        }
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
        self.tabBarController?.tabBar.isHidden = true
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setSocket() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let socketConnectionStatus = SocketManger.shared.socket.status
            switch socketConnectionStatus {
            case SocketIOStatus.connected:
                print("socket connected")
                SocketManger.shared.socket.emit("ConncetedChat",self.chatRoomId)
                self.newMessageSocketOn()
                self.connectSocketOn()
            case SocketIOStatus.connecting:
                print("socket connecting")
            case SocketIOStatus.disconnected:
                print("socket disconnected")
                SocketManger.shared.socket.connect()
                self.connectSocketOn()
                self.newMessageSocketOn()
            case SocketIOStatus.notConnected:
                print("socket not connected")
                SocketManger.shared.socket.connect()
                self.connectSocketOn()
                self.newMessageSocketOn()
            }
        }
    }
    
    func connectSocketOn(){
        SocketManger.shared.onConnect {
            SocketManger.shared.socket.emit("ConncetedChat", self.chatRoomId)
        }
    }
    
    func newMessageSocketOn(){
        SocketManger.shared.handleNewChatMessage { [self] (message,time) in
            if let messageDict = message as? NSDictionary{
                print(messageDict)
                self.chatHistory.append(ChatAllMessages(dict: messageDict))
                let row = chatHistory.count-1
                self.chatTable.insertRows(at: [IndexPath(row: row, section: 0)], with: .bottom)
                self.chatTable.beginUpdates()
                self.chatTable.endUpdates()
                DispatchQueue.main.async { [self] in
                    if chatHistory.count > 0 {
                        self.scrollToBottom()
                    }
                }
            }
            else{
                print("Its chat")
            }
        }
    }
        
    func setTableView(){
        self.chatTable.delegate = self
        self.chatTable.dataSource = self
        self.chatTable.separatorStyle = .none
        self.chatTable.showsVerticalScrollIndicator = false
        self.chatTable.register(UINib(nibName: "LeftTableViewCell", bundle: nil), forCellReuseIdentifier: "LeftTableViewCell")
        self.chatTable.register(UINib(nibName: "RightTableViewCell", bundle: nil), forCellReuseIdentifier: "RightTableViewCell")
    }
    
    func setControllerData() {
        if UserType.userTypeInstance.userLogin == .Bussiness{
            self.pushNav = true
            print("push nav =====>>>>>>",pushNav)
            self.nameLabel.text = userName
        }else if UserType.userTypeInstance.userLogin == .Professional{
            self.nameLabel.text = companyname
        }else if UserType.userTypeInstance.userLogin == .Coustomer{
            self.nameLabel.text = userName
        }
        print("push navnavv =====>>>>>>",pushNav)
        self.hitCompanyListing()
        self.getAllMessagesApi(view:  self)
        self.updatedMessageSeen()
    }
    
    func setGrowingTextView() {
        self.messageTextView.delegate = self
        self.messageTextView.tintColor = .black
        self.messageTextView.trimWhiteSpaceWhenEndEditing = true
        self.messageTextView.placeholder = ""
        self.messageTextView.placeholderColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    func scrollToBottom() {
        guard self.chatHistory.count > 0 else { return }
        let section = 0
        let row = self.chatHistory.count-1
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: row, section: section)
            self.chatTable.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    //    MARK: SEND MESSAGE
    func sendNewMessage(data: NSDictionary) {
        let messageData = ChatAllMessages(dict: data)
        self.chatHistory.append(messageData)
        print(messageData)
        let indexPath = IndexPath(row: self.chatHistory.count-1, section: 0)
        self.chatTable.beginUpdates()
        self.chatTable.insertRows(at: [indexPath], with: .bottom)
        self.chatTable.endUpdates()
        self.scrollToBottom()
        self.sendButton.isSelected = false
        self.sendButton.isEnabled = false
    }
    
    func tableHeaderView() {
        self.headerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_SIZE.width, height: 60))
        let activityIndigator = UIActivityIndicatorView(style: .gray)
        activityIndigator.frame = CGRect(x: 0, y: 15, width: SCREEN_SIZE.width, height: 30)
        activityIndigator.startAnimating()
        self.headerView.addSubview(activityIndigator)
    }
    
    
    
    @IBAction func sendAction(_ sender: UIButton) {
        guard IJReachability.isConnectedToNetwork() == true else {
            return
        }
        let message = messageTextView.text.trimWhiteSpace
        guard message.count > 0 else {
            return
        }
        self.addMessageApi()
        self.messageTextView.text = nil
        self.sendButton.isSelected = false
        self.sendButton.isEnabled = false
    }
    
}

extension SingleChatController: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.hasText == true && textView.text.trimWhiteSpace != "" {
            self.sendButton.isSelected = true
            self.sendButton.isEnabled = true
        } else {
            self.sendButton.isSelected = false
            self.sendButton.isEnabled = false
        }
        self.editingChanged(textView)
    }
    
    func editingChanged(_ textView: UITextView) {
        if self.typingTimer != nil {
            self.typingTimer?.invalidate()
            self.typingTimer = nil
        }
        self.typingTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(searchForKeyword(_:)), userInfo: textView.text!, repeats: false)
    }
    
    @objc func searchForKeyword(_ timer: Timer) {
    }
    
    //    MARK: GET ALL MESSAGE API
    func getAllMessagesApi(view: UIViewController) {
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: view)
        }
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let params: Parameters = self.getAllmessageGeneratingParameters()
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.GetChatListing, params: params, headers: headers) { [self] (response) in
            AFWrapperClass.svprogressHudDismiss(view: view)
            print(response)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aContact = try jsonDecoder.decode(ChatDataModel.self, from: data!)
                print(aContact)
                let status = aContact.status
                let message = aContact.message ?? ""
                if status == 1{
                    self.page_no += 1
                    self.chatStatus = aContact
                    self.chatHistory = aContact.all_messages ?? []
                    self.chatHistory.reverse()
                    self.chatTable.reloadData()
                    self.chatTable.tableViewScrollToBottom(animated: true)
                }else{
                    self.chatTable.reloadData()
                }
            }
            catch let parseError {
                print("JSON Error \(parseError.localizedDescription)")
                self.chatTable.reloadData()
            }
            
        } failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: view)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: view)
        }
        
    }
    
    //    MARK: UPDATED MESSAGE SEEN
    
    func updatedMessageSeen(){
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        let param = ["room_id" : chatRoomId ] as [String : Any]
        print(param)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.messageSeenUpdated, params: param, headers: headers) { response in
            print(response)
            let status = response["status"] as? Int ?? 0
            let message = response["message"] as? String ?? ""
            print(status)
            if status == 1 {
                print("mesage seen =====>>>>>",message)
            }else{
                alert(AppAlertTitle.appName.rawValue, message: message, view: self)
            }
        }  failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
    
    
    
    
    //    MARK: PROFILE DEATIL DATA
    func hitCompanyListing(){
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.getCompanyListing, params: [:], headers: headers) { response in
            print(response)
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aContact = try jsonDecoder.decode(CompanyListingModel.self, from: data!)
                print(aContact)
                let status = aContact.status
                let message = aContact.message ?? ""
                if status == 1{
                    DispatchQueue.main.async { [self] in
                        self.companyProfileDataArr = aContact
                        self.user_ID = companyProfileDataArr?.data?.user_id ?? ""
                        self.userDetailData = aContact.data
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
    
    //   MARK: CHAT LISTING PARAMETERS
    func getAllmessageGeneratingParameters() -> Parameters {
        var parameters :Parameters = [:]
        parameters["room_id"] = chatRoomId
        parameters["per_page"] = page_size
        parameters["page_no"]  = page_no + 1
        print(parameters)
        return parameters
    }
    
    
}
extension UITableView {
    
    func indexPathExists(indexPath:IndexPath) -> Bool {
        if indexPath.section >= self.numberOfSections {
            return false
        }
        if indexPath.row >= self.numberOfRows(inSection: indexPath.section) {
            return false
        }
        return true
    }
    
    func tableViewScrollToBottom(animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: animated)
            }
        }
    }
}

extension SingleChatController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatModel = chatHistory[indexPath.row]
        if chatModel.user_id ?? "" == companyProfileDataArr?.data?.user_id ?? "" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RightTableViewCell", for: indexPath) as! RightTableViewCell
            cell.setMessageData(chatModel)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeftTableViewCell", for: indexPath) as! LeftTableViewCell
            cell.setMessageData(chatModel)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard self.pageCompleted == false else {return}
        guard self.updating == false else { return }
        guard self.firstTimeLoadCell == false else {
            self.firstTimeLoadCell = false
            return}
        if indexPath.row == 0 {
            
        }
    }
    
    func checkHeaderAnimation(row: Int) {
        guard self.pageCompleted == false else {return}
        if row == 0 {
            self.chatTable.tableHeaderView = self.headerView
        } else {
            self.chatTable.tableHeaderView = nil
        }
    }
    
    
}

extension SingleChatController {
    //MARK: Keyboard Functions
    @objc func keyboardWillShow(_ notification : Foundation.Notification) {
        let value: NSValue = (notification as NSNotification).userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        var duration = 0.3
        var animation = UIView.AnimationOptions.curveLinear
        if let value  = (notification as NSNotification).userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            duration = value
        }
        if let value = (notification as NSNotification).userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            animation = UIView.AnimationOptions(rawValue: value)
        }
        let keyboardSize = value.cgRectValue.size
        self.bottomConstraint.constant = keyboardSize.height
        self.view.setNeedsUpdateConstraints()
        UIView.animate(withDuration: duration, delay: 0.0, options: animation, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: {finished in
            self.scrollToBottom()
        })
    }
    
    @objc func keyboardWillHide(_ notification: Foundation.Notification) {
        var duration = 0.3
        var animation = UIView.AnimationOptions.curveLinear
        if let value  = (notification as NSNotification).userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            duration = value
        }
        if let value = (notification as NSNotification).userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            animation = UIView.AnimationOptions(rawValue: value)
        }
        self.bottomConstraint.constant = 0
        self.view.setNeedsUpdateConstraints()
        UIView.animate(withDuration: duration, delay: 0.0, options: animation, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: { finished in
            DispatchQueue.main.async {
                self.scrollToBottom()
            }
        })
    }
}

extension SingleChatController {
    func addMessageApi()  {
        self.sendButton.isSelected = false
        self.sendButton.isEnabled = false
        let textCount = messageTextView.text.trimWhiteSpace
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let url = kBASEURL + WSMethods.sendMessage
        var params = [String:Any]()
        params = ["message":textCount,"room_id": chatRoomId]
        print(params)
        AFWrapperClass.requestPOSTURL(url, params: params, headers: headers, success: { [self](dict) in
            let result = dict as AnyObject
            print("addMessage=======>>>>>",result)
            let msg = result["message"] as? String ?? ""
            let status = result["status"] as? Int ?? 0
            if status == 1 {
                let data = result["data"] as? NSDictionary ?? NSDictionary()
                self.sendNewMessage(data: data)
                self.chatTable.beginUpdates()
                self.chatTable.endUpdates()
//                self.chatTable.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    self.scrollToBottom()
                    self.messageTextView.becomeFirstResponder()
                }
                SocketManger.shared.socket.emit("newMessage", chatRoomId, data)
                
            }
            else{
                self.Alert(message: msg)
            }
        }){ (error) in
            self.Alert(message: error.localizedDescription)
            AFWrapperClass.svprogressHudDismiss(view: self)
        }
    }
    
}


extension Date {
    func adding() -> Date {
        return Calendar.current.date(byAdding: .second, value: -1, to: self) ?? Date()
    }
    
    func getMint() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm:ss"
        let mydt = dateFormatter.string(from: self)
        return "-" + mydt
    }
}
extension UINavigationController {
    func poptoViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(vc, animated: animated)
        }
    }
}

