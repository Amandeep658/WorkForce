//
//  SetFilterVM.swift
//  WorkForce
//
//  Created by apple on 10/05/22.
//

import UIKit

class SetFilterVM: NSObject {
    var jobTypes : [JobTypeModel] = []
    
    
    func setJobs(){
        jobTypes.append(JobTypeModel(title : "Full Time", isSelected : false))
        jobTypes.append(JobTypeModel(title : "Part Time", isSelected : true))
        jobTypes.append(JobTypeModel(title : "Contract", isSelected : false))
        jobTypes.append(JobTypeModel(title : "Freelance", isSelected : true))
        jobTypes.append(JobTypeModel(title : "Remote", isSelected : false))
    } 
    
}
