//
//  NotificationModel.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 24/07/22.
//

import Foundation
struct ProfessionalNotificationModel : Codable {
    let status : Int?
    let message : String?
    let data : [ProfessionalNotificationData]?
    let lastPage : String?
    let count : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
        case lastPage = "lastPage"
        case count = "count"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([ProfessionalNotificationData].self, forKey: .data)
        lastPage = try values.decodeIfPresent(String.self, forKey: .lastPage)
        count = try values.decodeIfPresent(String.self, forKey: .count)
    }

}
struct ProfessionalNotificationData : Codable {
    let notification_id : String?
    let username : String?
    let message : String?
    let notification_type : String?
    let user_id : String?
    let otherID : String?
    let room_id : String?
    let job_id : String?
    let category_id : String?
    let status_id : String?
    let creation_date : String?
    let viewed_status : String?
    let notification_read_status : String?
    let title_message : String?
    let photo : String?
    let cat_id : String?

    enum CodingKeys: String, CodingKey {

        case notification_id = "notification_id"
        case username = "username"
        case message = "message"
        case notification_type = "notification_type"
        case user_id = "user_id"
        case otherID = "otherID"
        case room_id = "room_id"
        case job_id = "job_id"
        case category_id = "category_id"
        case status_id = "status_id"
        case creation_date = "creation_date"
        case viewed_status = "viewed_status"
        case notification_read_status = "notification_read_status"
        case title_message = "title_message"
        case photo = "photo"
        case cat_id = "cat_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        notification_id = try values.decodeIfPresent(String.self, forKey: .notification_id)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        notification_type = try values.decodeIfPresent(String.self, forKey: .notification_type)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        otherID = try values.decodeIfPresent(String.self, forKey: .otherID)
        room_id = try values.decodeIfPresent(String.self, forKey: .room_id)
        job_id = try values.decodeIfPresent(String.self, forKey: .job_id)
        category_id = try values.decodeIfPresent(String.self, forKey: .category_id)
        status_id = try values.decodeIfPresent(String.self, forKey: .status_id)
        creation_date = try values.decodeIfPresent(String.self, forKey: .creation_date)
        viewed_status = try values.decodeIfPresent(String.self, forKey: .viewed_status)
        notification_read_status = try values.decodeIfPresent(String.self, forKey: .notification_read_status)
        title_message = try values.decodeIfPresent(String.self, forKey: .title_message)
        photo = try values.decodeIfPresent(String.self, forKey: .photo)
        cat_id = try values.decodeIfPresent(String.self, forKey: .cat_id)
    }

}

