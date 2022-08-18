//
//  SubcriptionClass.swift
//  Closet
//
//  Created by apple on 11/02/22.
//

import Foundation
import StoreKit
//feb5ba31f383410c87501ebdbfbadb70
enum PKIAPHandlerAlertType {
    case setProductIds
    case disabled
    case restored
    case purchased
    
    var message: String{
        switch self {
        case .setProductIds: return "Product ids not set, call setProductIds method!"
        case .disabled: return "Purchases are disabled in your device!"
        case .restored: return "You've successfully restored your purchase!"
        case .purchased: return "You've successfully bought this purchase!"
        }
    }
}


class PKIAPHandler: NSObject {
    
    //MARK:- Shared Object
    //MARK:-
    static let shared = PKIAPHandler()
    private override init() { }
    
    //MARK:- Properties
    //MARK:- Private
    fileprivate var productIds = [String]()
    fileprivate var productID = ""
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var fetchProductComplition: (([SKProduct])->Void)?
    
    fileprivate var productToPurchase: SKProduct?
    fileprivate var purchaseProductComplition: ((PKIAPHandlerAlertType, SKProduct?, SKPaymentTransaction?)->Void)?
    fileprivate var restoredProductComplition: ((PKIAPHandlerAlertType, SKProduct?, SKPaymentTransaction?)->Void)?

    //MARK:- Public
    var isLogEnabled: Bool = true
    
    //MARK:- Methods
    //MARK:- Public
    
    //Set Product Ids
    func setProductIds(ids: [String]) {
        self.productIds = ids
    }
    
    //MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    func purchase(product: SKProduct, complition: @escaping ((PKIAPHandlerAlertType, SKProduct?, SKPaymentTransaction?)->Void)) {
        
        self.purchaseProductComplition = complition
        self.productToPurchase = product
        
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            log("PRODUCT TO PURCHASE: \(product.productIdentifier)")
            productID = product.productIdentifier
        }
        else {
            complition(PKIAPHandlerAlertType.disabled, nil, nil)
        }
    }
    
    // RESTORE PURCHASE
    func restorePurchase(complition: @escaping ((PKIAPHandlerAlertType, SKProduct?, SKPaymentTransaction?)->Void)){
        self.purchaseProductComplition = complition
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    // FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts(complition: @escaping (([SKProduct])->Void)){
        
        self.fetchProductComplition = complition
        // Put here your IAP Products ID's
        if self.productIds.isEmpty {
            log(PKIAPHandlerAlertType.setProductIds.message)
            fatalError(PKIAPHandlerAlertType.setProductIds.message)
        }
        else {
            productsRequest = SKProductsRequest(productIdentifiers: Set(self.productIds))
            productsRequest.delegate = self
            productsRequest.start()
        }
    }
    
    //MARK:- Private
    fileprivate func log <T> (_ object: T) {
        if isLogEnabled {
            NSLog("\(object)")
        }
    }
}

//MARK:- Product Request Delegate and Payment Transaction Methods
//MARK:-
extension PKIAPHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver{
    
    // REQUEST IAP PRODUCTS
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        
        if (response.products.count > 0) {
            if let complition = self.fetchProductComplition {
                complition(response.products)
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if let complition = self.purchaseProductComplition {
            complition(PKIAPHandlerAlertType.restored, nil, nil)
        }
    }
    
    // IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    log("Product purchase done")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    if let complition = self.purchaseProductComplition {
                        complition(PKIAPHandlerAlertType.purchased, self.productToPurchase, trans)
                    }
                    return
                    
                case .failed:
                    log("Product purchase failed")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    if let complition = self.purchaseProductComplition {
                        complition(PKIAPHandlerAlertType.disabled, self.productToPurchase, trans)
                    }
                    return
                case .restored:
                    log("Product restored")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    if let complition = self.restoredProductComplition {
                        complition(PKIAPHandlerAlertType.restored, self.productToPurchase, trans)
                    }
                    return
                default: return
                }
            }
        }
    }
    
    
    func validateReceipt(url:String,complete: @escaping ([String:Any]?) -> Void){
        //        For testing
//        let urlString = "https://sandbox.itunes.apple.com/verifyReceipt"
        //        for produc
                let urlString = "https://buy.itunes.apple.com/verifyReceipt"
        
        
        guard let receiptURL = Bundle.main.appStoreReceiptURL, let receiptString = try? Data(contentsOf: receiptURL).base64EncodedString() , let url = URL(string: url) else {
            complete(nil)
            return
        }
        
        let requestData : [String : Any] = ["receipt-data" : receiptString,
                                            "password" : "56601700df564c98b7049fa7f4518d5c",
                                            "exclude-old-transactions" : false]
        let httpBody = try? JSONSerialization.data(withJSONObject: requestData, options: [])
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        URLSession.shared.dataTask(with: request)  { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]{
                    print(jsonData)
                    if jsonData["status"] as! Int == 21007{
                        self.validateReceipt(url: "https://sandbox.itunes.apple.com/verifyReceipt") {(response) in
                            complete(response)
                        }
                    }
                    else{
                        if let latestReceipt = jsonData["latest_receipt_info"] as? [[String:Any]]{
                            if latestReceipt.count > 0{
                                complete(latestReceipt.first)
                            }
                            else{
                                complete(nil)
                            }
                        }
                        else{
                            complete(nil)
                        }

                    }
                }
                else{
                    complete(nil)
                }
            }
        }.resume()
    }
}

extension SKProduct {

        func localizedPrice() -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = self.priceLocale
            return formatter.string(from: self.price) ?? "0"
        }
}

    
