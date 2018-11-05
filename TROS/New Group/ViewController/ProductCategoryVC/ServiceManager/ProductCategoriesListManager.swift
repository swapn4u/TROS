//
//  ProductCategoriesListManager.swift
//  TROS
//
//  Created by Swapnil Katkar on 18/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class ProductCategoriesListManager: NSObject {
    
    class func loadCategoaryForProduct(productId:String,pageCount:Int,completed:@escaping(Result<[ProductList], ServerError>) ->Void)
    {
        let url = BASE_URL + "products?lat=19.136326&lon=72.827660&category=\(productId)&page=\(pageCount)&chunk=15"
        ServerManager.getRequestfor(urlString: url){ (result) in
            switch result
            {
            case .success(let response):
                guard let responseDictArr = response.arrayObject as? [[String:Any]] else {
                    
                    completed(.failure(.unknownError(message: NO_DATA_AVAILABLE_MSG, statusCode: 000)))
                    return
                }
                if responseDictArr.isEmpty
                {
                    completed(.failure(.unknownError(message: NO_DATA_AVAILABLE_MSG, statusCode: 000)))
                }
                else
                {
                    let ProductListMapperResult  = responseDictArr.compactMap{ProductList(dict: $0)}
                    completed(.success(ProductListMapperResult))
                }
                break
                
            case .failure(let error):
                completed(.failure(error))
                break
            }
            
        }
    }
    //getBaseUrl() + "products?lat=" + latitude + "&lon=" + longitude + "&search=" + search + "&category=" + category;
    class func getSearchResultFor(searchText:String,category:Int,completed:@escaping(Result<[ProductList], ServerError>) ->Void)
    {
        let url = BASE_URL + "products?lat=19.136326&lon=72.827660&search=\(searchText)&category=\(category)".replacingOccurrences(of: " ", with: "%20")
        ServerManager.getRequestfor(urlString: url){ (result) in
            switch result
            {
            case .success(let response):
                guard let responseDictArr = response.arrayObject as? [[String:Any]] else {
                    
                    completed(.failure(.unknownError(message: NO_DATA_AVAILABLE_MSG, statusCode: 000)))
                    return
                }
                if responseDictArr.isEmpty
                {
                    completed(.failure(.unknownError(message: NO_DATA_AVAILABLE_MSG, statusCode: 000)))
                }
                else
                {
                    let ProductListMapperResult  = responseDictArr.compactMap{ProductList(dict: $0)}
                    completed(.success(ProductListMapperResult))
                }
                break
                
            case .failure(let error):
                completed(.failure(error))
                break
            }
            
        }
    }
}

