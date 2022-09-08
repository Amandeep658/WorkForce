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
        jobTypes.append(JobTypeModel(title : "Full Time".localized(), isSelected : false))
        jobTypes.append(JobTypeModel(title : "Part Time".localized(), isSelected : true))
        jobTypes.append(JobTypeModel(title : "Contract".localized(), isSelected : false))
        jobTypes.append(JobTypeModel(title : "Freelance".localized(), isSelected : true))
        jobTypes.append(JobTypeModel(title : "Remote".localized(), isSelected : false))
    } 
    
}
