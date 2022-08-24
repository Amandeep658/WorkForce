//
//  ChatDataModel.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 21/07/22.
//

import Foundation
struct ChatDataModel : Decodable {
    var status : Int?
    var message : String?
    var room_id : String?
    var receiver_id : String?
    var all_messages : [ChatAllMessages]?
    var last_page : String?
    var receiver_detail : ChatReceiver_detail?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case room_id = "room_id"
        case receiver_id = "receiver_id"
        case all_messages = "all_messages"
        case last_page = "last_page"
        case receiver_detail = "receiver_detail"
    }

    init(from decoder: Decoder) throws {
        var values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        room_id = try values.decodeIfPresent(String.self, forKey: .room_id)
        receiver_id = try values.decodeIfPresent(String.self, forKey: .receiver_id)
        all_messages = try values.decodeIfPresent([ChatAllMessages].self, forKey: .all_messages)
        last_page = try values.decodeIfPresent(String.self, forKey: .last_page)
        receiver_detail = try values.decodeIfPresent(ChatReceiver_detail.self, forKey: .receiver_detail)
    }

}
struct ChatReceiver_detail : Codable {
    var user_id : String?
    var username : String?
    var isSubscribed : String?
    var plan_id : String?
    var company_name : String?
    var mobile_no : String?
    var first_name : String?
    var last_name : String?
    var date_of_birth : String?
    var city : String?
    var state : String?
    var location : String?
    var description : String?
    var photo : String?
    var type : String?
    var latitude : String?
    var longitude : String?
    var verification_code : String?
    var auth_token : String?
    var created_at : String?
    var device_type : String?
    var device_token : String?
    var status : String?
    var updated_at : String?
    var rate_from : String?
    var rate_to : String?
    var rate_type : String?
    var job_type : String?

    enum CodingKeys: String, CodingKey {

        case user_id = "user_id"
        case username = "username"
        case isSubscribed = "isSubscribed"
        case plan_id = "plan_id"
        case company_name = "company_name"
        case mobile_no = "mobile_no"
        case first_name = "first_name"
        case last_name = "last_name"
        case date_of_birth = "date_of_birth"
        case city = "city"
        case state = "state"
        case location = "location"
        case description = "description"
        case photo = "photo"
        case type = "type"
        case latitude = "latitude"
        case longitude = "longitude"
        case verification_code = "verification_code"
        case auth_token = "auth_token"
        case created_at = "created_at"
        case device_type = "device_type"
        case device_token = "device_token"
        case status = "status"
        case updated_at = "updated_at"
        case rate_from = "rate_from"
        case rate_to = "rate_to"
        case rate_type = "rate_type"
        case job_type = "job_type"
    }

}
struct ChatAllMessages : Decodable {
    var id : String?
    var room_id : String?
    var user_id : String?
    var message : String?
    var read_status : String?
    var post_id : String?
    var creation_date : String?
    var other_id : String?
    var created : String?
    var photo : String?
    var username : String?

    
    init(dict: NSDictionary) {
        self.id = dict["id"] as? String ?? ""
        self.room_id = dict["room_id"] as? String ?? ""
        self.user_id = dict["user_id"] as? String ?? ""
        self.message = dict["message"] as? String ?? ""
        self.read_status = dict["read_status"] as? String ?? ""
        self.post_id = dict["post_id"] as? String ?? ""
        self.creation_date = dict["creation_date"] as? String ?? ""
        self.other_id = dict["other_id"] as? String ?? ""
        self.created = dict["created"] as? String ?? ""
        self.photo = dict["photo"] as? String ?? ""
        self.username = dict["username"] as? String ?? ""
    }
    
}

