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
import Photos
import Kingfisher
import AVKit
import AVFoundation
import MobileCoreServices

enum sendMessageType {
    case chat, picture, clips, doc
}
var UpdateImageInTableView: (()->())?
var UpdatedocumentInTableView: (()->())?
var UpdateVideoInTableView: (()->())?

let SCREEN_SIZE = UIScreen.main.bounds

class SingleChatController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ImagePickerDelegate{
    func videoSelect(thumbnail: UIImage?, videoData: Data?) {
        if videoData != nil{
            self.ifSelectedVideo = "yes"
            self.ifSelectedImage = ""
            self.ifSelectedDocument = ""
            self.thumbnailimgArray.removeAll()
            self.videoArray.append((videoData)!)
            self.showImgView.image = thumbnail
            thumbnailimgArray.append((thumbnail?.pngData())!)
            UIView.animate(withDuration: 0.2){
                self.showSelectPreviewView.isHidden = false
                self.showImageHeightConstant.constant = 120
                self.showImgView.isHidden = false
                self.playBtnImgVw.isHidden = false
                self.messageTextView.isUserInteractionEnabled = false
                self.view.layoutIfNeeded()
            }
            UpdateVideoInTableView = { [self] in
                let textView = messageTextView.text.trimWhiteSpace
                let url = kBASEURL + WSMethods.sendMessagev2
                var params = [String:Any]()
                params = ["message":textView,"room_id": chatRoomId,"message_type" : "video"]
                print(params)
                self.videoRequestWith(endUrl: url , parameters: params)
            }
        }
    }
    
    func didSelect(image: UIImage?,videoData: Data?) {
        if image == nil{
            self.selectedImage = UIImage(named: "placeholder")
        }else if image != nil{
            self.ifSelectedVideo = ""
            self.ifSelectedImage = "yes"
            self.ifSelectedDocument = ""
            self.showImgView.image = image
            imgArray.append((image?.pngData())!)
            UIView.animate(withDuration: 0.2){
                self.showSelectPreviewView.isHidden = false
                self.showImageHeightConstant.constant = 120
                self.showImgView.isHidden = false
                self.playBtnImgVw.isHidden = true
                self.messageTextView.isUserInteractionEnabled = false
                self.view.layoutIfNeeded()
            }
            UpdateImageInTableView = { [self] in
                let textView = messageTextView.text.trimWhiteSpace
                let url = kBASEURL + WSMethods.sendMessagev2
                var params = [String:Any]()
                params = ["message":textView,"room_id": chatRoomId,"message_type" : "image"]
                print(params)
                self.requestWith(endUrl: url , parameters: params)
                imgss.append(image ?? UIImage())
            }
        }
    }
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextView: GrowingTextView!
    @IBOutlet weak var sendButton: LoadingButton!
    @IBOutlet weak var chatTable: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var attachBtn: UIButton!
    @IBOutlet weak var showSelectPreviewView: UIView!
    @IBOutlet weak var showImgView: UIImageView!
    @IBOutlet weak var showImageHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var playBtnImgVw: UIImageView!
    
    var firstTimeLoadCell:Bool = true
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
    var page_size: Int = 100
    var page_no: Int = 0
    var isNavFromCustomer = ""
    var imagePicker = UIImagePickerController()
    var imgArray = [Data]()
    var imgss = [UIImage]()
    var imgPicker : ImagePicker?
    var messageType: sendMessageType?
    var docArray = [Data]()
    var videoArray = [Data]()
    var thumbnailimgArray = [Data]()
    var setfileExtension = ""
    var ifSelectedImage = ""
    var ifSelectedDocument = ""
    var ifSelectedVideo = ""
    var thumbnailImage :UIImage?

    
    
