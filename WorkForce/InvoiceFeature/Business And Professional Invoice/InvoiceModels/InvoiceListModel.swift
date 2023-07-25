//
//  InvoiceListModel.swift
//  WorkForce
//
//  Created by apple on 28/06/23.
//

import Foundation

struct InvoicelistModel : Codable {
    let status : Int?
    let message : String?
    let data : [InvoiceListData]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([InvoiceListData].self, forKey: .data)
    }

}

struct InvoiceListData : Codable {
    let id : String?
    let invoice_number : String?
    let estimate_no : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case invoice_number = "invoice_number"
        case estimate_no = "estimate_no"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        invoice_number = try values.decodeIfPresent(String.self, forKey: .invoice_number)
        estimate_no = try values.decodeIfPresent(String.self, forKey: .estimate_no)        
    }

}
