//
//  ConstantFile.swift
//  U2 CONNECT
//
//  Created by Apple on 24/Jun/2022
//

import Foundation

import UIKit

class colorsApp:NSObject{
    static let appColor = colorsApp()
    let appcolor = #colorLiteral(red: 1, green: 0, blue: 0.6117647059, alpha: 1)
    let bordercolor = #colorLiteral(red: 0.7638315558, green: 0.2553908527, blue: 0.7413333058, alpha: 1)
    let tabGrayColor = UIColor.gray
    let gold = #colorLiteral(red: 1, green: 0.9529411765, blue: 0.1607843137, alpha: 1)
    let vip = #colorLiteral(red: 0.1843137255, green: 0.2784313725, blue: 1, alpha: 1)
    let silver = #colorLiteral(red: 0.631372549, green: 0.631372549, blue: 0.631372549, alpha: 1)
    let free = #colorLiteral(red: 0.9803921569, green: 0.1921568627, blue: 0.6078431373, alpha: 1)
}

let DeviceSize = UIScreen.main.bounds.size
@available(iOS 13.0, *)
let appDel = (UIApplication.shared.delegate as! AppDelegate)
@available(iOS 13.0, *)
let appScene = (UIApplication.shared.delegate  as! SceneDelegate)

//let kBASEURL = "http://161.97.132.85/work-force/webservice/"
let kBASEURL = "http://161.97.132.85/work-forcev2/webservice/"
let urlInAppSubscriptionString = "https://sandbox.itunes.apple.com/verifyReceipt"

struct WSMethods {
    
//    Restore Account API's
    static let getRecoverEmail = "getRecoverEmail.php"
    static let updateMobileNumber = "updateMobileNumber.php"
    
//    Language Update
    static let getCurrentlangugae = "UpdateLanguage.php"
    
//    Business Module API's
    static let loginCheck = "loginCheck.php"
    static let signUpCheck = "signUp.php"
    static let addCompany = "addCompany.php"
    static let getCompanyListing = "getCompanyListing.php"
    static let nearCustomerByJobs = "nearCustomerByJobs.php"
    static let editCompany = "editCompany.php"
    static let editJob = "editJob.php"
    static let logout = "logout.php"
    static let deleteUserAccount = "deleteUserAccount.php"
    static let nearByWorker = "nearByWorker.php"
    static let getComapnyConnectList = "getCompanyLikeWorker.php"
    static let getAllJobLike = "getAllJobLike.php"
    static let jobListing = "nearByJobsv2.php"
    static let subscriptionstatus = "subscriptionstatus.php"
    static let professionalNotificationList = "notificationActivity.php"
    static let getCompanyListingbyJob = "getCompanyListingByJobs.php"
    static let getJobDetailById = "getJobDetailsByJobId.php"
    static let getJobListbyUseId = "getJobDetailsByuserId.php"
    static let getWorkerDetail = "getProfessionalv2.php"
    static let getProfessionalProfile = "getProfessional.php"
    static let getUserDetailByUserId = "getJobDetailsByuserId.php"
    static let filterList = "companyWorkerFilter.php"
    static let getCompaniesList = "getAllCompanyLike.php"
    static let professionalFilter = "professionalsFilter.php"
    static let editProfessional = "editProfessional.php"
    static let professionalLikePost = "professionalLikePost.php"
    static let createRoom = "createRoom.php"
    static let sendMessage = "sendMessage.php"
    static let sendMessagev2 = "sendMessagev2.php"
    static let messageSeenUpdated = "UpdateMessageSeen.php"
    static let addJob = "addJob.php"
    static let getAllChatUser = "getAllChatUser.php"
    static let GetChatListing = "GetChatListing.php"
    static let deleteJob = "deletetManageJob.php"
    static let addProfessional = "addProfessional.php"
    static let getCategoryListing = "getCategoryListing.php"
    static let addSubscription =  "addSubscription.php"
    static let getjobLikeAndUnlike = "LikeAndUnlike.php"
    static let workerLikeOrUnlike = "workerLikeAndUnlike.php"
    static let termsCondition = "http://161.97.132.85/work-force/webservice/terms&services.html"
    static let privacyPolicy = "http://161.97.132.85/work-force/webservice/Privacy-policy.html"
    static let about = "http://161.97.132.85/work-force/webservice/about.html"
//    MARK: COUSTOMER MODULE
    static let getNearByCompanyListing = "getNearByCompanyListing.php"
    static let getCompanyListingbycompanyId = "getCompanyListingbycompanyId.php"
    static let customerLikeAndUnlikecompany = "customerLikeAndUnlikecompany.php"
    static let getCompanyLikeCustomer = "getCompanyLikeCustomer.php"
    static let getCustomer = "getCustomer.php"
    static let editCustomer = "editCustomer.php"
    static let getCompanyListingByJobs = "getCompanyListingByJobs.php"
    static let ResentVerficationEmail = "ResentVerficationEmail.php"
    static let verify = "verify.php"
    static let customerAddJob = "addCustomerJob.php"
    static let customerGetJobDetailsByuserId = "customerGetJobDetailsByuserId.php"
    static let customerGetJobDetailsByJobId = "customerGetJobDetailsByJobId.php"
    static let editCustomerJob = "editCustomerJob.php"
    static let deletetCustomerManageJob = "deletetCustomerManageJob.php"
    static let customerLikeAndUnlike = "customerLikeAndUnlike.php"
    static let getAllcustomerJobLike = "getAllcustomerJobLike.php"
    static let companyLikeAndUnlikeBycustomer = "companyLikeAndUnlikeBycustomer.php"
    
//    MARK: INVOICE MODULE BUSINESS AND PROFESSIONAL
    static let invoiceEstimateList = "invoices_estimatelisting.php"
    static let invoiceEstimateAddressList = "businessaddressinvoice.php"
    static let invoiceCustomerAddressList = "customeraddressinvoice.php"
    static let invoiceShippingAddressList = "shippingaddressinvoice.php"
//    static let addinvoiceList = "addinvoice.php"
    static let addinvoicev2 = "addinvoicev2.php"
    static let getinvoice = "getinvoice.php"
    static let updateestimate = "updateestimate.php"

}



struct Pagination{
    var canLoadMore: Bool = true
        var pageNum: Int = 1
        var isLoading: Bool = false
        var limit: Int = 10
}


struct SettingWebLinks {
    static let privacyPolicy = "PrivacyAndPolicy.html"
    static let aboutUs = "about.html"
    static let termsAndConditions = "terms&services.html"
}
struct NavBarTitle {
  
}
struct StoryboardName {
static let Business = "Main"
static let Professional = "Professional"
}
struct ViewControllerIdentifier {
   
    static let BusinessView = "BusinessesViewController"
}

struct DefaultKeys{
    static let deviceToken = "deviceToken"
    static let token = "authToken"
    static let expireValue = "TokenExpire"
    static let id = "userId"
    static let radius = "radius"
}

extension UIViewController{
    func saveDefauls(plan_id:String,isSubscribed:String){
        WDefault.set(plan_id, forKey: "plan_id")
        WDefault.set(isSubscribed, forKey: "isSubscribed")
        WDefault.synchronize()
    }
    func retrieveDefaults()->(String,String){
       let plan_id = WDefault.string(forKey: "plan_id") ?? ""
        let isSubscribed = WDefault.string(forKey: "isSubscribed") ?? ""
        return (plan_id,isSubscribed)
    }
    func removeDefaults(){
        WDefault.removeObject(forKey: "plan_id")
        WDefault.removeObject(forKey: "isSubscribed")
    }
}


