//
//  serviceModel.swift
//  MVVMDemo
//
//  Created by webwerks on 05/02/18.
//  Copyright © 2018 webwerks. All rights reserved.
//

import UIKit
import Alamofire

enum Result<ValueType, ErrorType> {
    case success(ValueType)
    case failure(ErrorType)
}
enum ServerError {
    case noError
    case noInternetConnection(message: String, statusCode: Int)
    case unknownError(message: String, statusCode: Int)
    case requestTimeOut(message: String)
    case noDataAvailable(message: String)
    
    func getErrorMessage() -> String {
        switch self {
        case .noInternetConnection(let message, _): return message
        case .unknownError(let message, _): return message
        case .requestTimeOut(let message): return message
        case .noDataAvailable(let message): return message
        case .noError:
            break
        }
        return ""
    }
}
class ServerManager: NSObject
{
    func getProductforService(ServiceName: String, finished: @escaping ([String:Any]?,Error?) -> ()) {
        // set up web service url
        let url = URL(string: "\(ServiceName)")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"

        let dataTask = URLSession.shared.dataTask(with: request)
        {  (data, response, error) in
            if error == nil
            {
                // finished(nil, error)
                
                guard let data = data, let jsondata = try? JSONSerialization.jsonObject(with: data, options: []) as! [String : Any] else{
                    print("error while fetching data")
                    return
                }
                print(jsondata)
                finished(jsondata,error)
            }
            else
            {
                finished(nil, error)
            }
        }
        dataTask.resume()
    }
    
    class func getRequestfor(urlString:String,closure: @escaping (Result<JSON, ServerError>) -> Void)
    {
        Alamofire.request(urlString, method: .get, encoding: JSONEncoding.default)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                
                return .success
            }
            .responseJSON { response in
                debugPrint(response)
                switch response.result {
                case .success:
                    let resJson = JSON(response.result.value!)
                    closure(Result.success(resJson))
                case .failure(let error):
                    if error._code == NSURLErrorTimedOut {
                        closure(Result.failure(ServerError.requestTimeOut(message: "Request Time Out")))
                    }else {
                        
                        closure(Result.failure(ServerError.unknownError(message: error.localizedDescription, statusCode: 000)))
                    }
                }
        }
    }
    
    
    
    class func postRequestfor(urlString:String,parameter:[String:Any],closure: @escaping (Result<JSON, ServerError>) -> Void)
    {
        
        Alamofire.request(urlString, method: .post, parameters: parameter, encoding: JSONEncoding.default,headers:["Content-Type":"application/json"])
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                
                return .success
            }
            .responseJSON { response in
                debugPrint(response)
                switch response.result {
                case .success:
                    let resJson = JSON(response.result.value!)
                    closure(Result.success(resJson))
                case .failure(let error):
                    if error._code == NSURLErrorTimedOut {
                        closure(Result.failure(ServerError.requestTimeOut(message: "Request Time Out")))
                    }else {
                        
                        closure(Result.failure(ServerError.unknownError(message: error.localizedDescription, statusCode: 000)))
                    }
                }
        }
    }
    
    var image_cache = NSCache<AnyObject, AnyObject>()
    
    func imageDownloadManager(path : String?, imageView : UIImageView)  {
        
        DispatchQueue.main.async {
            if let path = path {
                if let img = self.image_cache.object(forKey: path as AnyObject) as? UIImage {
                    imageView.image = img
                    return
                }
                
                guard let url = URL.init(string : path) else { return }
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    guard let data = data , error == nil , response != nil else {
                        return
                    }
                    DispatchQueue.main.async {
                        let img = UIImage(data: data)
                        imageView.image = img
                        self.image_cache.setObject(img as AnyObject, forKey: path as AnyObject)
                    }
                    
                }).resume()
                
            }
        }
        
    }
    
}
