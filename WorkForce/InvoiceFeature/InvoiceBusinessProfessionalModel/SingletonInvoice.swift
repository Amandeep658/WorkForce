//
//  SingletonInvoice.swift
//  WorkForce
//
//  Created by apple on 28/06/23.
//

import Foundation
struct InvoiceCreateModel: Decodable{
    var business_name:String?
    var invoice_number:String?
    var business_address: String?
    var country_code:String?
    var dial_code:String?
    var business_phone_number: String?
    var is_business_address:String?
    var website: String?
    var estimate_no: String?
    var date: String?
    var customer_address: String?
    var customer_city: String?
    var customer_state: String?
    var customer_country: String?
    var is_customer_address: String?
    var shipping_address: String?
    var shipping_city: String?
    var shipping_state: String?
    var shipping_country: String?
    var is_shipping_address: String?
    var shipping:String?
    var total:String?
    var product : [AddProductItemModel]?
    
    func convertModelToDict()->NSMutableDictionary{
        let dict = NSMutableDictionary()
        dict.setValue(self.business_name, forKey: "business_name")
        dict.setValue(self.invoice_number, forKey: "invoice_number")
        dict.setValue(self.business_address, forKey: "business_address")
        dict.setValue(self.dial_code, forKey: "dial_code")
        dict.setValue(self.country_code, forKey: "country_code")
        dict.setValue(self.business_phone_number, forKey: "business_phone_number")
        dict.setValue(self.is_business_address, forKey: "is_business_address")
        
        dict.setValue(self.website, forKey: "website")
        dict.setValue(self.estimate_no, forKey: "estimate_no")
        dict.setValue(self.date, forKey: "date")
        
        dict.setValue(self.customer_address, forKey: "customer_address")
        dict.setValue(self.customer_city, forKey: "customer_city")
        dict.setValue(self.customer_state, forKey: "customer_state")
        dict.setValue(self.customer_country, forKey: "customer_country")
        dict.setValue(self.is_customer_address, forKey: "is_customer_address")
        
        dict.setValue(self.shipping_address, forKey: "shipping_address")
        dict.setValue(self.shipping_state, forKey: "shipping_state")
        dict.setValue(self.shipping_country, forKey: "shipping_country")
        dict.setValue(self.is_shipping_address, forKey: "is_shipping_address")
        dict.setValue(self.shipping, forKey: "shipping")
        dict.setValue(self.total, forKey: "total")

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

