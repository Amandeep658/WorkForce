//
//  AddProductItemModel.swift
//  WorkForce
//
//  Created by apple on 27/06/23.
//

import Foundation
import UIKit

struct AddProductItemModel:Decodable{
    var item:String?
    var quantity:String?
    var rate:String?
    var amount:String?
    var shipping:String?
    var total:String?


    private enum CodingKeys : String, CodingKey {
        case item = "item",quantity = "quantity",rate = "rate",amount = "amount",shipping = "shipping",total = "total"
    }

    func convertDict()-> NSMutableDictionary{
        let dict = NSMutableDictionary()
        dict.setValue(self.item, forKey: "item")
        dict.setValue(self.quantity, forKey: "quantity")
        dict.setValue(self.rate, forKey: "rate")
        dict.setValue(self.amount, forKey: "amount")
        dict.setValue(self.shipping, forKey: "shipping")
        dict.setValue(self.total, forKey: "total")

        return dict
    }
}
