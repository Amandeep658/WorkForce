//
//  SubscriptionModelList.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 01/08/22.
//

import Foundation
struct SubcriptModel:Decodable{
    var status: Int = 0
    var message: String = ""
    var id: String = ""
    var user_id: String = ""
    var plan_id: String = ""
    var product_id: String = ""
    var subscription_id: String = ""
    var type: String = ""
    var isfree: String = ""
    var start_date: String = ""
    var expire_date: String = ""
    var plan_duration: String = ""
    var plan_price: String = ""
    var created: String = ""
    var isSubscribed: String = ""

    private enum CodingKeys : String, CodingKey {
        case user_id = "user_id",message = "message", plan_id, id,subscription_id,start_date, plan_duration,expire_date = "expire_date",plan_price = "plan_price",product_id,isSubscribed,created,isfree
    }
    
    func convertDict()-> NSMutableDictionary{
        let dict = NSMutableDictionary()
        dict.setValue(status, forKey: "status")
        dict.setValue(message, forKey: "message")
        dict.setValue(created, forKey: "created")
        dict.setValue(user_id, forKey: "user_id")
        dict.setValue(plan_id, forKey: "plan_id")
        dict.setValue(id, forKey: "id")
        dict.setValue(subscription_id, forKey: "subscription_id")
        dict.setValue(start_date, forKey: "start_date")
        dict.setValue(plan_duration, forKey: "plan_duration")
        dict.setValue(expire_date, forKey: "expire_date")
        dict.setValue(plan_price, forKey: "plan_price")
        dict.setValue(product_id, forKey: "product_id")
        dict.setValue(isSubscribed, forKey: "isSubscribed")
        dict.setValue(created, forKey: "created")
        dict.setValue(isfree, forKey: "isfree")
        return dict

    }
}
