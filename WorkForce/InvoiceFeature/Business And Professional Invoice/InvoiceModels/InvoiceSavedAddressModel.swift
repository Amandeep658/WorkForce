//
//  InvoiceSavedAddressModel.swift
//  WorkForce
//
//  Created by apple on 28/06/23.
//

import Foundation

struct InvoiceSavedAddressModel : Codable {
    let status : Int?
    let message : String?
    let data : [InvoiceSavedAddressData]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([InvoiceSavedAddressData].self, forKey: .data)
    }

}
struct InvoiceSavedAddressData : Codable {
    let id : String?
    let business_address : String?
    let selected:Int?
    let business_phone_number : String?
    let website : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case business_address = "business_address"
        case selected = "selected"
        case business_phone_number = "business_phone_number"
        case website = "website"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        business_address = try values.decodeIfPresent(String.self, forKey: .business_address)
        business_phone_number = try values.decodeIfPresent(String.self, forKey: .business_phone_number)
        website = try values.decodeIfPresent(String.self, forKey: .website)
        selected = try values.decodeIfPresent(Int.self, forKey: .selected)

    }

}
