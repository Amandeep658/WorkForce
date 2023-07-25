//
//  Validator.swift
//  CullintonsCustomer
//
//  Created by Rakesh Kumar on 03/04/18.
//  Copyright © 2018 Rakesh Kumar. All rights reserved.
//

import UIKit
enum RegularExpressions: String {
    case name = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    case url = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    case age = "^(?:1[0][0]|100|1[8-9]|[2-9][0-9])$"
    case password8AS = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
    case password82US2N3L = "^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}$"
}

class Validator {
    
    static public func validateEmail(candidate: String) -> (Bool,String) {
        guard candidate.count > 0  else {
            return (false, "Please enter email")
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let isValid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
        return (isValid, "Please enter valid email")
    }
    
    static public func validateAccountId(id:String) -> Bool {
        let regex = "^[a-z-A-Z]{6}+[0-9]{2}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: id)
    }
    
    static public func validateName(name: String,message: String) -> (Bool,String) {
        guard name.count > 0  else {
            return (false,message)
        }
        return (true,message)
    }
    
    static public func validateUserName(userName: String) -> Bool {
        guard userName != "" else {
            return false
        }
        return true
    }
    
    static public func validatePhoneNumber(number: String?) -> (Bool,String) {
        guard let phone = number, phone.count > 0  else {
            return (false,"Please enter phone number")
        }
        
        guard phone.count > 6 && phone.count < 14 else {
            return (false,"Please enter valid phone number")
        }
        
        return (true,"")
    }
    
    static public func validatePassword(password:String?) -> (Bool,String) {
        guard let pwd = password, pwd.count > 0 else {
            return (false,"Please enter your password")
        }
        guard pwd.count >= 6 else {
            return (false, "Password should be 6 characters long")
        }
        return (true,"Please enter valid password")
    }
    
    //MARK: Private
    
    private func isValid(input: String, matchesWith regex: String) -> Bool {
        let matches = input.range(of: regex, options: .regularExpression)
        return matches != nil
    }
    
    
    func isValid(text: String, for regex: RegularExpressions) -> Bool {
        return isValid(input: text, matchesWith: regex.rawValue)
    }
    
    
}
