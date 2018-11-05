//
//  ViewOrederManager.swift
//  TROS
//
//  Created by Swapnil Katkar on 31/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
class ViewOrederManager: NSObject {

    class func getOrderInfoFor(orderId:String,completed:@escaping(Result<PlaceOrderStatus, ServerError>) ->Void)
    {
        let url = BASE_URL + "order/\(orderId)"
        ServerManager.getRequestfor(urlString: url){ (result) in
            switch result
            {
            case .success(let response):
                guard let userResponseDict = response.dictionaryObject else {
                    completed(.failure(.unknownError(message: "Somthing went wrong", statusCode: 000)))
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
    class func canceOrderInfoFor(orderId:String,header:[String:Any],completed:@escaping(Result<PlaceOrderStatus, ServerError>) ->Void)
    {
        let url = BASE_URL + "api/cancel/\(orderId)"
        let headers: HTTPHeaders = header as! HTTPHeaders
        ServerManager.getRequestfor(urlString:url , with: headers) { (result) in
            switch result
            {
            case .success(let response):
                guard let userResponseDict = response.dictionaryObject else {
                    completed(.failure(.unknownError(message: "Somthing went wrong", statusCode: 000)))
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
//    class func canceOrderFor(dict:[String:Any],header:[String:Any],completed:@escaping(Result<PlaceOrderStatus, ServerError>) ->Void)
//    {
//        let headers: HTTPHeaders = header as! HTTPHeaders
//        let url = BASE_URL + "api/cancel_order"
//        ServerManager.postRequestWith(url: url, parameter: dict, with: headers){ (result) in
//            switch(result)
//            {
//            case .success(let response):
//                guard let userResponseDict = response.dictionaryObject else {
//                    completed(.failure(.unknownError(message: "Please Enter Valid Mobile Number", statusCode: 000)))
//                    return
//                }
//                let paymetProcessInfo = PlaceOrderStatus(dict: userResponseDict)
//                completed(.success(paymetProcessInfo))
//                break
//            case .failure(let error):
//                completed(.failure(error))
//                break
//            }
//
//        }
//    }
    class func rateOrderInfoFor(orderId:String,dict:[String:Any],header:[String:Any],completed:@escaping(Result<PlaceOrderStatus, ServerError>) ->Void)
    {
        let url = BASE_URL + "api/rateOrder/\(orderId)"
        let headers: HTTPHeaders = header as! HTTPHeaders
        ServerManager.postRequestWith(url: url, parameter: dict, with: headers){ (result) in
            switch(result)
            {
            case .success(let response):
                guard let userResponseDict = response.dictionaryObject else {
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
