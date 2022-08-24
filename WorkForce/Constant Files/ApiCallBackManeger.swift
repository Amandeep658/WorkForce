//
//  ApiCallBackManeger.swift
//  Industree theodeocampo
//
//  Created by apple on 16/09/21.
//

import Foundation

class RequestViewModel{
    public func getAddressData(pageNo:Int,perPage:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let userId = UserDefaults.standard.string(forKey: "id") ?? ""
        let parameter: [String: Any] = ["user_id":userId,"pageNo":pageNo,"perPage":perPage]
        let url = Constant.shared.baseUrl + Constant.shared.addressListing
        AFWrapperClass.requestPOSTURL(url, params: parameter, success: { (dict) in
            let result = dict as AnyObject
            print(result)
            if let json = result as? NSDictionary{
              success(json as NSDictionary)
            }
        }) {(error) in
            failure(error)
         }
    }
    
    public func addEditAddressData(params:[String:Any],onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let url = Constant.shared.baseUrl + Constant.shared.addEditAddress
        AFWrapperClass.requestPOSTURL(url, params: params, success: { (dict) in
            let result = dict as AnyObject
            print(result)
            if let json = result as? NSDictionary{
              success(json as NSDictionary)
            }
        }) {(error) in
            failure(error)
         }
    }
    
    public func deleteAddressData(params:[String:Any],onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let url = Constant.shared.baseUrl + Constant.shared.deleteAddress
        AFWrapperClass.requestPOSTURL(url, params: params, success: { (dict) in
            let result = dict as AnyObject
            print(result)
            if let json = result as? NSDictionary{
              success(json as NSDictionary)
            }
        }) {(error) in
            failure(error)
         }
    }
    
    public func subscriptionData(params:[String:Any],onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let url = Constant.shared.baseUrl + Constant.shared.subscription
        AFWrapperClass.requestPOSTURL(url, params: params, success: { (dict) in
            let result = dict as AnyObject
            print(result)
            if let json = result as? NSDictionary{
              success(json as NSDictionary)
            }
        }) {(error) in
            failure(error)
         }
    }
    
    public func checkPlanData(params:[String:Any],onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let url = Constant.shared.baseUrl + Constant.shared.checkPlan
        AFWrapperClass.requestPOSTURL(url, params: params, success: { (dict) in
            let result = dict as AnyObject
            print(result)
            if let json = result as? NSDictionary{
              success(json as NSDictionary)
            }
        }) {(error) in
            failure(error)
         }
    }
    
    public func supportData(params:[String:Any],onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let url = Constant.shared.baseUrl + Constant.shared.help
        AFWrapperClass.requestPOSTURL(url, params: params, success: { (dict) in
            let result = dict as AnyObject
            print(result)
            if let json = result as? NSDictionary{
              success(json as NSDictionary)
            }
        }) {(error) in
            failure(error)
         }
    }
    
    public func businessDetailsData(params:[String:Any],onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let url = Constant.shared.baseUrl + Constant.shared.help
        AFWrapperClass.requestPOSTURL(url, params: params, success: { (dict) in
            let result = dict as AnyObject
            print(result)
            if let json = result as? NSDictionary{
              success(json as NSDictionary)
            }
        }) {(error) in
            failure(error)
         }
    }
    
    public func bookingListingData(params:[String:Any],onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let url = Constant.shared.baseUrl + Constant.shared.bookingListing
        AFWrapperClass.requestPOSTURL(url, params: params, success: { (dict) in
            let result = dict as AnyObject
            print(result)
            if let json = result as? NSDictionary{
              success(json as NSDictionary)
            }
        }) {(error) in
            failure(error)
         }
    }
    
    public func paypalConnectData(params:[String:Any],onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let url = Constant.shared.baseUrl + Constant.shared.PaypalLogin
        AFWrapperClass.requestPOSTURL(url, params: params, success: { (dict) in
            let result = dict as AnyObject
            print(result)
            if let json = result as? NSDictionary{
              success(json as NSDictionary)
            }
        }) {(error) in
            failure(error)
         }
    }
    
    public func paypalGetToken(params:[String:Any],onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let url = Constant.shared.baseUrl + Constant.shared.getAccessTokenForPaypal
        AFWrapperClass.requestPOSTURL(url, params: params, success: { (dict) in
            let result = dict as AnyObject
            print(result)
            if let json = result as? NSDictionary{
              success(json as NSDictionary)
            }
        }) {(error) in
            failure(error)
         }
    }
    
