//
//  SubscriptionModel.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 29/07/22.
//

import Foundation
struct SubscriptionModel : Codable {
    let status : Int?
    let message : String?
    let data : SubscriptionData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(SubscriptionData.self, forKey: .data)
    }

}
struct SubscriptionData : Codable {
    let id : String?
    let user_id : String?
    let plan_id : String?
    let product_id : String?
    let subscription_id : String?
    let type : String?
    let isfree : String?
    let start_date : String?
    let expire_date : String?
    let expire_time : String?
    let plan_duration : String?
    let purchase_plan : String?
    let plan_price : String?
    let created : String?
    let isSubscribed : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case plan_id = "plan_id"
        case product_id = "product_id"
        case subscription_id = "subscription_id"
        case type = "type"
        case isfree = "isfree"
        case start_date = "start_date"
        case expire_date = "expire_date"
        case expire_time = "expire_time"
        case plan_duration = "plan_duration"
        case purchase_plan = "purchase_plan"
        case plan_price = "plan_price"
        case created = "created"
        case isSubscribed = "isSubscribed"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        plan_id = try values.decodeIfPresent(String.self, forKey: .plan_id)
        product_id = try values.decodeIfPresent(String.self, forKey: .product_id)
        subscription_id = try values.decodeIfPresent(String.self, forKey: .subscription_id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        isfree = try values.decodeIfPresent(String.self, forKey: .isfree)
        start_date = try values.decodeIfPresent(String.self, forKey: .start_date)
        expire_date = try values.decodeIfPresent(String.self, forKey: .expire_date)
        expire_time = try values.decodeIfPresent(String.self, forKey: .expire_time)
        plan_duration = try values.decodeIfPresent(String.self, forKey: .plan_duration)
        purchase_plan = try values.decodeIfPresent(String.self, forKey: .purchase_plan)
        plan_price = try values.decodeIfPresent(String.self, forKey: .plan_price)
        created = try values.decodeIfPresent(String.self, forKey: .created)
        isSubscribed = try values.decodeIfPresent(String.self, forKey: .isSubscribed)
    }

}
