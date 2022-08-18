//
//  Data+Custom.swift
//  CullintonsCustomer
//
//  Created by Rakesh Kumar on 04/04/18.
//  Copyright © 2018 Rakesh Kumar. All rights reserved.
//

import UIKit

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
    
    func getFormatSize(style: ByteCountFormatter.Units) -> String {
        print("There were \(self.count) bytes")
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [style]
        // optional: restricts the units to MB only
        bcf.countStyle = .file
        let string = bcf.string(fromByteCount: Int64(self.count))
        print("formatted result: \(string)")
        return string
    }
    
}

extension URL {
    var data:Data? {
        do {
            return try Data(contentsOf: self)
        } catch {
            return nil
        }
    }
    
    var canOpen: Bool {
        return UIApplication.shared.canOpenURL(self)
    }
    
}

extension Double {
    var inString:String {
        return "\("\(self.rounded())".dropLast(2))"
    }
    
    var inInt: Int {
        return Int(self)
    }
    
}




extension UILabel {
    open func setText(number:Double?) {
        if let num = number {
            self.text = num.inString
        } else {
            self.text = ""
        }
    }
}

extension UITextField {
    open func setText(number:Double?) {
        if let num = number {
            self.text = num.inString
        } else {
            self.text = ""
        }
    }
}
