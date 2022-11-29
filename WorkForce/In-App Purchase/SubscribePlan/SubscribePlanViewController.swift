//
//  SubscribePlanViewController.swift
//  WorkForce
//
//  Created by Dharmani Apps on 13/05/22.
//

import UIKit
import Alamofire
import StoreKit
import SwiftyStoreKit

enum IAPProduct: String{
    case FiftyDollarsixMonth = "U2CONNECT_HANDLER"
    case TwentyDollarsixMonth = "U2CONNECTIOS_HANDLER"
}

class SubscribePlanViewController: UIViewController{
    
    @IBOutlet weak var subscribeBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var termsAndCondition: UIButton!
    @IBOutlet weak var amountTextLabel: UILabel!
    
    var navType = ""
    var jobLtData = [AddJobData]()
    var workerID = ""
    var mySubscriptionDetail: SKProduct?
    var SKProductArray = [SKProduct]()
    var receiptItem:ReceiptItem?
    var subsCriptionIndex = Int()
    var paySubscriptionID = ""
    var productID = ""
    var price = ""
    var purchasePlanDate = ""
    var fromEdit = false
    var isLogEnabled: Bool = true
    private var hasAddObserver = false
    var planString = ""
    var fromSettings = false
    var expire_date = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Aa reha nav type ===>>>>",navType)
        reteriveProductPlans()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        if UserType.userTypeInstance.userLogin == .Bussiness{
            validate(product: IAPProduct.FiftyDollarsixMonth.rawValue)
//            self.amountTextLabel.text = "\("$50.00/Six Month".localized()),\("Cancel anytime, after six month".localized())"

        }
        else{
            validate(product: IAPProduct.TwentyDollarsixMonth.rawValue)
//            self.amountTextLabel.text = "\("$20.00/Six Month".localized()),\("Cancel anytime, after six month".localized())"
        }
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func restoreBtn(_ sender: UIButton) {
        restorePurchases()
    }
    
    @IBAction func privacyBtn(_ sender: UIButton) {
        let vc = PrivacyPolicyVC()
        self.pushViewController(vc, true)
    }
    
    @IBAction func termsAndConditionBtn(_ sender: UIButton) {
        let vc = TermsConditionVC()
        self.pushViewController(vc, true)
    }
    
    @IBAction func subcribeAction(_ sender: UIButton) {
        if navType == "chat" || navType == "company"{
            print("1")
            if UserType.userTypeInstance.userLogin == .Bussiness{
                print("this state ======= >>>>> one")
                self.purchaseProduct(product: IAPProduct.FiftyDollarsixMonth.rawValue)
                self.planString = "$50/Six Month"
            }else {
                self.purchaseProduct(product: IAPProduct.TwentyDollarsixMonth.rawValue)
                self.planString = "$20/Six Month"
            }
        }
        else if navType == "2" || navType == "BusinessDesigner"{
            if UserType.userTypeInstance.userLogin == .Bussiness{
                self.purchaseProduct(product: IAPProduct.FiftyDollarsixMonth.rawValue)
                self.planString = "$50/Six Month"
            }else {
                self.purchaseProduct(product: IAPProduct.TwentyDollarsixMonth.rawValue)
                self.planString = "$20/Six Month"
            }

        }
        else if navType == "Professional Design"{
            print("3")
            if UserType.userTypeInstance.userLogin == .Bussiness{
                self.purchaseProduct(product: IAPProduct.FiftyDollarsixMonth.rawValue)
                self.planString = "$50/Six Month"
            }else{
                print("ITS NAV TYPE ====>>>> Professional Design")
            }
        }
        else{
            print("4")
            if UserType.userTypeInstance.userLogin == .Bussiness{
                print("this state ======= >>>>> two")
                self.purchaseProduct(product: IAPProduct.FiftyDollarsixMonth.rawValue)
                self.planString = "$50/Six Month"
            }else {
                self.purchaseProduct(product: IAPProduct.TwentyDollarsixMonth.rawValue)
                self.planString = "$20/Six Month"
            }
        }
    }
    
