//
//  CategoryList.swift
//  TROS
//
//  Created by Swapnil Katkar on 18/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
struct ProductList {
    var imageHeight : Int
    var cost : Int
    var name : String
    var id : String
    var unit : String
    var imageWidth : Int
    var description : String
    var quantity : Int
    var imageUrl : String
    var brand : String
    init(dict:[String:Any]) {
        print("result \(dict)")
        self.imageHeight = dict["imageHeight"] as? Int ?? 40
        self.cost = dict["cost"] as? Int ?? 0
        self.name = dict["name"] as? String ?? " "
        self.id = dict["_id"] as? String ?? " "
        self.unit = dict["unit"] as? String ?? " "
        self.imageWidth = dict["imageWidth"] as? Int ?? 0
        self.description = dict["description"] as? String ?? " "
        self.quantity = dict["quantity"] as? Int ?? 0
        self.imageUrl = dict["imageUrl"] as? String ?? " "
        self.brand = dict["brand"] as? String ?? " "
    }
}
