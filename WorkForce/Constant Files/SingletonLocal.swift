//
//  Singleton.swift
//  WorkForce
//
//  Created by apple on 29/06/22.
//

import Foundation
struct SingletonLocalModel: Decodable{
    var userId: String?
    var customer_job_id: String?
    var username: String?
    var type: String?
    var first_name: String?
    var last_name: String?
    var date_of_birth: String?
    var catagory_details: [CategoryData]?
    var rate_from: String?
    var rate_to: String?
    var rate_type: String?
    var photo: String?
    var job_image: String?
    var location: String?
    var city: String?
    var state: String?
    var description: String?
    var job_type: String?
    var latitude: String?
    var job_id: String?
    var longitude: String?
    
    func convertModelToDict()->NSMutableDictionary{
        let dict = NSMutableDictionary()
        dict.setValue(self.userId, forKey: "user_id")
        dict.setValue(self.customer_job_id, forKey: "customer_job_id")
        dict.setValue(self.first_name, forKey: "first_name")
        dict.setValue(self.username, forKey: "username")
        dict.setValue(self.job_id, forKey: "job_id")
        dict.setValue(self.type, forKey: "type")
        dict.setValue(self.last_name, forKey: "last_name")
        dict.setValue(self.date_of_birth, forKey: "date_of_birth")
        dict.setValue(self.rate_from, forKey: "rate_from")
        dict.setValue(self.rate_to, forKey: "rate_to")
        dict.setValue(self.rate_type, forKey: "rate_type")
        dict.setValue(self.city, forKey: "city")
        dict.setValue(self.location, forKey: "location")
        dict.setValue(self.state, forKey: "state")
        dict.setValue(self.description, forKey: "description")
        dict.setValue(self.photo, forKey: "photo")
        dict.setValue(self.job_image, forKey: "job_image")
        dict.setValue(self.job_type, forKey: "job_type")
        dict.setValue(self.latitude, forKey: "latitude")
        dict.setValue(self.longitude, forKey: "longitude")
        if self.catagory_details != nil{
            var catagoryArray = [NSMutableDictionary]()
            for dict in self.catagory_details!{
                catagoryArray.append(dict.convertModelToDict())
            }
            dict.setValue(catagoryArray, forKey: "catagory_details")
        }
        print(dict)
        return dict
    }
}
