//
//  Router.swift
//  ABC
//
//  Created by Matthew Korporaal on 4/1/15.
//  Copyright (c) 2015 Matthew Korporaal. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    static let baseURLString = "http://services.wine.com/api/beta2/service.svc/JSON"
    static let abcAPIKey = "2cc09506033429735061648e1c3f01b4"
    static let perPage = 10
    
    case GetCategoriesRequest([String: AnyObject]?)
    case SearchCatalog(Int, Int)
    
    var path: String {
        switch self {
        case .GetCategoriesRequest: return "/categoryMap"
        case .SearchCatalog: return "/catalog"
        }
    }
    
    var URLRequest: NSURLRequest {
        let URL = NSURL(string: Router.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        
        switch self {
        case .GetCategoriesRequest(let parameters):
            let parameters = ["apikey": Router.abcAPIKey, "filter": "categories(490)"]
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .SearchCatalog(let id, let page):
            let parameters = ["apikey": Router.abcAPIKey, "filter": "categories(490+\(id))", "offset": "\(page*Router.perPage)"]
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
    
}