    //    MARK: RESTORE PURCHASE
    func restorePurchases() {
        AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        SwiftyStoreKit.restorePurchases(atomically: true) { [self] results in
            AFWrapperClass.svprogressHudDismiss(view: self)
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                let filteredSubIds = results.restoredPurchases.filter({$0.productId == IAPProduct.FiftyDollarsixMonth.rawValue || $0.productId == IAPProduct.TwentyDollarsixMonth.rawValue})
                for purchase in filteredSubIds {
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                }
                if filteredSubIds.count > 0 {
                    let sorted = filteredSubIds.sorted { (arg0, arg1) -> Bool in
                        guard let date1 = arg0.transaction.transactionDate,
                              let date2 = arg1.transaction.transactionDate else {
                            return false
                        }
                        return date1.compare(date2) == .orderedDescending
                    }
                    print("sorted.first?.productId \(sorted.first?.productId)")
                    
                    if UserType.userTypeInstance.userLogin == .Bussiness{
                        self.validate(product: IAPProduct.FiftyDollarsixMonth.rawValue)
                    }else{
                        self.validate(product: IAPProduct.TwentyDollarsixMonth.rawValue)
                    }
                }else{
                    alert("NO_PURCHASE_RESTORE".localized(), message: "THERE_IS_NO_PURCHASE".localized(), view: self)
                }
            }else{
                alert("NO_PURCHASE_RESTORE".localized(), message: "THERE_IS_NO_PURCHASE".localized(), view: self)
            }
        }
    }
    
