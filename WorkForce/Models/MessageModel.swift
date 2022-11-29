//
//  MessageModel.swift
//  WorkForce
//
//  Created by apple on 13/10/22.
//

import Foundation
struct ChatListModel : Codable {
    let status : Int?
    let message : String?
    let data : ChatListDataModel?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(ChatListDataModel.self, forKey: .data)
    }

}
struct ChatListDataModel : Codable {
    let id : String?
    let room_id : String?
    let user_id : String?
    let message : String?
    let read_status : String?
    let post_id : String?
    let creation_date : String?
    let other_id : String?
    let is_delete : String?
    let chat_image : String?
    let chat_video : String?
    let created : String?
    let photo : String?
    let sender_username : String?
    let company_name : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case room_id = "room_id"
        case user_id = "user_id"
        case message = "message"
        case read_status = "read_status"
        case post_id = "post_id"
        case creation_date = "creation_date"
        case other_id = "other_id"
        case is_delete = "is_delete"
        case chat_image = "chat_image"
        case chat_video = "chat_video"
        case created = "created"
        case photo = "photo"
        case sender_username = "sender_username"
        case company_name = "company_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        room_id = try values.decodeIfPresent(String.self, forKey: .room_id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        read_status = try values.decodeIfPresent(String.self, forKey: .read_status)
        post_id = try values.decodeIfPresent(String.self, forKey: .post_id)
        creation_date = try values.decodeIfPresent(String.self, forKey: .creation_date)
        other_id = try values.decodeIfPresent(String.self, forKey: .other_id)
        is_delete = try values.decodeIfPresent(String.self, forKey: .is_delete)
        chat_image = try values.decodeIfPresent(String.self, forKey: .chat_image)
        chat_video = try values.decodeIfPresent(String.self, forKey: .chat_video)
        created = try values.decodeIfPresent(String.self, forKey: .created)
        photo = try values.decodeIfPresent(String.self, forKey: .photo)
        sender_username = try values.decodeIfPresent(String.self, forKey: .sender_username)
        company_name = try values.decodeIfPresent(String.self, forKey: .company_name)
    }

}

