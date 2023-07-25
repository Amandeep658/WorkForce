//
//  ValidateMang.swift
//  WorkForce
//
//  Created by Dharmani Apps on 13/07/23.
//

import Foundation
import UIKit

enum RegularExpessions: String {
    case name = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    case url = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    case age = "^(?:1[0][0]|100|1[8-9]|[2-9][0-9])$"
    case password8AS = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
    case password82US2N3L = "^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}$"
}

class ValidateMang: NSObject {
    
    static let shared = ValidateMang()

    
    //MARK: Private
    
    private func isValid(input: String, matchesWith regex: String) -> Bool {
        let matches = input.range(of: regex, options: .regularExpression)
        return matches != nil
    }
    
    func isValid(text: String, for regex: RegularExpessions) -> Bool {
        
        return isValid(input: text, matchesWith: regex.rawValue)
    }
    
    
    func validateUrl() -> Bool {
      let urlRegEx = "((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
      return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: self)
    }
    
    
}
