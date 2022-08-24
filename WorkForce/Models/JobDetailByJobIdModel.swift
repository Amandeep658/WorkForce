//
//  JobDetailByJobIdModel.swift
//  WorkForce
//
//  Created by apple on 07/07/22.
//

import Foundation
struct JobDetailByJobIdModel : Decodable {
    var status : Int?
    var  message : String?
    var data : JobDetailByJobIDData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }
}
struct JobDetailByJobIDData : Decodable {
    var job_id : String?
    var customer_job_id : String?
    var user_id : String?
    var rate_to : String?
    var rate_from : String?
    var rate_type : String?
    var job_type : String?
    var city : String?
    var location : String?
    var state : String?
    var description : String?
    var date_of_birth : String?
    var job_image : String?
    var status : String?
    var created_at : String?
    var updated_at : String?
    var is_delete : String?
    var photo : String?
    var username : String?
    var company_name : String?
    var catagory_details : [CategoryData]?

    enum CodingKeys: String, CodingKey {

        case job_id = "job_id"
        case customer_job_id = "customer_job_id"
        case user_id = "user_id"
        case rate_to = "rate_to"
        case rate_from = "rate_from"
        case rate_type = "rate_type"
        case job_type = "job_type"
        case city = "city"
        case location = "location"
        case state = "state"
        case description = "description"
        case date_of_birth = "date_of_birth"
        case job_image = "job_image"
        case status = "status"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case is_delete = "is_delete"
        case photo = "photo"
        case username = "username"
        case company_name = "company_name"
        case catagory_details = "catagory_details"
    }
}


