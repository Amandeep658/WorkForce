//
//  InvoiceAddAddressdetailModel.swift
//  WorkForce
//
//  Created by apple on 29/06/23.
//

import Foundation

struct InvoiceAddAddressModel : Codable {
    let status : Int?
    let message : String?
    let data : [InvoiceAddAddressData]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([InvoiceAddAddressData].self, forKey: .data)
    }

}
struct InvoiceAddAddressData : Codable {
    let id : String?
    let user_id : String?
    let business_name : String?
    let business_address : String?
    let dial_code : String?
    let business_phone_number : String?
    let website : String?
    let is_invoice : String?
    let estimate_no : String?
    let date : String?
    let created_at : String?
    let update_at : String?
    let customer_address : String?
    let customer_city : String?
    let customer_state : String?
    let customer_country : String?
    let shipping_address : String?
    let shipping_city : String?
    let shipping_state : String?
    let shipping_country : String?
    let invoice_number : String?
    let is_business_address : String?
    let is_customer_address : String?
    let is_shipping_address : String?
    let product_drtails : [Addproduct_drtails]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case invoice_number = "invoice_number"
        case dial_code = "dial_code"
        case business_name = "business_name"
        case business_address = "business_address"
        case business_phone_number = "business_phone_number"
        case website = "website"
        case is_invoice = "is_invoice"
        case estimate_no = "estimate_no"
        case date = "date"
        case created_at = "created_at"
        case update_at = "update_at"
        case customer_address = "customer_address"
        case customer_city = "customer_city"
        case customer_state = "customer_state"
        case customer_country = "customer_country"
        case shipping_address = "shipping_address"
        case shipping_city = "shipping_city"
        case shipping_state = "shipping_state"
        case shipping_country = "shipping_country"
        case is_business_address = "is_business_address"
        case is_customer_address = "is_customer_address"
        case is_shipping_address = "is_shipping_address"
        case product_drtails = "product_drtails"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        invoice_number = try values.decodeIfPresent(String.self, forKey: .invoice_number)
        business_name = try values.decodeIfPresent(String.self, forKey: .business_name)
        dial_code = try values.decodeIfPresent(String.self, forKey: .dial_code)
        business_address = try values.decodeIfPresent(String.self, forKey: .business_address)
        business_phone_number = try values.decodeIfPresent(String.self, forKey: .business_phone_number)
        website = try values.decodeIfPresent(String.self, forKey: .website)
        is_invoice = try values.decodeIfPresent(String.self, forKey: .is_invoice)
        estimate_no = try values.decodeIfPresent(String.self, forKey: .estimate_no)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        update_at = try values.decodeIfPresent(String.self, forKey: .update_at)
        customer_address = try values.decodeIfPresent(String.self, forKey: .customer_address)
        customer_city = try values.decodeIfPresent(String.self, forKey: .customer_city)
        customer_state = try values.decodeIfPresent(String.self, forKey: .customer_state)
        customer_country = try values.decodeIfPresent(String.self, forKey: .customer_country)
        shipping_address = try values.decodeIfPresent(String.self, forKey: .shipping_address)
        shipping_city = try values.decodeIfPresent(String.self, forKey: .shipping_city)
        shipping_state = try values.decodeIfPresent(String.self, forKey: .shipping_state)
        shipping_country = try values.decodeIfPresent(String.self, forKey: .shipping_country)
        is_business_address = try values.decodeIfPresent(String.self, forKey: .is_business_address)
        is_customer_address = try values.decodeIfPresent(String.self, forKey: .is_customer_address)
        is_shipping_address = try values.decodeIfPresent(String.self, forKey: .is_shipping_address)
        product_drtails = try values.decodeIfPresent([Addproduct_drtails].self, forKey: .product_drtails)
    }

}
struct Addproduct_drtails : Codable {
    let id : String?
    let estimate_id : String?
    let user_id : String?
    let item : String?
    let quantity : String?
    let rate : String?
    let amount : String?
    let shipping : String?
    let total : String?
    let created_at : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case estimate_id = "estimate_id"
        case user_id = "user_id"
        case item = "item"
        case quantity = "quantity"
        case rate = "rate"
        case amount = "amount"
        case shipping = "shipping"
        case total = "total"
        case created_at = "created_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        estimate_id = try values.decodeIfPresent(String.self, forKey: .estimate_id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        item = try values.decodeIfPresent(String.self, forKey: .item)
        quantity = try values.decodeIfPresent(String.self, forKey: .quantity)
        rate = try values.decodeIfPresent(String.self, forKey: .rate)
        amount = try values.decodeIfPresent(String.self, forKey: .amount)
        shipping = try values.decodeIfPresent(String.self, forKey: .shipping)
        total = try values.decodeIfPresent(String.self, forKey: .total)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
    }

}
