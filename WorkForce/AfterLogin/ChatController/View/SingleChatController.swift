//
//  SingleChatController.swift
//  meetwise
//
//  Created by hitesh on 07/10/20.
//  Copyright © 2020 hitesh. All rights reserved.
//

import UIKit
import GrowingTextView
import IQKeyboardManagerSwift


class SingleChatController: UIViewController {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextView: GrowingTextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var chatTable: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var attachButton: UIButton!
    
    var firstTimeLoadCell: Bool = true
    
    
    
    var chatHistory = [MessageData]()
//    var chatData: ChatListModel?
//    var userData: UserData? = UserDefaultsCustom.getUserData()
    var isAllReadMessage:Bool = false
//    var model = ChatAPIName()
    var typingTimer:Timer?
    var pageCompleted:Bool = false
    var updating:Bool = false
    var headerView:UIView!
    var viewModel: ChatVM?
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableHeaderView()
        self.setGrowingTextView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setTableView()
        self.setControllerData()
        self.setSocket()
        IQKeyboardManager.shared.enable = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.scrollToBottom()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setSocket() {
//        Socketton.sharedInstance.chatId = self.chatData?.chat_id ?? ""
//        Socketton.sharedInstance.establishConnection()
        
        self.isOnline()
        self.isTyping()
        self.isStopTyping()
        self.isOffline()
        self.isMessageReceived()
        self.isMessageSeen()
        
        self.setEmitSeen()
        self.setOnlineEmit()
    }
    
    func setTableView() {
        self.messageTextView.text = ""
        self.chatHistory = ChatVM.getAllMessages()
        
        
        self.chatTable.delegate = self
        self.chatTable.dataSource = self
        self.chatTable.separatorStyle = .none
        self.chatTable.showsVerticalScrollIndicator = false
        self.chatTable.register(UINib(nibName: "ChatCell", bundle: nibBundle), forCellReuseIdentifier: "ChatCell")//registerCell(identifier: cellIdentifier.chatCell)
        self.chatTable.reloadData()
    }
    
    func setControllerData() {
//        if self.chatData?.chat_type != "Solo" {
//            self.nameLabel.text = "clout"
//        } else {
//            self.nameLabel.text = "user"
//        }
    }
    
