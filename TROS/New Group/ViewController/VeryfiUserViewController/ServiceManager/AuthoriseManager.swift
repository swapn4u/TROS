//
//  AuthoriseManager.swift
//  TROS
//
//  Created by Swapnil Katkar on 20/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class AuthoriseManager: NSObject
{
    class func verifyMobile(dict:[String:Any],completed:@escaping(Result<String, ServerError>) ->Void)
    {
        let url = BASE_URL + "generateOTP"
        ServerManager.postRequestfor(urlString:url, parameter:dict) { (result) in
                switch(result)
                {
                    case .success(let response):
                        guard let _ = response.dictionary else {
                            completed(.failure(.unknownError(message: "Please Enter Valid Mobile Number", statusCode: 000)))
                            return
                        }
                        completed(.success("SMS Sent to your mobile no."))
                    break
                    case .failure(let error):
                        completed(.failure(error))
                        break
                    }
        }
    }
    class func verifyUser(dict:[String:Any],completed:@escaping(Result<Bool, ServerError>) ->Void)
    {
        let url = BASE_URL + "checkUserExist"
        ServerManager.postRequestfor(urlString:url, parameter:dict) { (result) in
                switch(result)
                {
                case .success(let response):
                    guard let isExistingUser = (response.dictionaryObject)?["exists"] as? Bool else {
                        completed(.failure(.unknownError(message: "Please Enter Valid Mobile Number", statusCode: 000)))
                        return
                    }
                      completed(.success(isExistingUser))
                    
                    break
                case .failure(let error):
                    completed(.failure(error))
                    break
                }
                
        }
    }
    class func verifyOTP(dict:[String:Any],completed:@escaping(Result<Bool, ServerError>) ->Void)
    {
        let url = BASE_URL + "verifyUserOTP"
        ServerManager.postRequestfor(urlString:url, parameter:dict) { (result) in
            switch(result)
            {
            case .success(let response):
                guard let isExistingUser = (response.dictionaryObject)?["exists"] as? Bool else {
                    completed(.failure(.unknownError(message: "Please Enter Valid Mobile Number", statusCode: 000)))
                    return
                }
                completed(.success(isExistingUser))
                
                break
            case .failure(let error):
                completed(.failure(error))
                break
            }
            
        }
    }
}
