//
//  CustomerJobListModel.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 23/08/22.
//

import Foundation
struct CJobListModel : Codable {
    let status : Int?
    let message : String?
    let data : CJobListData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(CJobListData.self, forKey: .data)
    }

}
struct CJobListData : Codable {
    let customer_job_id : String?
    let user_id : String?
    let rate_to : String?
    let rate_from : String?
    let rate_type : String?
    let job_type : String?
    let location : String?
    let created_at : String?
    let is_delete : String?
    let description : String?
    let job_image : String?
    let photo : String?
    let username : String?
    let catagory_details : [CJObCatagory_details]?

    enum CodingKeys: String, CodingKey {

        case customer_job_id = "customer_job_id"
        case user_id = "user_id"
        case rate_to = "rate_to"
        case rate_from = "rate_from"
        case rate_type = "rate_type"
        case job_type = "job_type"
        case location = "location"
        case created_at = "created_at"
        case is_delete = "is_delete"
        case description = "description"
        case job_image = "job_image"
        case photo = "photo"
        case username = "username"
        case catagory_details = "catagory_details"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        customer_job_id = try values.decodeIfPresent(String.self, forKey: .customer_job_id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        rate_to = try values.decodeIfPresent(String.self, forKey: .rate_to)
        rate_from = try values.decodeIfPresent(String.self, forKey: .rate_from)
        rate_type = try values.decodeIfPresent(String.self, forKey: .rate_type)
        job_type = try values.decodeIfPresent(String.self, forKey: .job_type)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        is_delete = try values.decodeIfPresent(String.self, forKey: .is_delete)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        job_image = try values.decodeIfPresent(String.self, forKey: .job_image)
        photo = try values.decodeIfPresent(String.self, forKey: .photo)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        catagory_details = try values.decodeIfPresent([CJObCatagory_details].self, forKey: .catagory_details)
    }
}

struct CJObCatagory_details : Codable {
    let id : String?
    let customer_job_id : String?
    let user_id : String?
    let cat_id : String?
    let experience : String?
    let is_delete : String?
    let create_date : String?
    let category_name : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case customer_job_id = "customer_job_id"
        case user_id = "user_id"
        case cat_id = "cat_id"
        case experience = "experience"
        case is_delete = "is_delete"
        case create_date = "create_date"
        case category_name = "category_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        customer_job_id = try values.decodeIfPresent(String.self, forKey: .customer_job_id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        cat_id = try values.decodeIfPresent(String.self, forKey: .cat_id)
        experience = try values.decodeIfPresent(String.self, forKey: .experience)
        is_delete = try values.decodeIfPresent(String.self, forKey: .is_delete)
        create_date = try values.decodeIfPresent(String.self, forKey: .create_date)
        category_name = try values.decodeIfPresent(String.self, forKey: .category_name)
    }

}