    public func paypalData(params:[String:Any],onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let url = Constant.shared.baseUrl + Constant.shared.getPaypalTransactionDetails
        AFWrapperClass.requestPOSTURL(url, params: params, success: { (dict) in
            let result = dict as AnyObject
            print(result)
            if let json = result as? NSDictionary{
              success(json as NSDictionary)
            }
        }) {(error) in
            failure(error)
         }
    }
    
    public func bookingData(params:[String:Any],onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let url = Constant.shared.baseUrl + Constant.shared.booking
        AFWrapperClass.requestPOSTURL(url, params: params, success: { (dict) in
            let result = dict as AnyObject
            print(result)
            if let json = result as? NSDictionary{
              success(json as NSDictionary)
            }
        }) {(error) in
            failure(error)
         }
    }
    
    public func vendorBookingData(params:[String:Any],onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let url = Constant.shared.baseUrl + Constant.shared.vendorBookingListing
        AFWrapperClass.requestPOSTURL(url, params: params, success: { (dict) in
            let result = dict as AnyObject
            print(result)
            if let json = result as? NSDictionary{
              success(json as NSDictionary)
            }
        }) {(error) in
            failure(error)
         }
    }
    
    public func endSessionData(params:[String:Any],onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let url = Constant.shared.baseUrl + Constant.shared.sessionEnd
        AFWrapperClass.requestPOSTURL(url, params: params, success: { (dict) in
            let result = dict as AnyObject
            print(result)
            if let json = result as? NSDictionary{
              success(json as NSDictionary)
            }
        }) {(error) in
            failure(error)
         }
    }
    
    public func markasPaidData(params:[String:Any],onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let url = Constant.shared.baseUrl + Constant.shared.markasPaid
        AFWrapperClass.requestPOSTURL(url, params: params, success: { (dict) in
            let result = dict as AnyObject
            print(result)
            if let json = result as? NSDictionary{
              success(json as NSDictionary)
            }
        }) {(error) in
            failure(error)
         }
    }
    
    public func categoryListData(params:[String:Any],onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let url = Constant.shared.baseUrl + Constant.shared.categoryListing_vendor
        AFWrapperClass.requestPOSTURL(url, params: params, success: { (dict) in
            let result = dict as AnyObject
            print(result)
            if let json = result as? NSDictionary{
              success(json as NSDictionary)
            }
        }) {(error) in
            failure(error)
         }
    }
    
    public func removeCategoryListData(params:[String:Any],onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let url = Constant.shared.baseUrl + Constant.shared.deleteCategory
        AFWrapperClass.requestPOSTURL(url, params: params, success: { (dict) in
            let result = dict as AnyObject
            print(result)
            if let json = result as? NSDictionary{
              success(json as NSDictionary)
            }
        }) {(error) in
            failure(error)
         }
    }
    public func cashData(params:[String:Any],onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let url = Constant.shared.baseUrl + Constant.shared.cashPayment
        AFWrapperClass.requestPOSTURL(url, params: params, success: { (dict) in
            let result = dict as AnyObject
            print(result)
            if let json = result as? NSDictionary{
              success(json as NSDictionary)
            }
        }) {(error) in
            failure(error)
         }
    }
    
    public func addRating(params:[String:Any],onsuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (Error) -> Void) {
        
        let url = Constant.shared.baseUrl + Constant.shared.addRating
        AFWrapperClass.requestPOSTURL(url, params: params, success: { (dict) in
            let result = dict as AnyObject
            print(result)
            if let json = result as? NSDictionary{
              success(json as NSDictionary)
            }
        }) {(error) in
            failure(error)
         }
    }
    
    public func bookingListData(params:[String:Any],onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let url = Constant.shared.baseUrl + Constant.shared.bookingDetail
        AFWrapperClass.requestPOSTURL(url, params: params, success: { (dict) in
            let result = dict as AnyObject
            print(result)
            if let json = result as? NSDictionary{
              success(json as NSDictionary)
            }
        }) {(error) in
            failure(error)
         }
    }
    
    public func getBadgeCount(params:[String:Any],onSuccess success: @escaping (Int) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let url = Constant.shared.baseUrl + Constant.shared.badgeCount
        AFWrapperClass.requestPOSTURL(url, params: params, success: { (dict) in
            if let badge = dict.value(forKey: "badgeCount") as? String{
                success(Int(badge) ?? 0)
            }
        }) {(error) in
            failure(error)
         }
    }
}

