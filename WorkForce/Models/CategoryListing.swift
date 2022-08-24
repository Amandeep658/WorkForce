//
//  CategoryListing.swift
//  WorkForce
//
//  Created by apple on 28/06/22.
//

import Foundation

struct ApiModel<T:Decodable>: Decodable {
    let status : Int?
    let message : String?
    let data : T?
}

struct CategoryData : Decodable {
    var category_id : String?
    var category_name : String?
    var user_id : String?
    var experience : String?
    var jobId: Int?
    var customer_job_id : String?
    var id : String?
    var job_id : String?
    var isSelected:Bool?
    var is_delete : String?
    var cat_id: String?
    func convertModelToDict()->NSMutableDictionary{
        let dict = NSMutableDictionary()
        if self.experience != nil{
            dict.setValue(self.experience, forKey: "experience")
        }
        else{
            dict.setValue("0", forKey: "experience")
        }
        dict.setValue(self.jobId, forKey: "job_id")
        dict.setValue(self.customer_job_id, forKey: "customer_job_id")
        dict.setValue(self.id, forKey: "id")
        dict.setValue(self.cat_id, forKey: "cat_id")
        dict.setValue(self.user_id, forKey: "user_id")
        dict.setValue(self.is_delete, forKey: "is_delete")
        dict.setValue(self.job_id, forKey: "job_id")
        dict.setValue(self.category_name, forKey: "category_name")
        return dict
    }
}
