//
//  UserDataModel.swift
//  TROS
//
//  Created by Swapnil Katkar on 23/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

//
//  LoginUserDetails.swift
//  MOSL
//
//  Created by Swapnil Katkar on 24/10/18.
//  Copyright © 2018 MOFSL. All rights reserved.
//

import UIKit


struct LoginUserDetails : Codable{
    var token : String
    var user : UserDetails
    var verified : Bool
    init(dict:[String:Any]) {
        self.token = dict["token"] as? String ?? ""
        let userInfo = dict["user"] as? [String:Any] ?? [String:Any]()
        self.user = UserDetails(dict:userInfo)
        self.verified = dict["verified"] as? Bool ?? false
    }
}
struct UserDetails : Codable
{
    var id : String
    var address : [String]
    var contact : ContactDetails
    var created : String
    var displayName : String
    var email : String
    var fcmToken : String
    var firstName : String
    var isActive : Bool
    var isOnline : Bool
    var lastLogin : String
    var lastName : String
    var middleName : String
    var mobileToken : String
    var orders :  [Orders]
    var profilePic : String
    var versionCode : Int
    var versionName : String
    init(dict:[String:Any])
    {
        self.id = dict["_id"] as? String ?? ""
        self.created = dict["created"] as? String ?? ""
        self.address = dict["address"] as? [String] ?? [String]()
        self.contact = ContactDetails(dict:dict["contact"] as? [String:Any] ?? [String:Any]())
        self.displayName = dict["displayName"] as? String ?? ""
        self.email = dict["email"] as? String ?? ""
        self.fcmToken = dict["fcmToken"] as? String ?? ""
        self.firstName = dict["firstName"] as? String ?? ""
        self.isActive = dict["isActive"] as? Bool ?? false
        self.isOnline = dict["isOnline"] as? Bool ?? false
        self.lastLogin = dict["lastLogin"] as? String ?? ""
        self.lastName = dict["lastName"] as? String ?? ""
        self.middleName = dict["middleName"] as? String ?? ""
        self.mobileToken = dict["mobileToken"] as? String ?? ""
        self.profilePic = dict["profilePic"] as? String ?? ""
        let orders = dict["orders"] as? [[String:Any]] ?? [[String:Any]]()
        self.orders = orders.map{Orders(dict: $0)}
        self.versionCode = dict["versionCode"] as? Int ?? 0
        self.versionName = dict["versionName"] as? String ?? ""
    }
    
}
struct ContactDetails : Codable
{
    var dialCode : String
    var mobile : String
    init(dict:[String:Any]) {
        self.dialCode = dict["dialCode"] as? String ?? ""
        self.mobile = dict["mobile"] as? String ?? ""
    }
    
}
struct Orders : Codable
{
    init(dict:[String:Any]) {
        
    }
}