    var selectedImage: UIImage? {
        didSet {
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSocket()
        self.setTableView()
        self.setGrowingTextView()
        self.setControllerData()
        self.messageTextView.isUserInteractionEnabled = true
        self.playBtnImgVw.isHidden = true
        self.imgPicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
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
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2){
            self.ifSelectedImage = ""
            self.ifSelectedDocument = ""
            self.ifSelectedVideo = ""
            self.docArray.removeAll()
            self.videoArray.removeAll()
            self.thumbnailimgArray.removeAll()
            self.showImgView.image = nil
            self.showImageHeightConstant.constant = 0
            self.showSelectPreviewView.isHidden = true
            self.messageTextView.isUserInteractionEnabled = true
            self.view.layoutIfNeeded()
        }
    }
    
    
    @IBAction func attachBtn(_ sender: UIButton) {
        self.imgArray.removeAll()
        self.videoArray.removeAll()
        self.thumbnailimgArray.removeAll()
        self.docArray.removeAll()
        let alert = UIAlertController(title: AppAlertTitle.appName.rawValue, message: "Please Select an Option".localized(), preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Media".localized(), style: .default , handler:{ (UIAlertAction)in
            self.imgPicker?.present(from: sender)
        }))
        alert.addAction(UIAlertAction(title: "Document".localized(), style: .destructive , handler:{ (UIAlertAction)in
            let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.text", kUTTypePDF  as String], in: .import)
            documentPicker.delegate = self
            self.present(documentPicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    @IBAction func sendAction(_ sender: UIButton) {
        if IJReachability.isConnectedToNetwork() == true {
            let trimmedString = messageTextView.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimmedString != ""{
                self.addMessageApi()
                messageTextView.text = ""
            }else if ifSelectedImage == "yes" && self.imgArray.count != 0{
                UIView.animate(withDuration: 0.2){
                    self.showSelectPreviewView.isHidden = true
                    self.showImgView.isHidden = true
                    self.showImageHeightConstant.constant = 0
                    self.view.layoutIfNeeded()
                }
                UpdateImageInTableView?()
            }else if ifSelectedDocument == "yes" && self.docArray.count != 0{
                UIView.animate(withDuration: 0.2){
                    self.showSelectPreviewView.isHidden = true
                    self.showImgView.isHidden = true
                    self.showImageHeightConstant.constant = 0
                    self.view.layoutIfNeeded()
                }
                UpdatedocumentInTableView?()
            }else if ifSelectedVideo == "yes" && self.videoArray.count != 0{
                UIView.animate(withDuration: 0.2){
                    self.showSelectPreviewView.isHidden = true
                    self.showImgView.isHidden = true
                    self.showImageHeightConstant.constant = 0
                    self.view.layoutIfNeeded()
                }
                UpdateVideoInTableView?()
            }
        }else{
            alert(AppAlertTitle.appName.rawValue, message: "Check internet connection".localized(), view: self)
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
                SocketManger.shared.socket.emit("ConncetedChat", self.chatRoomId)
                self.newMessageSocketOn()
            case SocketIOStatus.connecting:
                print("socket connecting")
                //                self.connectSocketOn()
                //                self.newMessageSocketOn()
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
                        self.updatedMessageSeen()
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
        self.chatTable.register(UINib(nibName: "MediaListCell", bundle: nibBundle), forCellReuseIdentifier: "MediaListCell")
        self.chatTable.register(UINib(nibName: "ImageListCell", bundle: nibBundle), forCellReuseIdentifier: "ImageListCell")
        self.chatTable.register(UINib(nibName: "leftImageListCell", bundle: nibBundle), forCellReuseIdentifier: "leftImageListCell")
        UIView.animate(withDuration: 0.2){
            self.showSelectPreviewView.isHidden = true
            self.showImgView.isHidden = true
            self.showImageHeightConstant.constant = 0
            self.view.layoutIfNeeded()
        }
        
    }
    
    func setControllerData() {
        if UserType.userTypeInstance.userLogin == .Bussiness{
            self.pushNav = true
            self.nameLabel.text = userName
            if isNavFromCustomer == "CustomerJobList"{
                self.nameLabel.text = userName
            }
        }else if UserType.userTypeInstance.userLogin == .Professional{
            self.nameLabel.text = companyname
        }else if UserType.userTypeInstance.userLogin == .Coustomer{
            self.nameLabel.text = userName
        }else{
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
    }
    
    func tableHeaderView() {
        self.headerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_SIZE.width, height: 60))
        let activityIndigator = UIActivityIndicatorView(style: .gray)
        activityIndigator.frame = CGRect(x: 0, y: 15, width: SCREEN_SIZE.width, height: 30)
        activityIndigator.startAnimating()
        self.headerView.addSubview(activityIndigator)
    }
    
}

extension SingleChatController: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
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
                    self.chatTable.tableViewScrollToBottom(animated: false)
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
        parameters["page_no"] = page_no + 1
        print(parameters)
        return parameters
    }
    
    
    //    MARK: UIIMAGE SEND IN CHAT
    func requestWith(endUrl: String, parameters: [AnyHashable : Any]){
        let url = endUrl /* your API url */
        let AToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token": AToken]
        print(headers)
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view:self)
        }
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as! String)
            }
            for i in 0..<self.imgArray.count{
                let imageData1 = self.imgArray[i]
                debugPrint("mime type is\(imageData1.mimeType)")
                let ranStr = String(7)
                if imageData1.mimeType == "application/pdf" ||
                    imageData1.mimeType == "application/vnd" ||
                    imageData1.mimeType == "text/plain"{
                    multipartFormData.append(imageData1, withName: "chat_images[\(i + 1)]" , fileName: ranStr + String(i + 1) + ".pdf", mimeType: imageData1.mimeType)
                }else{
                    multipartFormData.append(imageData1, withName: "chat_images[]" , fileName: ranStr + String(i + 1) + ".jpg", mimeType: imageData1.mimeType)
                }
            }
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: headers, interceptor: nil, fileManager: .default)
        
        .uploadProgress(closure: { (progress) in
            print("Upload Progress: \(progress.fractionCompleted)")
            
        })
        .responseJSON { [self] (response) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
            }
            print("Image succesfully uploaded\(response)")
            let respDict =  response.value as? [String : AnyObject] ?? [:]
            if respDict.count != 0{
                let status = respDict["status"] as? Int ?? 0
                let data = respDict["data"] as? [String:Any] ?? [:]
                print(status)
                if status == 1{
//                    self.setSocket()
                    self.sendNewMessage(data: data as NSDictionary)
                    SocketManger.shared.socket.emit("newMessage", chatRoomId, data)
                    self.messageTextView.isUserInteractionEnabled = true
                    self.imgArray.removeAll()
                    print("checkData of message",data)
                }else{
                    self.sendNewMessage(data: data as NSDictionary)
                }
            }
        }
    }
    
    //    MARK: VIDEO SEND IN CHAT
    func videoRequestWith(endUrl: String, parameters: [AnyHashable : Any]){
        let url = endUrl /* your API url */
        print("url is here >>> ",url)
        let AToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token": AToken]
        print(headers)
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view:self)
        }
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as! String)
            }
            multipartFormData.append(self.videoArray.first ?? Data(), withName: "chat_video" , fileName: UUID().uuidString + ".mp4", mimeType: "")
            multipartFormData.append(self.thumbnailimgArray.first!, withName: "chat_images[]", fileName: UUID().uuidString + ".png", mimeType: "")
            
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: headers, interceptor: nil, fileManager: .default)
        
        .uploadProgress(closure: { (progress) in
            print("Upload Progress: \(progress.fractionCompleted)")
            
        })
        .responseJSON { [self] (response) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
            }
            print("video Upload successfully\(response)")
            let respDict =  response.value as? [String : AnyObject] ?? [:]
            if respDict.count != 0{
                let status = respDict["status"] as? Int ?? 0
                let data = respDict["data"] as? [String:Any] ?? [:]
                print(status)
                if status == 1{
//                    self.setSocket()
                    self.sendNewMessage(data: data as NSDictionary)
                    SocketManger.shared.socket.emit("newMessage", chatRoomId, data)
                    self.messageTextView.isUserInteractionEnabled = true
                    self.videoArray.removeAll()
                    self.thumbnailimgArray.removeAll()
                }else{
                    self.sendNewMessage(data: data as NSDictionary)
                }
            }
        }
    }
    
    
    //    MARK: SEND DOC FILE IN CHAT
    func reqstWith(endUrl: String, parameters: [AnyHashable : Any]){
        let url = endUrl
        let AToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token": AToken]
        print(headers)
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view:self)
        }
        AF.upload(multipartFormData: { [self] (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as! String)
            }
            if setfileExtension == "pdf"{
                multipartFormData.append(self.docArray.first ?? Data(), withName: "chat_images[]" , fileName: UUID().uuidString + ".pdf", mimeType: self.docArray.first?.mimeType)
            }else if setfileExtension == "doc" {
                multipartFormData.append(self.docArray.first ?? Data(), withName: "chat_images[]" , fileName: UUID().uuidString + ".doc", mimeType: self.docArray.first?.mimeType)
            }
            
            
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: headers, interceptor: nil, fileManager: .default)
        .uploadProgress(closure: { (progress) in
            print("Upload Progress: \(progress.fractionCompleted)")
        }).responseJSON { [self] (response) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
            }
            print("Succesfully uploaded\(response)")
            let respDict =  response.value as? [String : AnyObject] ?? [:]
            if respDict.count != 0{
                let status = respDict["status"] as? Int ?? 0
                let data = respDict["data"] as? [String:Any] ?? [:]
                print(status)
                if status == 1{
//                    self.setSocket()
                    self.sendNewMessage(data: data as NSDictionary)
                    SocketManger.shared.socket.emit("newMessage", chatRoomId, data)
                    self.messageTextView.isUserInteractionEnabled = true
                    self.docArray.removeAll()
                }else{
                    self.sendNewMessage(data: data as NSDictionary)
                }
            }
        }
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
        let userLoginid  = UserDefaults.standard.string(forKey: "uID")
        if chatModel.user_id ?? "" == userLoginid {
            if chatModel.message_type == "chat"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "RightTableViewCell", for: indexPath) as! RightTableViewCell
                cell.setMessageData(chatModel)
                return cell
            }else if chatModel.message_type == "document"{
                let cell2 = tableView.dequeueReusableCell(withIdentifier: "ImageListCell", for: indexPath) as! ImageListCell
                cell2.setMessageData(chatModel)
                return cell2
            }else  if chatModel.message_type == "image"{
                let cell2 = tableView.dequeueReusableCell(withIdentifier: "ImageListCell", for: indexPath) as! ImageListCell
                cell2.setMessageData(chatModel)
                return cell2
            }else  if chatModel.message_type == "video"{
                let cell2 = tableView.dequeueReusableCell(withIdentifier: "ImageListCell", for: indexPath) as! ImageListCell
                cell2.setMessageData(chatModel)
                return cell2
            }
        }else {
            if chatModel.message_type == "chat"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "LeftTableViewCell", for: indexPath) as! LeftTableViewCell
                cell.setMessageData(chatModel)
                return cell
            }else if chatModel.message_type == "document"{
                let cell2 = tableView.dequeueReusableCell(withIdentifier: "leftImageListCell", for: indexPath) as! leftImageListCell
                cell2.setMessageData(chatModel)
                return cell2
            }else if chatModel.message_type == "image"{
                let cell2 = tableView.dequeueReusableCell(withIdentifier: "leftImageListCell", for: indexPath) as! leftImageListCell
                cell2.setMessageData(chatModel)
                return cell2
            }else if chatModel.message_type == "video"{
                let cell2 = tableView.dequeueReusableCell(withIdentifier: "leftImageListCell", for: indexPath) as! leftImageListCell
                cell2.setMessageData(chatModel)
                return cell2
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatModel = chatHistory[indexPath.row]
        if ((chatModel.chat_image!.contains(".jpg") || chatModel.chat_image!.contains(".png")) && chatModel.chat_video == "" ){
            let vc = showImageView()
            vc.setImage = chatModel.chat_image ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }else if (chatModel.chat_video!.contains("") && chatModel.chat_image!.contains(".png")){
            let vc = showImageView()
            vc.setImage = chatModel.chat_image ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }else if chatModel.chat_image!.contains(".pdf"){
            if let url = URL(string: chatModel.chat_image ?? "".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }else if chatModel.chat_image!.contains(".doc") {
            if let url = URL(string: chatModel.chat_image ?? "".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }else if (chatModel.chat_video != "" && (chatModel.chat_image!.contains(".png") || (chatModel.chat_image!.contains(".jpg")))){
            let videoURL = URL(string: "\(chatModel.chat_video ?? "")")
            let player = AVPlayer(url: videoURL!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let chatModel = chatHistory[indexPath.row]
        if chatModel.message_type != "chat" {
            return 200
        }else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let chatModel = chatHistory[indexPath.row]
        if chatModel.message_type != "chat" {
            return 200
        }else {
            return UITableView.automaticDimension
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
    func addMessageApi(){
        let textCount = messageTextView.text.trimWhiteSpace
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let url = kBASEURL + WSMethods.sendMessagev2
        var params = [String:Any]()
        params = ["message":textCount,"room_id": chatRoomId,"message_type":"chat"]
        print(params)
        AFWrapperClass.requestPostWithMultiFormData(url, params: params, headers: headers, success: { [self](dict) in
            let result = dict as AnyObject
            let msg = result["message"] as? String ?? ""
            let status = result["status"] as? Int ?? 0
            if status == 1{
                let data = result["data"] as? NSDictionary ?? NSDictionary()
                self.sendNewMessage(data: data)
                self.chatTable.beginUpdates()
                self.chatTable.endUpdates()
                SocketManger.shared.socket.emit("newMessage", chatRoomId, data)
            }else{
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

extension SingleChatController: UIDocumentPickerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let cico = url as URL
        let data = NSData(contentsOf: cico)
        self.ifSelectedVideo = ""
        self.ifSelectedImage = ""
        self.ifSelectedDocument = "yes"
        self.docArray.removeAll()
        self.docArray.append((data as? Data)!)
        UIView.animate(withDuration: 0.2){
            self.showImgView.image = UIImage(named: "ic_ph_document")
            self.showSelectPreviewView.isHidden = false
            self.showImageHeightConstant.constant = 120
            self.showImgView.isHidden = false
            self.playBtnImgVw.isHidden = true
            self.messageTextView.isUserInteractionEnabled = false
            self.view.layoutIfNeeded()
        }
        UpdatedocumentInTableView = { [self] in
            let baseUrl = kBASEURL + WSMethods.sendMessagev2
            var params = [String:Any]()
            let textView = messageTextView.text.trimWhiteSpace
            params = ["message":textView,"room_id": chatRoomId,"message_type":"document"]
            print("printHereis ",params)
            
            if let documentsPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                print("documentsPathURL",documentsPathURL)
                self.setfileExtension = url.pathExtension
            }
            self.reqstWith(endUrl: baseUrl , parameters: params)
        }
    }
}

extension UIImage {
    func setCacheAt(url: String) {
        KingfisherManager.shared.cache.store(self, forKey: url)
    }
}