    func setGrowingTextView() {
        self.messageTextView.delegate = self
        self.messageTextView.tintColor = .black
        self.messageTextView.trimWhiteSpaceWhenEndEditing = true
        self.messageTextView.placeholder = "Type Something here...."
        self.messageTextView.placeholderColor = UIColor.lightGray
        self.messageTextView.maxHeight = 80.0
        self.messageTextView.sizeToFit()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func scrollToBottom() {
        guard self.chatHistory.count > 0 else { return }
        let section = 0
        let row = self.chatHistory.count-1
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: row, section: section)
            self.chatTable.scrollToRow(at: indexPath, at: .bottom, animated: false)
            self.chatTable.reloadData()
        }
    }
    
    func sendNewMessage(message:String, messageType: MESSAGE_TYPE) {
//        let messageData = MessageData(message: message, chatId: self.chatData?.chat_id, type: messageType)
//        self.chatHistory.append(messageData)
        let indexPath = IndexPath(row: self.chatHistory.count-1, section: 0)
        self.chatTable.beginUpdates()
        self.chatTable.insertRows(at: [indexPath], with: .bottom)
        self.chatTable.endUpdates()
        self.scrollToBottom()
//
        let json:[String:Any] = [:]
//            "sender": self.userData?._id ?? "",
//                                 "message": message,
//                                 "chat_id": self.chatData?.chat_id ?? "",
//                                 "message_type": messageType.rawValue]
        print(json)
//        Socketton.sharedInstance.sendMessage(json: json)
//        Socketton.sharedInstance.stopTypingEmit(json: self.getSocketJson())
//        self.sendButton.isSelected = false
//        self.sendButton.isEnabled = false
    }
    
    @IBAction func sendAction(_ sender: UIButton) {
//        guard IJReachability.isConnectedToNetwork() == true else {
//            Singleton.sharedInstance.showErrorMessage(error: AlertMessage.NO_INTERNET_CONNECTION, isError: .error)
//            return
//        }
        let message = messageTextView.text
        guard message?.count ?? 0 > 0 else {
            return
        }
//        if self.chatData != nil {
//            self.sendNewMessage(message: message ?? "", messageType: .text)
//        }
        self.messageTextView.text = nil
//        self.sendButton.isSelected = false
//        self.sendButton.isEnabled = false
    }
    
    //MARK: - EVENT LISTNERS
    func isOnline() {
//        Socketton.sharedInstance.isOnlineCallback = { json in
//            print("*****************   online  ********************* \n\(json)")
//            self.lastSeenLabel.text = ""//"Online..."
//        }
    }
    
    func isTyping() {
//        Socketton.sharedInstance.isTypingCallback = { json in
//            print(json)
//            self.lastSeenLabel.text = json.value(forKey: "message")
//        }
    }
    
    func isStopTyping() {
//        Socketton.sharedInstance.isTypingStopCallback = { json in
//            print("*****************   stop typing  ********************* \(json)")
//            self.lastSeenLabel.text = ""//"Online"
//        }
    }
    
    func isOffline() {
//        Socketton.sharedInstance.isOffline = { json in
//            print("*****************   offline  ********************* \(json)")
//            self.lastSeenLabel.text = "offline"
//        }
    }
    
    func isMessageSeen() {
//        Socketton.sharedInstance.isMessageSeenCallback = { json in
//            print("message seen callback \(json)")
//            guard let status = json.value(forKey: "status"), status == "Seen" else {return}
//            guard let indexPaths = self.getIndexForReload(), indexPaths.isNotEmpty else { return }
//            self.chatTable.reloadRows(at: indexPaths, with: .none)
//        }
    }
    
    func isMessageReceived() {
//        Socketton.sharedInstance.isMessageRecieved = { json in
//            print("message recieved by me ******* \(json)")
//            self.chatHistory.append(MessageData(json: json))
//            var indexPath:IndexPath = IndexPath(row: 0, section: 0)
//            if self.chatHistory.count > 0 {
//                indexPath.row =  self.chatHistory.count - 1
//            }
//            DispatchQueue.main.async {
//                self.chatTable.beginUpdates()
//                self.chatTable.insertRows(at: [indexPath], with: .bottom)
//                self.chatTable.endUpdates()
//                self.scrollToBottom()
//                self.setEmitSeen()
//            }
//        }
    }
    
    //MARK: - EVENT EMITERS
    func setEmitSeen() {
//        let json:JSON = [:]
//            "message_id": self.chatHistory.last?.message_id ?? "",
//                        "chat_id": self.chatData?.chat_id ?? "",
//                        "user_id": self.userData?._id ?? ""]
//        print("set Emit Seen is \(json)")
//        Socketton.sharedInstance.seenEmit(json: json)
    }
    
    func setTypingEmit() {
//        Socketton.sharedInstance.isTypingEmit(json: self.getSocketJson())
    }
    
    func setStopTypingEmit() {
//        Socketton.sharedInstance.stopTypingEmit(json: self.getSocketJson())
    }
    
    func setOfflineEmit() {
//        Socketton.sharedInstance.offlineEmit(json: self.getSocketJson())
    }
    
    func setOnlineEmit() {
//        Socketton.sharedInstance.onlineEmit(json: self.getSocketJson())
    }
    
    func getSocketJson() -> [String: String] {
        return [:]
//            "chat_id": self.chatData?.chat_id ?? "",
//                "sender": self.userData?._id ?? "",
//                "name": self.userData?.name ?? ""
//        ]
    }
    
    func getIndexForReload() -> [IndexPath]? {
        var indexs = [IndexPath]()
//        self.chatHistory.enumerated().forEach { message in
//            if message.element.status != "Seen" {
//                message.element.status = "Seen"
//                indexs.append(IndexPath(row: message.offset, section: 0))
//            }
//        }
        return indexs.isEmpty ? nil : indexs
    }
    
    
    
    @IBAction func infoAction(_ sender: UIButton) {
    }
    
    @IBAction func imagePickerAction(_ sender: UIButton) {
//        let type:GetImageFromPicker.PickerType = sender.tag == 0 ? .camera : .gallery
//        MediaModel.imagePicker(imagePicker: self.getImagePicker, pickerType: type, controller: self) { data in
//            DispatchQueue.main.async {
//                if let url = data?.imgUrlStr {
//                    self.sendNewMessage(message:url , messageType: .photo)
//                }
//            }
//        }
    }
    
    @IBAction func attachmentAction(_ sender: UIButton) {
        
    }
    
    
    
    @IBAction func moreAction(_ sender: UIButton) {
//        let controller = OptionsSheetController()
//        let options:[OPTION] = [.info, .mute, .report, .clearChat]
//        controller.presentSheet(options:options, nil, self) { (title, t, c) in
//            DispatchQueue.main.async {
//                print("title is \(title ?? "")")
//                self.moreOptionActions(type: title)
//            }
//        }
    }
    
    func moreOptionActions(type:String?) {
//        if type == Str.info {
//        } else {
//            guard let type = type else {return}
//            let controller = ChatPopUpViewController()
//            controller.popupType = ChatPopUpType(rawValue: type)
//            controller.chatData = self.chatData
//            controller.present(viewController: self) { type in
//                print("type is ****** \(type?.rawValue)")
//                if type?.rawValue == "Clear Chat" {
//                    self.chatHistory = []
//                    self.chatTable.reloadData()
//                }
//            }
//        }
    }
    
    func tableHeaderView() {
//        self.headerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_SIZE.width, height: 60))
        let activityIndigator = UIActivityIndicatorView(style: .gray)
//        activityIndigator.frame = CGRect(x: 0, y: 15, width: SCREEN_SIZE.width, height: 30)
        activityIndigator.startAnimating()
//        self.headerView.addSubview(activityIndigator)
           
    }
    
}

