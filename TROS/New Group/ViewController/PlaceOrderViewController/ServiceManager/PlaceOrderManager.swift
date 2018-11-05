//
//  PlaceOrderManager.swift
//  TROS
//
//  Created by Swapnil Katkar on 29/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
class PlaceOrderManager: NSObject {
    class func getPaymentIdFor(dict:[String:Any],header:[String:Any],completed:@escaping(Result<PaymentInfo, ServerError>) ->Void)
    {
        let headers: HTTPHeaders = header as! HTTPHeaders
        let url = BASE_URL + "api/payment"
        ServerManager.postRequestWith(url: url, parameter: dict, with: headers){ (result) in
            switch(result)
            {
            case .success(let response):
                guard let userResponseDict = response.dictionaryObject as? [String:Any] else {
                    completed(.failure(.unknownError(message: "Please Enter Valid Mobile Number", statusCode: 000)))
                    return
                }
                let paymetInfo = PaymentInfo(dict: userResponseDict)
                 completed(.success(paymetInfo))
                break
            case .failure(let error):
                completed(.failure(error))
                break
            }
            
        }
    }
    class func placeOrderFor(dict:[String:Any],header:[String:Any],completed:@escaping(Result<PlaceOrderStatus, ServerError>) ->Void)
    {
        let headers: HTTPHeaders = header as! HTTPHeaders
        let url = BASE_URL + "api/order"
        ServerManager.postRequestWith(url: url, parameter: dict, with: headers){ (result) in
            switch(result)
            {
            case .success(let response):
                guard let userResponseDict = response.dictionaryObject as? [String:Any] else {
                    completed(.failure(.unknownError(message: "Please Enter Valid Mobile Number", statusCode: 000)))
                    return
                }
                let paymetProcessInfo = PlaceOrderStatus(dict: userResponseDict)
                 completed(.success(paymetProcessInfo))
                break
            case .failure(let error):
                completed(.failure(error))
                break
            }
            
        }
    }
}
