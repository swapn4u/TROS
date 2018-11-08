//
//  File.swift
//  TROS
//
//  Created by Swapnil Katkar on 07/11/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
struct PromoCode
{
    var version : Int
    var Id : String
    var created : String
    var discount : Int
    var expiry : String
    var promoCode : String
    var providerName : String
    init(dict:[String:Any])
    {
        self.version = dict["__v"] as? Int ?? 0
        self.Id = dict["_id"] as? String ?? ""
        self.created = dict["created"] as? String ?? ""
        self.discount = dict["discount"] as? Int ?? 0
        self.expiry = dict["expiry"] as? String ?? ""
        self.promoCode = dict["promoCode"] as? String ?? ""
        self.providerName = dict["providerName"] as? String ?? ""
    }
}
