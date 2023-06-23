//
//  S
//  Comepriceshop
//
//  Created by Click Labs on 6/23/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

import Foundation


import SystemConfiguration

public enum IJReachabilityType {
  case wwan,
  wiFi,
  notConnected
}

open class IJReachability {
  
  /**
  :see: Original post - http://www.chrisdanielson.com/2009/07/22/iphone-network-connectivity-test-example/
  */
  open class func isConnectedToNetwork() -> Bool {
    
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET) 
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    
    var flags = SCNetworkReachabilityFlags.connectionAutomatic
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
        return false
    }
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    return (isReachable && !needsConnection)
    
  }
  
}
