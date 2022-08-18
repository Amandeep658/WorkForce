//
//  UserType.swift
//  WorkForce
//
//  Created by Dharmani Apps on 17/05/22.
//

import Foundation

enum UserLogin{
    case Bussiness
    case Professional
    case Coustomer
}

class UserType{
    static let userTypeInstance = UserType()
    var userLogin:UserLogin?
}


