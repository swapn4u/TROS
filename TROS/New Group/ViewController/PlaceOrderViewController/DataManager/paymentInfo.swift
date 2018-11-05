//
//  paymentInfo.swift
//  TROS
//
//  Created by Swapnil Katkar on 29/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

struct PaymentInfo
{
    var version : Int
    var paymrntId : String
    var amount : Double
    var created : String
    var method : String
    var providerName : String
    init(dict:[String:Any])
    {
        self.version = dict["__v"] as? Int  ?? 0
        self.paymrntId = dict["_id"] as? String ?? ""
        self.amount = dict["amount"] as? Double ?? 0.0
        self.created = dict["created"] as? String ?? ""
        self.method = dict["method"] as? String ?? ""
        self.providerName = dict["providerName"] as? String ?? ""
    }
}
struct Payment
{
    var method : String
    init(dict:[String:Any])
    {
        method = dict["method"] as? String ?? ""
    }
}
struct Coordinates {
    
}
struct Location {
    var type : String
    var coordinates : [Double]
    init(dict:[String:Any]) {
        type = dict["type"] as? String ?? ""
        coordinates = dict["coordinates"] as? [Double] ?? [0.0,0.0]
    }
    
}
struct Address {
    var line3 : String
    var line2 : String
    var line1 : String
    var location : Location
    init(dict:[String:Any]) {
        line1 = dict["line1"] as? String ?? ""
        line2 = dict["line2"] as? String ?? ""
        line3 = dict["line3"] as? String ?? ""
        location = Location(dict: dict["loc"] as? [String:Any] ?? [:])
    }
}
struct History {
    var event : Int
    var id : String
    var time : String
    var eventMessage : String
    init(dict:[String:Any]) {
        event = dict["event"] as? Int ?? 0
        id = dict["_id"] as? String ?? ""
        time = dict["time"] as? String ?? ""
        eventMessage = dict["eventMessage"] as? String ?? ""
    }
}
struct ItemsInfo {
    var productId : String
    var productName : String
    var quantity : Double
    var history : [History]
    var vendorName : String
    var status : Int
    var cost : Double
    var vendorId : String
    var unit : String
    var count : Int
    var imageUrl : String
    init(dict:[String:Any]) {
        productId = dict["productId"] as? String ?? ""
        productName = dict["productName"] as? String ?? ""
        quantity = dict["quantity"] as? Double ?? 0.0
        vendorName = dict["vendorName"] as? String ?? ""
        status = dict["status"] as? Int ?? 0
        cost = dict["cost"] as? Double ?? 0.0
        vendorId = dict["_id"] as? String ?? ""
        unit = dict["unit"] as? String ?? ""
        count = dict["count"] as? Int ?? 0
        imageUrl = dict["imageUrl"] as? String ?? ""
        let historyArr = dict["history"] as? [[String:Any]] ?? [[String:Any]()]
        history = historyArr.map{History(dict:$0)}
    }
}
struct PlaceOrderStatus
{
    var payment : Payment
    var isComplete : Bool
    var orderID : String
    var created : String
    var isCanceled : Bool
    var address : Address
    var version : String
    var items : [ItemsInfo]
    var rating : Double
    var eligibleVendors : [Any]
    var customerId : String
    init(dict:[String:Any])
    {
        self.payment = Payment(dict:dict["payment"] as? [String:Any] ?? [:])
        self.isComplete = dict["isComplete"] as? Bool ?? false
        self.orderID = dict["_id"] as? String ?? ""
        self.created = dict["created"] as? String ?? ""
        self.isCanceled = dict["isCanceled"] as? Bool ?? false
        address = Address(dict: dict["address"] as? [String:Any] ?? [:])
        version = dict["__v"] as? String ?? ""
        let itemsArr = dict["items"] as? [[String:Any]] ?? [[String:Any]]()
        items = itemsArr.map{ItemsInfo(dict: $0)}
        rating = dict["rating"] as? Double ?? 0.0
        eligibleVendors = dict["eligibleVendors"] as? [Any] ?? [Any]()
        customerId = dict["customerId"] as? String ?? ""
    }
}
