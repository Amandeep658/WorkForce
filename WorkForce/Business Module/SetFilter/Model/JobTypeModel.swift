//
//  JobTypeModel.swift
//  WorkForce
//
//  Created by apple on 10/05/22.
//

import UIKit

class JobTypeModel: NSObject {
    var title : String?
    var isSelected : Bool?
    
    
    init(title : String?, isSelected : Bool?) {
        self.title = title
        self.isSelected = isSelected
    }
}
