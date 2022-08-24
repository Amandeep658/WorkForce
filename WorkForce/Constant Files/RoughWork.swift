//
//  RoughWork.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 11/07/22.
//

import Foundation

////    MARK: MAPVIEW DELEGATE
////    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
////        guard status == .authorizedWhenInUse else {
////            return
////        }
////        self.locationManager.startUpdatingLocation()
////        self.MapView.isMyLocationEnabled = true
////    }
//func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//    CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
//        if (error != nil) {
//            print("Reverse geocoder failed with error" + error!.localizedDescription)
//            return
//        }
////            guard let location = locations.first else {
////                return
////            }
////            self.MapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
////            self.locationManager.stopUpdatingLocation()
//
//        if placemarks!.count > 0 {
//            let pm = placemarks![0] as CLPlacemark
//            self.displayLocationInfo(placemark: pm)
//        } else {
//            print("Problem with the data received from geocoder")
//        }
//    })
//}
//
//func displayLocationInfo(placemark: CLPlacemark?) {
//    if let containsPlacemark = placemark {
//        let cLocation = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
//        self.nearByLocation = cLocation ?? ""
//        self.nearByWorkerList()
//    }
//}




//                self.nearByWorkerArr.forEach({ trucks in
//                    print("here is long",trucks.longitude)
//                    print("here is lat",trucks.latitude)
//                    state_marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(trucks.latitude ?? "0.0") ?? 0.0, longitude: CLLocationDegrees(trucks.longitude ?? "0.0") ?? 0.0)
//                    state_marker.icon = self.iconImg
//                    state_marker.title = trucks.username ?? ""
//                    let imgUrl = URL(string: trucks.photo ?? "")
//                    self.applyImage(from: imgUrl ?? URL(fileURLWithPath: ""), to: state_marker)
//                    state_marker.map = self.googleMap
//                })












