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
    let country_code:String?
    let dial_code:String?
    let business_phone_number : String?
    let website : String?
    let customer_address: String?
    let customer_city:String?
    let customer_country: String?
    let customer_state: String?
    let shipping_address: String?
    let shipping_city: String?
    let shipping_country: String?
    let shipping_state: String?
    

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case business_address = "business_address"
        case selected = "selected"
        case country_code = "country_code"
        case dial_code = "dial_code"
        case business_phone_number = "business_phone_number"
        case website = "website"
        case customer_address = "customer_address"
        case customer_city = "customer_city"
        case customer_country = "customer_country"
        case customer_state = "customer_state"
        case shipping_address = "shipping_address"
        case shipping_city = "shipping_city"
        case shipping_country = "shipping_country"
        case shipping_state = "shipping_state"



    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        business_address = try values.decodeIfPresent(String.self, forKey: .business_address)
        country_code = try values.decodeIfPresent(String.self, forKey: .country_code)

        dial_code = try values.decodeIfPresent(String.self, forKey: .dial_code)
        business_phone_number = try values.decodeIfPresent(String.self, forKey: .business_phone_number)
        website = try values.decodeIfPresent(String.self, forKey: .website)
        selected = try values.decodeIfPresent(Int.self, forKey: .selected)
        customer_address = try values.decodeIfPresent(String.self, forKey: .customer_address)
        customer_city = try values.decodeIfPresent(String.self, forKey: .customer_city)
        customer_country = try values.decodeIfPresent(String.self, forKey: .customer_country)
        customer_state = try values.decodeIfPresent(String.self, forKey: .customer_state)
        shipping_address = try values.decodeIfPresent(String.self, forKey: .shipping_address)
        shipping_city = try values.decodeIfPresent(String.self, forKey: .shipping_city)
        shipping_country = try values.decodeIfPresent(String.self, forKey: .shipping_country)
        shipping_state = try values.decodeIfPresent(String.self, forKey: .shipping_state)
    }

}