extension SingleChatController: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.hasText == true && textView.text != "" {
//            self.sendButton.isSelected = true
//            self.sendButton.isEnabled = true
        } else {
//            self.sendButton.isSelected = false
//            self.sendButton.isEnabled = false
        }
        self.editingChanged(textView)
    }
    
    func editingChanged(_ textView: UITextView) {
        if self.typingTimer != nil {
            self.typingTimer?.invalidate()
            self.typingTimer = nil
            self.setTypingEmit()
        }
        self.typingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(searchForKeyword(_:)), userInfo: textView.text!, repeats: false)
    }
    
    @objc func searchForKeyword(_ timer: Timer) {
        // retrieve the keyword from user info
        self.setStopTypingEmit()
    }
}

extension SingleChatController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.chatHistory.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 30
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        let label = UILabel()
        label.frame = CGRect.init(x: UIScreen.main.bounds.width/2, y: 5, width: 100, height: headerView.frame.height-10)
        label.center = headerView.center
        label.text = "Today"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .gray
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as? ChatCell else{return UITableViewCell()}//dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatCell
        let chatModel = self.chatHistory[indexPath.row]
        cell.delegate = self
//        let chatType = self.chatData?.chat_type
        if indexPath.row == 0 {
            cell.configure(model: chatModel, indexPath: indexPath, chatType: nil)
        } else {
            cell.configure(model: chatModel, indexPath: indexPath, previousDate: chatModel.sent_date, chatType: nil)
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard self.pageCompleted == false else {return}
        guard self.updating == false else {return}
        guard self.firstTimeLoadCell == false else {
            self.firstTimeLoadCell = false
            return}
        if indexPath.row == 0 {
            if let messageId = self.chatHistory.first?.message_id {
                self.checkHeaderAnimation(row: indexPath.row)
                self.apiOldChat(messageId: messageId)
            }
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
    
    func apiOldChat(messageId:String) {
//        var apiName = API.Name.get_chat_history
//        apiName += "?access_token=\(UserDefaultsCustom.getAccessToken())"
//        apiName += "&chat_id=\(self.chatData?.chat_id ?? "")"
//        apiName += "&message_id=\(messageId)"
//        apiName += "&page_size=10"
//        ChatListingModel.apiIndividualChat(apiName, false) { data in
//            DispatchQueue.main.async {
//                self.pageCompleted = (data?.count ?? 0) == 0
//                self.chatTable.tableHeaderView = nil
//                guard let data = data else {return}
//                self.setChatHistory(data: data)
//            }
//        }
    }
    
    func setChatHistory(data:[MessageData]) {
        guard data.count > 0 else {
            self.firstTimeLoadCell = true
            return
        }
        let reversed = data.reversed()
        self.updating = true
        for element in reversed.enumerated() {
            self.chatHistory.insert(element.element, at: 0)
        }
        DispatchQueue.main.async {
            UIView.setAnimationsEnabled(false)
            self.chatTable.reloadData()
            if data.count > 0  {
                self.chatTable.scrollToRow(at: IndexPath(row: data.count-1, section: 0), at: .top, animated: false)
            }
            UIView.setAnimationsEnabled(true)
            self.updating = false
            print("data count is \(data.count)")
        }
    }
    
    
}

extension SingleChatController: ChatCellDelegate {
    func imageAction(_ image: String?) {
        
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
        let safeArea = self.view.safeAreaInsets.bottom
        self.bottomConstraint.constant = keyboardSize.height - safeArea
        
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
