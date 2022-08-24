//
//  ProfessionalProfileModel.swift
//  WorkForce
//
//  Created by apple on 29/06/22.
//

import Foundation

struct ProfessionalProfileData : Decodable {
    var user_id : String?
    var username : String?
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
    var catagory_details : [CategoryData]?

    enum CodingKeys: String, CodingKey {

        case user_id = "user_id"
        case username = "username"
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
        case catagory_details = "catagory_details"
    }

    init(from decoder: Decoder) throws {
        var values = try decoder.container(keyedBy: CodingKeys.self)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        username = try values.decodeIfPresent(String.self, forKey: .username)
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
        catagory_details = try values.decodeIfPresent([CategoryData].self, forKey: .catagory_details)
    }

}


