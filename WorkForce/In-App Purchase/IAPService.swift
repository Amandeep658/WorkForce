//
//  IAPService.swift
//  Blite
//
//  Created by Vivek Dharmani on 06/11/20.
//  Copyright © 2020 Vivek Dharmani. All rights reserved.
//

import Foundation
import StoreKit
import SwiftyStoreKit
var sharedSecret = "5559ca386c454aff9205f61c45770269"

class IAPService: NSObject{
    private override init() { }
    static let shared = IAPService()
    var products = [SKProduct]()
    let paymentQueue = SKPaymentQueue.default()
    //MARK::- Getting products
    func getProducts(){
        let products: Set = [IAPProduct.TwentyDollarsixMonth.rawValue,IAPProduct.FiftyDollarsixMonth.rawValue]
        let productRequest = SKProductsRequest(productIdentifiers: products)
        productRequest.delegate = self
        productRequest.start()
        paymentQueue.add(self)
    }
    
    //MARK::- Make a purchase with product
    func purchase(product: IAPProduct){
        guard let productToPurchase = self.products.filter({$0.productIdentifier == product.rawValue}).first else{
            return
        }
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }
    func makeAPurchase(){
        if SwiftyStoreKit.canMakePayments{
            SwiftyStoreKit.purchaseProduct(products[0]) { (result) in
                print(result)
            }
        }
    }
    
}

extension IAPService: SKProductsRequestDelegate{
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        var pricingArray = [String]()
        for product in products{
            pricingArray.append(product.localizedPrice ?? "")
            if #available(iOS 12.2, *) {
                print(product.localizedDescription, product.localizedPrice ?? 0, product.localizedTitle, product.discounts)
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

extension IAPService: SKPaymentTransactionObserver{
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    }
}

extension SKPaymentTransactionState{
    func getStatus()->String{
        switch self {
        case .deferred:
            return "deferred"
        case .failed:
            return "failed"
        case .purchased:
            return "purchased"
        case .purchasing:
            return "purchasing"
        case .restored:
            return "restored"
        default:
            return "nil"
        }
    }
}