//
//  SingleChatController.swift
//  meetwise
//
//  Created by hitesh on 07/10/20.
//  Copyright © 2020 hitesh. All rights reserved.
//
//
//import UIKit
//import GrowingTextView
//import IQKeyboardManagerSwift
//import Alamofire
//import SDWebImage
//import SocketIO
//
//class SingleChatController: UIViewController {
//
//    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
//    @IBOutlet weak var messageTextView: GrowingTextView!
//    @IBOutlet weak var sendButton: UIButton!
//    @IBOutlet weak var chatTable: UITableView!
//    @IBOutlet weak var nameLabel: UILabel!
//
//    var firstTimeLoadCell: Bool = true
//
//
//    var chatHistory = [MessageData]()
////    var chatData: ChatListModel?
////    var userData: UserData? = UserDefaultsCustom.getUserData()
//    var isAllReadMessage:Bool = false
////    var model = ChatAPIName()
//    var typingTimer:Timer?
//    var pageCompleted:Bool = false
//    var updating:Bool = false
//    var headerView:UIView!
//    var viewModel: ChatVM?
//    var chatRoomId = ""
//
//
//    init() {
//        super.init(nibName: nil, bundle: nil)
//        self.hidesBottomBarWhenPushed = true
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.tableHeaderView()
//        self.setGrowingTextView()
//        print("here is chat room ID ======>>>",chatRoomId)
//
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        self.setTableView()
//        self.setControllerData()
//        self.setSocket()
//        IQKeyboardManager.shared.enable = false
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        self.scrollToBottom()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        IQKeyboardManager.shared.enable = true
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    func setSocket() {
//        self.isOnline()
//        self.isTyping()
//        self.isStopTyping()
//        self.isOffline()
//        self.isMessageReceived()
//        self.isMessageSeen()
//
//        self.setEmitSeen()
//        self.setOnlineEmit()
//    }
//
//    func setTableView() {
//        self.messageTextView.text = ""
////        self.chatHistory = ChatVM.getAllMessages()
//
//
//        self.chatTable.delegate = self
//        self.chatTable.dataSource = self
//        self.chatTable.separatorStyle = .none
//        self.chatTable.showsVerticalScrollIndicator = false
//        self.chatTable.register(UINib(nibName: "ChatCell", bundle: nibBundle), forCellReuseIdentifier: "ChatCell")//registerCell(identifier: cellIdentifier.chatCell)
//        self.chatTable.reloadData()
//    }
//
//    func setControllerData() {
////        if self.chatData?.chat_type != "Solo" {
////            self.nameLabel.text = "clout"
////        } else {
////            self.nameLabel.text = "user"
////        }
//    }
//
//    func setGrowingTextView() {
//        self.messageTextView.delegate = self
//        self.messageTextView.tintColor = .black
//        self.messageTextView.trimWhiteSpaceWhenEndEditing = true
////        self.messageTextView.placeholder = "Type Something here...."
//        self.messageTextView.placeholderColor = UIColor.lightGray
//        self.messageTextView.maxHeight = 80.0
//        self.messageTextView.sizeToFit()
//    }
//
//    @IBAction func backAction(_ sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)
//    }
//
//    func scrollToBottom() {
//        guard self.chatHistory.count > 0 else { return }
//        let section = 0
//        let row = self.chatHistory.count-1
//        DispatchQueue.main.async {
//            let indexPath = IndexPath(row: row, section: section)
//            self.chatTable.scrollToRow(at: indexPath, at: .bottom, animated: false)
//            self.chatTable.reloadData()
//        }
//    }
//
//    func sendNewMessage(message:String) {
////        let messageData = MessageData(message: message, chatId: self.chatData?.chat_id)
////        self.chatHistory.append(messageData)
//        let indexPath = IndexPath(row: self.chatHistory.count-1, section: 0)
//        self.chatTable.beginUpdates()
//        self.chatTable.insertRows(at: [indexPath], with: .bottom)
//        self.chatTable.endUpdates()
//        self.scrollToBottom()
////
//        let json:[String:Any] = [:]
////            "sender": self.userData?._id ?? "",
////                                 "message": message,
////                                 "chat_id": self.chatData?.chat_id ?? "",
////                                 "message_type": messageType.rawValue]
//        print(json)
////        Socketton.sharedInstance.sendMessage(json: json)
////        Socketton.sharedInstance.stopTypingEmit(json: self.getSocketJson())
//        self.sendButton.isSelected = false
//        self.sendButton.isEnabled = false
//    }
//
//    @IBAction func sendAction(_ sender: UIButton) {
////        guard IJReachability.isConnectedToNetwork() == true else {
////            Singleton.sharedInstance.showErrorMessage(error: AlertMessage.NO_INTERNET_CONNECTION, isError: .error)
////            return
////        }
//        let message = messageTextView.text
//        guard message?.count ?? 0 > 0 else {
//            return
//        }
////        if self.chatData != nil {
////            self.sendNewMessage(message: message ?? "", messageType: .text)
////        }
//        self.messageTextView.text = nil
////        self.sendButton.isSelected = false
////        self.sendButton.isEnabled = false
//    }
//
//    //MARK: - EVENT LISTNERS
//    func isOnline() {
////        Socketton.sharedInstance.isOnlineCallback = { json in
////            print("*****************   online  ********************* \n\(json)")
////            self.lastSeenLabel.text = ""//"Online..."
////        }
//    }
//
//    func isTyping() {
////        Socketton.sharedInstance.isTypingCallback = { json in
////            print(json)
////            self.lastSeenLabel.text = json.value(forKey: "message")
////        }
//    }
//
//    func isStopTyping() {
////        Socketton.sharedInstance.isTypingStopCallback = { json in
////            print("*****************   stop typing  ********************* \(json)")
////            self.lastSeenLabel.text = ""//"Online"
////        }
//    }
//
//    func isOffline() {
////        Socketton.sharedInstance.isOffline = { json in
////            print("*****************   offline  ********************* \(json)")
////            self.lastSeenLabel.text = "offline"
////        }
//    }
//
//    func isMessageSeen() {
////        Socketton.sharedInstance.isMessageSeenCallback = { json in
////            print("message seen callback \(json)")
////            guard let status = json.value(forKey: "status"), status == "Seen" else {return}
////            guard let indexPaths = self.getIndexForReload(), indexPaths.isNotEmpty else { return }
////            self.chatTable.reloadRows(at: indexPaths, with: .none)
////        }
//    }
//
//    func isMessageReceived() {
////        Socketton.sharedInstance.isMessageRecieved = { json in
////            print("message recieved by me ******* \(json)")
////            self.chatHistory.append(MessageData(json: json))
////            var indexPath:IndexPath = IndexPath(row: 0, section: 0)
////            if self.chatHistory.count > 0 {
////                indexPath.row =  self.chatHistory.count - 1
////            }
////            DispatchQueue.main.async {
////                self.chatTable.beginUpdates()
////                self.chatTable.insertRows(at: [indexPath], with: .bottom)
////                self.chatTable.endUpdates()
////                self.scrollToBottom()
////                self.setEmitSeen()
////            }
////        }
//    }
//
//    //MARK: - EVENT EMITERS
//    func setEmitSeen() {
////        let json:JSON = [:]
////            "message_id": self.chatHistory.last?.message_id ?? "",
////                        "chat_id": self.chatData?.chat_id ?? "",
////                        "user_id": self.userData?._id ?? ""]
////        print("set Emit Seen is \(json)")
////        Socketton.sharedInstance.seenEmit(json: json)
//    }
//
//    func setTypingEmit() {
////        Socketton.sharedInstance.isTypingEmit(json: self.getSocketJson())
//    }
//
//    func setStopTypingEmit() {
////        Socketton.sharedInstance.stopTypingEmit(json: self.getSocketJson())
//    }
//
//    func setOfflineEmit() {
////        Socketton.sharedInstance.offlineEmit(json: self.getSocketJson())
//    }
//
//    func setOnlineEmit() {
////        Socketton.sharedInstance.onlineEmit(json: self.getSocketJson())
//    }
//
//    func getSocketJson() -> [String: String] {
//        return [:]
////            "chat_id": self.chatData?.chat_id ?? "",
////                "sender": self.userData?._id ?? "",
////                "name": self.userData?.name ?? ""
////        ]
//    }
//
//    func getIndexForReload() -> [IndexPath]? {
//        var indexs = [IndexPath]()
////        self.chatHistory.enumerated().forEach { message in
////            if message.element.status != "Seen" {
////                message.element.status = "Seen"
////                indexs.append(IndexPath(row: message.offset, section: 0))
////            }
////        }
//        return indexs.isEmpty ? nil : indexs
//    }
//
//
//    func tableHeaderView() {
////        self.headerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_SIZE.width, height: 60))
//        let activityIndigator = UIActivityIndicatorView(style: .gray)
////        activityIndigator.frame = CGRect(x: 0, y: 15, width: SCREEN_SIZE.width, height: 30)
//        activityIndigator.startAnimating()
////        self.headerView.addSubview(activityIndigator)
//
//    }
//
//}
//
//extension SingleChatController: GrowingTextViewDelegate {
//    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
//        UIView.animate(withDuration: 0.2) {
//            self.view.layoutIfNeeded()
//        }
//    }
//
//    func textViewDidChange(_ textView: UITextView) {
//        if textView.hasText == true && textView.text != "" {
////            self.sendButton.isSelected = true
////            self.sendButton.isEnabled = true
//        } else {
////            self.sendButton.isSelected = false
////            self.sendButton.isEnabled = false
//        }
//        self.editingChanged(textView)
//    }
//
//    func editingChanged(_ textView: UITextView) {
//        if self.typingTimer != nil {
//            self.typingTimer?.invalidate()
//            self.typingTimer = nil
//            self.setTypingEmit()
//        }
//        self.typingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(searchForKeyword(_:)), userInfo: textView.text!, repeats: false)
//    }
//
//    @objc func searchForKeyword(_ timer: Timer) {
//        // retrieve the keyword from user info
//        self.setStopTypingEmit()
//    }
//}
//
//extension SingleChatController: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        self.chatHistory.count
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//     return 30
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
//        let label = UILabel()
//        label.frame = CGRect.init(x: UIScreen.main.bounds.width/2, y: 5, width: 60, height: headerView.frame.height-10)
//        label.center = headerView.center
//        label.text = "Today"
//        label.font = .systemFont(ofSize: 12)
//        label.textColor = .black
//        label.textAlignment = .center
//        label.backgroundColor = .lightGray
//        label.layer.cornerRadius = 10
//        label.clipsToBounds = true
//        headerView.addSubview(label)
//        return headerView
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as? ChatCell else{return UITableViewCell()}
//        //dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatCell
//        let chatModel = self.chatHistory[indexPath.row]
//        cell.delegate = self
////        let chatType = self.chatData?.chat_type
//        if indexPath.row == 0 {
//            cell.configure(model: chatModel, indexPath: indexPath, chatType: nil)
//        } else {
//            cell.configure(model: chatModel, indexPath: indexPath, previousDate: chatModel.sent_date, chatType: nil)
//        }
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        guard self.pageCompleted == false else {return}
//        guard self.updating == false else {return}
//        guard self.firstTimeLoadCell == false else {
//            self.firstTimeLoadCell = false
//            return}
//        if indexPath.row == 0 {
//            if let messageId = self.chatHistory.first?.message_id {
//                self.checkHeaderAnimation(row: indexPath.row)
//                self.apiOldChat(messageId: messageId)
//            }
//        }
//    }
//
//    func checkHeaderAnimation(row: Int) {
//        guard self.pageCompleted == false else {return}
//        if row == 0 {
//            self.chatTable.tableHeaderView = self.headerView
//        } else {
//            self.chatTable.tableHeaderView = nil
//        }
//    }
//
//    func apiOldChat(messageId:String) {
////        var apiName = API.Name.get_chat_history
////        apiName += "?access_token=\(UserDefaultsCustom.getAccessToken())"
////        apiName += "&chat_id=\(self.chatData?.chat_id ?? "")"
////        apiName += "&message_id=\(messageId)"
////        apiName += "&page_size=10"
////        ChatListingModel.apiIndividualChat(apiName, false) { data in
////            DispatchQueue.main.async {
////                self.pageCompleted = (data?.count ?? 0) == 0
////                self.chatTable.tableHeaderView = nil
////                guard let data = data else {return}
////                self.setChatHistory(data: data)
////            }
////        }
//    }
//
//    func setChatHistory(data:[MessageData]) {
//        guard data.count > 0 else {
//            self.firstTimeLoadCell = true
//            return
//        }
//        let reversed = data.reversed()
//        self.updating = true
//        for element in reversed.enumerated() {
//            self.chatHistory.insert(element.element, at: 0)
//        }
//        DispatchQueue.main.async {
//            UIView.setAnimationsEnabled(false)
//            self.chatTable.reloadData()
//            if data.count > 0  {
//                self.chatTable.scrollToRow(at: IndexPath(row: data.count-1, section: 0), at: .top, animated: false)
//            }
//            UIView.setAnimationsEnabled(true)
//            self.updating = false
//            print("data count is \(data.count)")
//        }
//    }
//
//
//}
//
//extension SingleChatController: ChatCellDelegate {
//    func imageAction(_ image: String?) {
//
//    }
//}
//
//extension SingleChatController {
//    //MARK: Keyboard Functions
//    @objc func keyboardWillShow(_ notification : Foundation.Notification) {
//        let value: NSValue = (notification as NSNotification).userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
//        var duration = 0.3
//        var animation = UIView.AnimationOptions.curveLinear
//        if let value  = (notification as NSNotification).userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
//            duration = value
//        }
//        if let value = (notification as NSNotification).userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
//            animation = UIView.AnimationOptions(rawValue: value)
//        }
//        let keyboardSize = value.cgRectValue.size
//        let safeArea = self.view.safeAreaInsets.bottom
//        self.bottomConstraint.constant = keyboardSize.height - safeArea
//
//        self.view.setNeedsUpdateConstraints()
//        UIView.animate(withDuration: duration, delay: 0.0, options: animation, animations: { () -> Void in
//            self.view.layoutIfNeeded()
//        }, completion: {finished in
//            self.scrollToBottom()
//        })
//    }
//
//    @objc func keyboardWillHide(_ notification: Foundation.Notification) {
//        var duration = 0.3
//        var animation = UIView.AnimationOptions.curveLinear
//        if let value  = (notification as NSNotification).userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
//            duration = value
//        }
//        if let value = (notification as NSNotification).userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
//            animation = UIView.AnimationOptions(rawValue: value)
//        }
//        self.bottomConstraint.constant = 0
//        self.view.setNeedsUpdateConstraints()
//        UIView.animate(withDuration: duration, delay: 0.0, options: animation, animations: { () -> Void in
//            self.view.layoutIfNeeded()
//        }, completion: { finished in
//            DispatchQueue.main.async {
//                self.scrollToBottom()
//            }
//        })
//    }
//}



//    MARK: VERIFY RECIPT
//    func verifyPurchase(product: String){
//        AFWrapperClass.svprogressHudShow(title: "", view: self)
//        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: sharedSecret)
//        SwiftyStoreKit.verifyReceipt(using: appleValidator) { [self] result in
//            AFWrapperClass.svprogressHudShow(title: "", view: self)
//            switch result {
//            case .success(let receipt):
//                let productId = product
//                let purchaseResult = SwiftyStoreKit.verifySubscription(
//                    ofType: .autoRenewable,
//                    productId: productId,
//                    inReceipt: receipt)
//                switch purchaseResult {
//                case .purchased(let expiryDate, let items):
//                    print("\(productId) is valid until \(expiryDate)\n\(items)\n")
//                    let timeStamp = (items[0].subscriptionExpirationDate)!.timeIntervalSince1970
//                    print(timeStamp)
//                    let fdate = Date(timeIntervalSince1970: timeStamp)
//                    let formatter = DateFormatter()
//                    formatter.dateFormat = "dd-MM-YYYY"
//                    formatter.timeZone = .current
//                    let expiryString = formatter.string(from: fdate)
//                    print("Purchased Already will expire on \(expiryString)", items[0].transactionId)
//                    self.expire_date = expiryString
//                    let toDate = expiryDate
//                    let fromDate = Calendar.current.date(byAdding: .month, value: -1, to: toDate)
//                    let todayDate = Date()
//                    let formatter1 = DateFormatter()
//                    formatter1.dateFormat = "dd-MM-YYYY"
//                    formatter1.timeZone = .current
//                    let expiryString1 = formatter1.string(from: todayDate)
//                    PurchaseHelper.shared.setPurchaseDefaults(transactionDate: fromDate!, expiryDate: toDate, productId: productId)
//                    self.subscribe(plan_id: "1", product_id: productId, plan_duration: "30", user_id: UserDefaults.standard.string(forKey: "uid")!, plan_price: price, expire_date: "\(toDate)", type: "1", isfree: "0", subscription_id: paySubscriptionID, purchase_plan: "Monthly")
//                    break
//                case .expired(let expiryDate, let items):
//                    let formatter = DateFormatter()
//                    formatter.dateFormat = "dd-MM-YYYY"
//                    formatter.timeZone = .current
//                    let expiryString = formatter.string(from: expiryDate)
//                    print("\(productId) is expired since \(expiryString)\n\(items)\n")
//                case .notPurchased:
//                    print("The user has never purchased \(productId)")
//                }
//            case .error(let error):
//                alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
//            }
//        }
//    }
    
//else if (dobTF.text?.trimWhiteSpace.isEmpty)! {
//    showAlertMessage(title: AppAlertTitle.appName.rawValue, message: "Please enter date of birth." , okButton: "Ok", controller: self) {
//    }
//}
    
    //MARK:- Private
    //    fileprivate func log <T> (_ object: T) {
    //        if isLogEnabled {
    //            NSLog("\(object)")
    //        }
    //    }
    //
    //
    //    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    //
    //    func purchase(product: SKProduct, complition: @escaping ((PKIAPHandlerAlertType, SKProduct?, SKPaymentTransaction?)->Void)) {
    //
    //        self.purchaseProductComplition = complition
    //        self.mySubscriptionDetail = product
    //
    //        if self.canMakePurchases() {
    //            let payment = SKPayment(product: product)
    //            SKPaymentQueue.default().add(self)
    //            SKPaymentQueue.default().add(payment)
    //
    //            log("PRODUCT TO PURCHASE: \(product.productIdentifier)")
    //            productID = product.productIdentifier
    //            print("productID======>>>",productID)
    //        }
    //        else {
    //            complition(PKIAPHandlerAlertType.disabled, nil, nil)
    //        }
    //    }
    //
    //    func subscription(){
    //        if self.mySubscriptionDetail == nil{
    //            return
    //        }
    //        AFWrapperClass.svprogressHudShow(title: "Subscription", view: self)
    //        PKIAPHandler.shared.purchase(product: self.mySubscriptionDetail!) { [self] (alert, product, transaction) in
    //            AFWrapperClass.svprogressHudDismiss(view: self)
    //            if alert == .purchased{
    //                self.purchasePlan()
    //            }
    //        }
    //    }
    //
    //        //    MARK: PURCHASE PLAN VALIDATE RECEIPT
    //
    //    func purchasePlan(){
    //        validateReceipt(url: "https://sandbox.itunes.apple.com/verifyReceipt", complete: { (response) in
    //            DispatchQueue.main.async {
    //                AFWrapperClass.svprogressHudDismiss(view: self)
    //            }
    //            if let dict = response{
    //                print(dict)
    //                self.subscriptionApi(removepopUp:false, subscriptioinDict: dict)
    //            }
    //        })
    //    }
    //
    //
    
    //    func subscriptionApi(removepopUp:Bool,subscriptioinDict:[String:Any]){
    //        AFWrapperClass.svprogressHudShow(title: "Loading", view: self)
    //        self.subscriptionData(params:prm(subscriptioinDict:subscriptioinDict)) { dict in
    //            AFWrapperClass.svprogressHudDismiss(view: self)
    //            let status = dict["status"] as? Int ?? 0
    //            let message = dict["message"] as? String ?? ""
    //            if status == 1{
    //                self.checkPlan(removepopUp: removepopUp)
    //            }else{
    //                self.Alert(message: message)
    //            }
    //        } onFailure: { err in
    //            AFWrapperClass.svprogressHudDismiss(view: self)
    //            self.Alert(message: err.localizedDescription)
    //        }
    //    }
    
    
//        func validateReceipt(url:String,complete: @escaping ([String:Any]?) -> Void){
//            //         For testing
//            let urlString = "https://sandbox.itunes.apple.com/verifyReceipt"
//            //        for produc
//            //                let urlString = "https://buy.itunes.apple.com/verifyReceipt"
//
//
//            guard let receiptURL = Bundle.main.appStoreReceiptURL, let receiptString = try? Data(contentsOf: receiptURL).base64EncodedString() , let url = URL(string: url) else {
//                complete(nil)
//                return
//            }
//
//            let requestData : [String : Any] = ["receipt-data" : receiptString,
//                                                "password" : "56601700df564c98b7049fa7f4518d5c",
//                                                "exclude-old-transactions" : false]
//            let httpBody = try? JSONSerialization.data(withJSONObject: requestData, options: [])
//
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
//            request.httpBody = httpBody
//            URLSession.shared.dataTask(with: request)  { (data, response, error) in
//                DispatchQueue.main.async {
//                    if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]{
//                        print(jsonData)
//                        if jsonData["status"] as! Int == 21007{
//                            self.validateReceipt(url: "https://sandbox.itunes.apple.com/verifyReceipt") {(response) in
//                                print("Print Response=====>>>>",response)
//                                complete(response)
//                            }
//                        } else if jsonData["status"] as! Int == 21003{
//                            print("Its status 21003")
//                        }
//                        else{
//                            if let latestReceipt = jsonData["latest_receipt_info"] as? [[String:Any]]{
//                                if latestReceipt.count > 0{
//                                    complete(latestReceipt.first)
//                                }
//                                else{
//                                    complete(nil)
//                                }
//                            }
//                            else{
//                                complete(nil)
//                            }
//
//                        }
//                    }
//                    else{
//                        complete(nil)
//                    }
//                }
//            }.resume()
//        }
    
    //    func checkPlan(removepopUp:Bool){
    //        self.checkPlanData(params:[RequestM.Parameters.user_id:UserDefaults.standard.string(forKey:"BusinessUserID")]) { dict in
    //            let status = dict["status"] as? Int ?? 0
    //            let data = dict["data"] as? NSDictionary ?? NSDictionary()
    //            let message = dict["message"] as? String ?? ""
    //            if status == 1{
    //                let plan_id = data["plan_id"] as? String ?? ""
    //                let isSubscribed = data["isSubscribed"] as? String ?? ""
    //                self.saveDefauls(plan_id: plan_id, isSubscribed: isSubscribed)
    //                self.popActionAlert(title: AppAlertTitle.appName.rawValue, message: "Plan purchased successfully", actionTitle: ["OK"], actionStyle: [.default], action: [
    //                    { [self] ok in
    //                        if self.fromEdit{
    //                            if removepopUp{
    //                            }else{
    //                               print("its test 23")
    //                            }
    //                        }else{
    //                            print("its test 22")
    //                            self.popVC()
    //                        }
    //                    }])
    //            }else{
    //                self.removeDefaults()
    //                self.Alert(message: message)
    //            }
    //        } onFailure: { err in
    //            AFWrapperClass.svprogressHudDismiss(view: self)
    //        }
    //    }
    
    
    
    
    //    //    MARK: SUBSCRIPTION API
    //    func hitSubscriptionApi(){
    //        DispatchQueue.main.async {
    //            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
    //        }
    //        let authToken  = AppDefaults.token ?? ""
    //        let headers: HTTPHeaders = ["Token":authToken]
    //        print(headers,"headers")
    //        AFWrapperClass.requestPOSTURL(kBASEURL +  WSMethods.addSubscription, params: subscriptionParmas() , headers: headers) { [self] response in
    //            AFWrapperClass.svprogressHudDismiss(view: self)
    //            print(response)
    //            do {
    //                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
    //                let reqJSONStr = String(data: jsonData, encoding: .utf8)
    //                let data = reqJSONStr?.data(using: .utf8)
    //                let jsonDecoder = JSONDecoder()
    //                let aContact = try jsonDecoder.decode(SubscriptionModel.self, from: data!)
    //                let status = aContact.status ??  0
    //                let message = aContact.message ?? ""
    //                if status == 1{
    //                    self.popVC()
    //                }else if status == 401{
    //                    UserDefaults.standard.removeObject(forKey: "authToken")
    //                    appDel.checkLogin()
    //                }else{
    //                    alert(AppAlertTitle.appName.rawValue, message: message, view: self)
    //                }
    //            }
    //            catch let parseError {
    //                print("JSON Error \(parseError.localizedDescription)")
    //            }
    //
    //        } failure: { error in
    //            AFWrapperClass.svprogressHudDismiss(view: self)
    //            alert(AppAlertTitle.appName.rawValue, message: "", view: self)
    //        }
    //
    //    }
    //
    //    //    MARK: PARAMS
    //    func subscriptionParmas() -> [String:Any] {
    //        var parameters : [String:Any] = [:]
    //        parameters["plan_id"] = "1"
    //        parameters["user_id"] = UserDefaults.standard.string(forKey:"BusinessUserID")
    //        parameters["plan_price"] = price
    //        parameters["expire_date"] = ""
    //        parameters["plan_duration"] = "monthly"
    //        parameters["product_id"] = productID
    //        parameters["subscription_id"] = subscriptionID
    //        parameters["type"] = "1"
    //        parameters["isfree"] = "0"
    //        parameters["deviceType"] = "1"
    //        parameters["deviceToken"] = AppDefaults.deviceToken
    //        print(parameters)
    //        return parameters
    //    }
    
    
    //        MARK: ADD SUBSCRIPTION
    //    public func subscriptionData(params:[String:Any],onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (Error) -> Void) {
    //        let url = kBASEURL + WSMethods.addSubscription
    //        AFWrapperClass.requestPOSTUrl(url, params: params, success: { (dict) in
    //            let result = dict as AnyObject
    //            print("aa raha hai data",result)
    //            if let json = result as? NSDictionary{
    //                success(json as NSDictionary)
    //            }
    //        }) {(error) in
    //            failure(error)
    //        }
    //    }
    //    MARK: CHECK SUBSCRIPTION
    //    public func checkPlanData(params:[String:Any],onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (Error) -> Void) {
    //        let url = kBASEURL + WSMethods.subscriptionstatus
    //        AFWrapperClass.requestPOSTUrl(url, params: params, success: { (dict) in
    //            let result = dict as AnyObject
    //            print(result)
    //            if let json = result as? NSDictionary{
    //                success(json as NSDictionary)
    //            }
    //        }) {(error) in
    //            failure(error)
    //        }
    //    }
    
