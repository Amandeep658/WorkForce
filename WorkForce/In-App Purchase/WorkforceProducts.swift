//
//  WorkforceProducts.swift
//  WorkForce
//
//  Created by Aman's MacBookPro on 28/07/22.
//

import Foundation

public struct WorkforceProducts {
  public static let subscription50DollarSixmonth = "U2CONNECT_HANDLER"
  public static let subscription20DollarSixmonth = "U2CONNECTIOS_HANDLER"
  
  private static let productIdentifiers50Dollar: Set<ProductIdentifier> = [WorkforceProducts.subscription50DollarSixmonth]
  private static let productIdentifiers20Dollar: Set<ProductIdentifier> = [WorkforceProducts.subscription20DollarSixmonth]

  public static let store50 = IAPHelper(productIds: WorkforceProducts.productIdentifiers50Dollar)
  public static let store20 = IAPHelper(productIds: WorkforceProducts.productIdentifiers20Dollar)
}

