//
//  CommonUtlity.swift
//  TROS
//
//  Created by Swapnil Katkar on 01/11/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import CoreTelephony
import SystemConfiguration
class CommonUtlity: NSObject
{
    static let sharedInstance = CommonUtlity()
    static var Flag_PlaceOrderHelper = Bool()
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    func getUserId() -> String
    {
        if let userData = UserDefaults.standard.value(forKey:"UserInfo") as? Data {
            let userinfo = try? PropertyListDecoder().decode(LoginUserDetails.self, from: userData)
            return userinfo?.user.id ?? ""
        }
        return ""
    }
    
}
