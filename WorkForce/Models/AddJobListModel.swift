//
//  AddJobListModel.swift
//  WorkForce
//
//  Created by apple on 07/07/22.
//

import Foundation
struct AddJobModel : Codable {
    let status : Int?
    let message : String?
    let data : [AddJobData]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([AddJobData].self, forKey: .data)
    }

}
struct AddJobData : Codable {
    let job_id : String?
    let customer_job_id : String?
    let user_id : String?
    let rate_to : String?
    let rate_from : String?
    let rate_type : String?
    let job_type : String?
    let city : String?
    let state : String?
    let description : String?
    let job_image : String?
    let status : String?
    let created_at : String?
    let updated_at : String?
    let is_delete : String?
    let catagory_details : [Catagory_details]?

    enum CodingKeys: String, CodingKey {

        case job_id = "job_id"
        case customer_job_id = "customer_job_id"
        case user_id = "user_id"
        case rate_to = "rate_to"
        case rate_from = "rate_from"
        case rate_type = "rate_type"
        case job_type = "job_type"
        case city = "city"
        case state = "state"
        case description = "description"
        case job_image = "job_image"
        case status = "status"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case is_delete = "is_delete"
        case catagory_details = "catagory_details"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        job_id = try values.decodeIfPresent(String.self, forKey: .job_id)
        customer_job_id = try values.decodeIfPresent(String.self, forKey: .customer_job_id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        rate_to = try values.decodeIfPresent(String.self, forKey: .rate_to)
        rate_from = try values.decodeIfPresent(String.self, forKey: .rate_from)
        rate_type = try values.decodeIfPresent(String.self, forKey: .rate_type)
        job_type = try values.decodeIfPresent(String.self, forKey: .job_type)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        job_image = try values.decodeIfPresent(String.self, forKey: .job_image)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        is_delete = try values.decodeIfPresent(String.self, forKey: .is_delete)
        catagory_details = try values.decodeIfPresent([Catagory_details].self, forKey: .catagory_details)
    }

}
struct Catagory_details : Codable {
    let id : String?
    let user_id : String?
    let cat_id : String?
    let experience : String?
    let job_id : String?
    let customer_job_id : String?
    let create_date : String?
    let is_delete : String?
    let category_name : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case cat_id = "cat_id"
        case experience = "experience"
        case job_id = "job_id"
        case customer_job_id = "customer_job_id"
        case create_date = "create_date"
        case is_delete = "is_delete"
        case category_name = "category_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        cat_id = try values.decodeIfPresent(String.self, forKey: .cat_id)
        experience = try values.decodeIfPresent(String.self, forKey: .experience)
        job_id = try values.decodeIfPresent(String.self, forKey: .job_id)
        customer_job_id = try values.decodeIfPresent(String.self, forKey: .customer_job_id)
        create_date = try values.decodeIfPresent(String.self, forKey: .create_date)
        is_delete = try values.decodeIfPresent(String.self, forKey: .is_delete)
        category_name = try values.decodeIfPresent(String.self, forKey: .category_name)
    }

}
