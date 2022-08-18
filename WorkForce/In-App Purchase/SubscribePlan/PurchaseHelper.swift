//
//  PurchaseHelper.swift
//  Blite
//
//  Created by Vivek Dharmani on 06/11/20.
//  Copyright © 2020 Vivek Dharmani. All rights reserved.
//

import Foundation
import SwiftyStoreKit
import Alamofire

class PurchaseHelper{
    static let shared = PurchaseHelper()
    func setPurchaseDefaults(transactionDate: Date, expiryDate: Date, productId: String){
        let ud = UserDefaults.standard
        ud.set(transactionDate, forKey: "start_date")
        ud.set(expiryDate, forKey: "expire_date")
        ud.set(productId, forKey: "product_id")
        UserDefaults.standard.set("1", forKey: "subscribed")
        if productId == "free"{
            ud.set("free", forKey: "freeVal")
        }
        ud.synchronize()
    }
    func removePurchaseDefaults(){
        let ud = UserDefaults.standard
        if ud.value(forKey: "start_date") != nil,ud.value(forKey: "expire_date") != nil,ud.value(forKey: "product_id") != nil{
            ud.removeObject(forKey: "start_date")
            ud.removeObject(forKey: "expire_date")
            ud.removeObject(forKey: "product_id")
            ud.synchronize()
        }
        if let _ = ud.value(forKey: "freeVal"){
            ud.removeObject(forKey: "freeVal")
        }
        UserDefaults.standard.set("0", forKey: "subscribed")
    }
    
    func validateReceipt(productId: String, secretKey: String, transactionId: String){
        let appleValidator = AppleReceiptValidator(service: .sandbox, sharedSecret: secretKey)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable,
                    productId: productId,
                    inReceipt: receipt)
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    if (expiryDate.timeIntervalSinceNow.sign == .plus){
                        let toDate = expiryDate;
                        let fromDate = Calendar.current.date(byAdding: .month, value: -1, to: toDate)
                        let filterTid = items.filter {$0.transactionId == transactionId}
                        
                        if filterTid.count > 0{
                            let formatter1 = DateFormatter()
                            formatter1.dateFormat = "dd-MM-YYYY"
                            formatter1.timeZone = .current
                            
                            self.setPurchaseDefaults(transactionDate: fromDate!, expiryDate: toDate, productId: productId)
//                            var planString = ""
//                            if productId == IAPProduct.MonthlyPlan.rawValue{
//                                planString = "MonthlyPlan"
//                            }
                          //  if transactionId != items[0].transactionId{
                                
                           // }
                        }else{
                            self.removePurchaseDefaults()
                        }
                        
                        for i in 0..<items.count{
                            if transactionId == items[i].transactionId{
                                print("transaction is at \(i)th index \(items)")
                            }
                        }
                        
                        
                        let timeStamp = expiryDate.timeIntervalSince1970
                        let fdate = Date(timeIntervalSince1970: timeStamp)
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd/MM/YYYY hh:mm a"
                        formatter.timeZone = .current
                        let expiryString = formatter.string(from: fdate)
                        print("Expiry date is in future \(expiryString)", items[0].originalTransactionId);
                        break
                    }else{
                        UserDefaults.standard.set(expiryDate, forKey: "dateExpired")
                        self.removePurchaseDefaults()
                    }
                case .expired(let expiryDate, let items):
                    self.removePurchaseDefaults()
                    UserDefaults.standard.set(expiryDate, forKey: "dateExpired")
                    print("\(productId) is expired since \(expiryDate)\n\(items[0].transactionId)\n\(items[0].isInIntroOfferPeriod)")
                case .notPurchased:
                    self.removePurchaseDefaults()
                    print("The user has never purchased \(productId)")
                }
            case .error(let error):
                self.removePurchaseDefaults()
                print("Receipt verification failed: \(error)")
            }
        }
    }
    
    func isSubscriptionValid()->Bool{
        let ud = UserDefaults.standard
        if  ud.value(forKey: "start_date") != nil,ud.value(forKey: "expire_date") != nil,ud.value(forKey: "product_id") != nil{
            return true
        }else{
            return false
        }
    }
    
}
