//
//  SingletonInvoice.swift
//  WorkForce
//
//  Created by apple on 28/06/23.
//

import Foundation
struct InvoiceCreateModel: Decodable{
    var business_name:String?
    var business_address: String?
    var business_phone_number: String?
    var website: String?
    var estimate_no: String?
    var date: String?
    var customer_address: String?
    var customer_city: String?
    var customer_state: String?
    var customer_country: String?
    var shipping_address: String?
    var shipping_city: String?
    var shipping_state: String?
    var shipping_country: String?
    var product : [AddProductItemModel]?
    
    func convertModelToDict()->NSMutableDictionary{
        let dict = NSMutableDictionary()
        dict.setValue(self.business_name, forKey: "business_name")
        dict.setValue(self.business_address, forKey: "business_address")
        dict.setValue(self.business_phone_number, forKey: "business_phone_number")
        dict.setValue(self.website, forKey: "website")
        dict.setValue(self.estimate_no, forKey: "estimate_no")
        dict.setValue(self.date, forKey: "date")
        dict.setValue(self.customer_address, forKey: "customer_address")
        dict.setValue(self.customer_city, forKey: "customer_city")
        dict.setValue(self.customer_state, forKey: "customer_state")
        dict.setValue(self.customer_country, forKey: "customer_country")
        dict.setValue(self.shipping_address, forKey: "shipping_address")
        dict.setValue(self.shipping_state, forKey: "shipping_state")
        dict.setValue(self.shipping_country, forKey: "shipping_country")
        if self.product != nil{
            var catagoryArray = [NSMutableDictionary]()
            for dict in self.product!{
                catagoryArray.append(dict.convertDict())
            }
            dict.setValue(catagoryArray, forKey: "product")
        }
        print(dict)
        return dict
    }
}
