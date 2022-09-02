//
//  UserChatUserListModel.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 20/07/22.
//

import Foundation
struct UserChatListModel : Codable {
    let status : Int?
    let message : String?
    let user_data : UserChatList_data?
    let all_users : [ChatUSerListAll_users]?
    let last_page : String?
    let unread_message_count : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case user_data = "user_data"
        case all_users = "all_users"
        case last_page = "last_page"
        case unread_message_count = "unread_message_count"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        user_data = try values.decodeIfPresent(UserChatList_data.self, forKey: .user_data)
        all_users = try values.decodeIfPresent([ChatUSerListAll_users].self, forKey: .all_users)
        last_page = try values.decodeIfPresent(String.self, forKey: .last_page)
        unread_message_count = try values.decodeIfPresent(String.self, forKey: .unread_message_count)
    }

}
struct UserChatList_data : Codable {
    let user_id : String?
    let username : String?
    let isSubscribed : String?
    let plan_id : String?
    let company_name : String?
    let mobile_no : String?
    let first_name : String?
    let last_name : String?
    let date_of_birth : String?
    let city : String?
    let state : String?
    let location : String?
    let description : String?
    let photo : String?
    let type : String?
    let latitude : String?
    let longitude : String?
    let verification_code : String?
    let auth_token : String?
    let created_at : String?
    let device_type : String?
    let device_token : String?
    let status : String?
    let updated_at : String?
    let rate_from : String?
    let rate_to : String?
    let rate_type : String?
    let job_type : String?

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

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        isSubscribed = try values.decodeIfPresent(String.self, forKey: .isSubscribed)
        plan_id = try values.decodeIfPresent(String.self, forKey: .plan_id)
        company_name = try values.decodeIfPresent(String.self, forKey: .company_name)
        mobile_no = try values.decodeIfPresent(String.self, forKey: .mobile_no)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        date_of_birth = try values.decodeIfPresent(String.self, forKey: .date_of_birth)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        photo = try values.decodeIfPresent(String.self, forKey: .photo)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        verification_code = try values.decodeIfPresent(String.self, forKey: .verification_code)
        auth_token = try values.decodeIfPresent(String.self, forKey: .auth_token)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        device_type = try values.decodeIfPresent(String.self, forKey: .device_type)
        device_token = try values.decodeIfPresent(String.self, forKey: .device_token)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        rate_from = try values.decodeIfPresent(String.self, forKey: .rate_from)
        rate_to = try values.decodeIfPresent(String.self, forKey: .rate_to)
        rate_type = try values.decodeIfPresent(String.self, forKey: .rate_type)
        job_type = try values.decodeIfPresent(String.self, forKey: .job_type)
    }

}

struct ChatUSerListAll_users : Codable {
    let room_id : String?
    let room_no : String?
    let sender_id : String?
    let receiver_id : String?
    let creation_date : String?
    let username : String?
    let company_name : String?
    let is_delete : String?
    let type : String?
    let message : String?
    let message_time : String?
    let unread_count : String?
    let photo : String?

    enum CodingKeys: String, CodingKey {

        case room_id = "room_id"
        case room_no = "room_no"
        case sender_id = "sender_id"
        case receiver_id = "receiver_id"
        case creation_date = "creation_date"
        case username = "username"
        case company_name = "company_name"
        case is_delete = "is_delete"
        case type = "type"
        case message = "message"
        case message_time = "message_time"
        case unread_count = "unread_count"
        case photo = "photo"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        room_id = try values.decodeIfPresent(String.self, forKey: .room_id)
        room_no = try values.decodeIfPresent(String.self, forKey: .room_no)
        sender_id = try values.decodeIfPresent(String.self, forKey: .sender_id)
        receiver_id = try values.decodeIfPresent(String.self, forKey: .receiver_id)
        creation_date = try values.decodeIfPresent(String.self, forKey: .creation_date)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        company_name = try values.decodeIfPresent(String.self, forKey: .company_name)
        is_delete = try values.decodeIfPresent(String.self, forKey: .is_delete)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        message_time = try values.decodeIfPresent(String.self, forKey: .message_time)
        unread_count = try values.decodeIfPresent(String.self, forKey: .unread_count)
        photo = try values.decodeIfPresent(String.self, forKey: .photo)
    }

}


