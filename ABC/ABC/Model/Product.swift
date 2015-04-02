//
//  Product.swift
//  ABC
//
//  Created by Matthew Korporaal on 4/1/15.
//  Copyright (c) 2015 Matthew Korporaal. All rights reserved.
//

import Foundation
import SwiftyJSON

class Product {
    
    var id: Int!
    var name: String!
    var region: String!
    var label: NSURL!
    var varietal: String!
    var vineyard: String!
    var vintage: String!
    var priceMin: Double!
    var priceMax: Double!
    var priceRetail: Double!
    var rating: Int!
    
    init() {}
    init(json: SwiftyJSON.JSON) {
        id          = json["Id"].intValue
        name        = json["Name"].stringValue
        region      = json["Appellation", "Region", "Name"].stringValue
        label       = json["Labels", 0, "Url"].URL
        varietal    = json["Varietal", "WineType", "Name"].stringValue
        vineyard    = json["Vineyard", "Name"].stringValue
        vintage     = json["Vintage"].stringValue
        priceMin    = json["PriceMin"].doubleValue
        priceMax    = json["PriceMax"].doubleValue
        priceRetail = json["PriceRetail"].doubleValue
        rating      = json["Ratings", "HighestScore"].intValue
    }
    
    func getDictionaryValues() -> [String: AnyObject] {
        return(["id": id, "name": name, "price": priceMin])
    }
}