//    MARK: RETERIVE PRODUCT PLANS
    func reteriveProductPlans(){
        if UserType.userTypeInstance.userLogin == .Bussiness{
            SwiftyStoreKit.retrieveProductsInfo(["U2CONNECT_HANDLER"]) { result in
                if let product = result.retrievedProducts.first {
                    let priceString = product.localizedPrice!
                    print("Product: \(product.localizedDescription), price: \(priceString)")
                    self.amountTextLabel.text = "\("Cancel anytime".localized()), \("\(priceString) per month".localized())"
                }
                else if let invalidProductId = result.invalidProductIDs.first {
                    print("Invalid product identifier: \(invalidProductId)")
                }
                else {
                    print("Error: \(result.error)")
                }
            }
        }else{
            SwiftyStoreKit.retrieveProductsInfo(["U2CONNECTIOS_HANDLER"]) { result in
                if let product = result.retrievedProducts.first {
                    let priceString = product.localizedPrice!
                    print("Product: \(product.localizedDescription), price: \(priceString)")
                    self.amountTextLabel.text = "\("Cancel anytime".localized()),\("\(priceString) per month".localized()),"
                }
                else if let invalidProductId = result.invalidProductIDs.first {
                    print("Invalid product identifier: \(invalidProductId)")
                }
                else {
                    print("Error: \(result.error)")
                }
            }
        }
    
        
    }
    
    
    //    MARK: PURCHASE PRODUCT
    func purchaseProduct(product: String){
        print(product)
        AFWrapperClass.svprogressHudShow(title: "Purchase plan".localized(), view: self)
        SwiftyStoreKit.purchaseProduct(product, quantity: 1, atomically: true) { [self] result in
            AFWrapperClass.svprogressHudDismiss(view: self)
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                self.productID = purchase.productId
                self.price = purchase.product.localizedPrice ?? ""
                self.paySubscriptionID = purchase.product.subscriptionGroupIdentifier ?? ""
                UserDefaults.standard.set(paySubscriptionID, forKey: "SubscriptionID")
                print("subscriptionID====>>>",paySubscriptionID)
                if purchase.needsFinishTransaction{
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
                if UserType.userTypeInstance.userLogin == .Bussiness{
                    validate(product: IAPProduct.FiftyDollarsixMonth.rawValue)
                    self.subscribe(plan_id: "1", product_id: productID, plan_duration: "30", user_id: UserDefaults.standard.string(forKey: "uID") ?? "", plan_price: price, expire_date:expire_date, type: "1", isfree: "0", subscription_id: paySubscriptionID, purchase_plan: "Monthly")
                }else{
                    validate(product: IAPProduct.TwentyDollarsixMonth.rawValue)
                    self.subscribe(plan_id: "1", product_id: productID, plan_duration: "30", user_id: UserDefaults.standard.string(forKey: "uID") ?? "", plan_price: price, expire_date:expire_date, type: "1", isfree: "0", subscription_id: paySubscriptionID, purchase_plan: "Monthly")
                }
                
            case .error(let error):
                switch error.code {
                case .unknown:
                    print("Unknown error. Please contact support")
                case .clientInvalid:
                    print("Not allowed to make the payment")
                case .paymentCancelled:
                    break
                case .paymentInvalid:
                    print("The purchase identifier was invalid")
                case .paymentNotAllowed:
                    print("The device is not allowed to make the payment")
                case .storeProductNotAvailable:
                    print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied:
                    print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed:
                    print("Could not connect to the network")
                case .cloudServiceRevoked:
                    print("User has revoked permission to use this cloud service")
                default:
                    print((error as NSError).localizedDescription)
                    alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
                    break
                }
            }
        }
    }
    
    //    MARK: VALIDATE PURCHASE
    func validate(product: String) {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { [self] result in
            switch result {
            case .success(let receipt):
                let productId = product
                print(result)
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable,
                    productId: productId,
                    inReceipt: receipt)
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    print("expiryDate====>>>",expiryDate)
                    self.expire_date = "\(expiryDate)"
                    print("\(productId) is valid until \(expiryDate)\n\(items)\n")
                case .expired(let expiryDate, let items):
                    print("\(productId) is expired since \(expiryDate)\n\(items)\n")
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                }
            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
    }
    
    //    MARK: SUBSCRIPTION API
    func subscribe(plan_id: String,product_id: String, plan_duration: String, user_id:String, plan_price: String,expire_date: String,type:String,isfree:String,subscription_id: String, purchase_plan: String){
        let url = kBASEURL + WSMethods.addSubscription
        let authToken  = AppDefaults.token ?? ""
        let headers: HTTPHeaders = ["Token":authToken]
        print(headers)
        let uid = UserDefaults.standard.string(forKey: "uID") ?? ""
        var purchasePlan = ""
        if self.planString == "$50/Six Month"{
            purchasePlan = "Monthly"
        }else if self.planString == "$20/Six Month"{
            purchasePlan = "Monthly"
        }
        let params = ["user_id":uid,"plan_id":"1","product_id":product_id,"plan_price":plan_price,"expire_date":expire_date,"type":"1","isfree":"0","subscription_id":subscription_id,"plan_duration":planString,"purchase_plan":purchasePlan] as [String : Any]
        print(params)
        AFWrapperClass.svprogressHudShow(title: "LOADING".localized(), view: self)
        AFWrapperClass.requestPOSTURL(url, params: params, headers: headers, success: { [self] (dict) in
            print("subscribed response is", dict)
            AFWrapperClass.svprogressHudDismiss(view: self)
            if let status = dict["status"] as? Int{
                let message = dict["message"] as? String ?? ""
                if status == 1{
                    if navType == "Professional Design"{
                        let vc = ProfessionalLikePostViewController()
                        vc.jobIdentity = workerID
                        vc.jobLDatArr = jobLtData
                        self.pushViewController(vc, true)
                    }else if navType == "2"{
                        self.popViewController(false)
                    }
                    else{
                        UserDefaults.standard.set("1", forKey: "subscribed")
                        UserDefaults.standard.set(productID, forKey: "pid")
                        self.popVC()
                    }
                } else if status == 4{
                    showAlertMessage(title: AppAlertTitle.appName.rawValue, message: message, okButton: "OK", controller: self) {
                        self.popVC()
                    }
                }else{
                    showAlert(message: message, title: AppAlertTitle.appName.rawValue)
                }
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(error.localizedDescription)
        }
    }
    
}


// MARK: DATE & TIME
extension Int {
    
    var seconds: Int {
        return self
    }
    
    var minutes: Int {
        return self.seconds * 60
    }
    
    var hours: Int {
        return self.minutes * 60
    }
    
    var days: Int {
        return self.hours * 24
    }
    
    var weeks: Int {
        return self.days * 7
    }
    
    var months: Int {
        return self.weeks * 4
    }
    
    var years: Int {
        return self.months * 12
    }
}
extension Formatter {
    static let customDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
        return formatter
    }()
}

