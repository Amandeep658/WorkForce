//
//  BusinessModel.swift
//  WorkForce
//
//  Created by apple on 01/07/22.
//

import Foundation
struct BusinessLocalModel: Decodable{
    var user_id: Int?
    var username: String?
    var company_name: String?
    var mobile_no: String?
    var first_name: String?
    var last_name: String?
    var date_of_birth: String?
    var city: String?
    var state: String?
    var photo: String?
    var location: String?
    var description: String?
    var verification_code: String?
    var type: String?
    var auth_token: String?
    var status: String?
    var rate_to: String?
    var job_type: String?
}
