//
//  PromocodeManager.swift
//  TROS
//
//  Created by Swapnil Katkar on 07/11/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
class PromocodeManager: NSObject {
        class func getPromocodeFor(dict:[String:Any],header:[String:Any],completed:@escaping(Result<PromoCode, ServerError>) ->Void)
        {
            let headers: HTTPHeaders = header as! HTTPHeaders
            let url = BASE_URL + "api/checkPromoCode"
            ServerManager.postRequestWith(url: url, parameter: dict, with: headers){ (result) in
                switch(result)
                {
                case .success(let response):
                    guard let userResponseDict = response.dictionaryObject else {
                        completed(.failure(.unknownError(message: "Something went wrong.", statusCode: 000)))
                        return
                    }
                    let paymetProcessInfo = PromoCode(dict: userResponseDict)
                    completed(.success(paymetProcessInfo))
                    break
                case .failure(let error):
                    completed(.failure(error))
                    break
                }
    
            }
        }
}
