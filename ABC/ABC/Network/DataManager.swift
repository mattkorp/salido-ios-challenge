//
//  DataManager.swift
//  ABC
//
//  Created by Matthew Korporaal on 4/1/15.
//  Copyright (c) 2015 Matthew Korporaal. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DataManager {
    
    /**
    Makes HTTP request to wine api to retrieve categories,
    if it has not been done so already and returns them in a
    completion block when ready.
    
    :param: completion handler is returned on main thread when ready
    with Wine category data and NSError, both optionals.
    */
    class func retrieveCategories(completion: (Wine?, NSError?) -> ()) {
        if LocalCache.categoryData == nil {
            var request = Router.GetCategoriesRequest(nil)
            Alamofire.request(request).responseJSON { request, response, data, error in
                dispatch_async(dispatch_get_main_queue()) {
                    if let e = error {
                        completion(nil, e)
                    } else {
                        if let r = response {
                            if r.statusCode == 200 {
                                LocalCache.categoryData = Wine(json: SwiftyJSON.JSON(data as NSDictionary))
                                completion(LocalCache.categoryData, nil)
                            } else {
                                let error = NSError(domain: "HTTPError", code: r.statusCode, userInfo: nil)
                                completion(nil, error)
                            }
                        }
                    }
                }
            }
        } else {
            completion(LocalCache.categoryData, nil)
        }
    }
    
    /**
    Makes a catalog search based on category id and returns an array of chosen products.
    
    :param: id         category id
    :param: page       page or offset
    :param: completion handler with optional array of products and optional NSError
    */
    class func searchCatalog(id: Int, page: Int, completion: ([Product]?, NSError?) -> ()) {
        var products = [Product]()
        var request = Router.SearchCatalog(id, page)
        Alamofire.request(request).responseJSON { request, response, data, error in
            dispatch_async(dispatch_get_main_queue()) {
                if let e = error {
                    completion(nil, e)
                } else {
                    if let r = response {
                        if r.statusCode == 200 {
                            let json = SwiftyJSON.JSON(data as NSDictionary)
                            for (index: String, productInfo: SwiftyJSON.JSON) in json["Products"]["List"] {
                                products.append(Product(json: productInfo))
                            }
                            completion(products, nil)
                        } else {
                            let error = NSError(domain: "HTTPError", code: r.statusCode, userInfo: nil)
                            completion(nil, error)
                        }
                    }
                }
            }
        }
    }
    
    class func postUserCart() -> [String: AnyObject] { // completion: NSDictionary? -> ()) {
        let parameters = LocalCache.user.getDictionaryValues()
        let request = Router.PostUserData(parameters)
        return parameters
        
        // POST request here
    }
}