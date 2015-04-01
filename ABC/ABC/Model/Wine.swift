//
//  Wine.swift
//  ABC
//
//  Created by Matthew Korporaal on 4/1/15.
//  Copyright (c) 2015 Matthew Korporaal. All rights reserved.
//

import Foundation
import SwiftyJSON

class Wine {
    
    lazy var type        = [String: Int]()
    lazy var varietal    = [String: Int]()
    lazy var style       = [String: Int]()
    lazy var region      = [String: Int]()
    lazy var appellation = [String: Int]()
    lazy var vintage     = [String: Int]()
    lazy var wineData    = [String: [String, Int]]()
    
    let categories = ["Wine Type", "Varietal", "Wine Style", "Region", "Appellation", "Vintage"]
    
    enum Categories {
        case WineType, Varietal, WineStyle, Region, Appellation, Vintage
        
        init?(category: String) {
            switch category {
            case "Wine Type":   self = .WineType
            case "Varietal":    self = .Varietal
            case "Wine Style":  self = .WineStyle
            case "Region":      self = .Region
            case "Appellation": self = .Appellation
            case "Vintage":     self = .Vintage
            default:            return nil
            }
        }
    }
    
    init() {}
    init(json: SwiftyJSON.JSON){
        
        func parseJSON(data: SwiftyJSON.JSON) -> [String: Int] {
            var c = [String: Int]()
            for (index: String, subJSON: SwiftyJSON.JSON) in data["Refinements"] {
                c[subJSON["Name"].stringValue] = subJSON["Id"].intValue
            }
            return c
        }
        
        for (x: String, categories: SwiftyJSON.JSON) in json["Categories"] {
            if let category = Categories(category: categories["Name"].stringValue) {
                switch  category {
                case .WineType:    type        = parseJSON(categories)
                case .Varietal:    varietal    = parseJSON(categories)
                case .WineStyle:   style       = parseJSON(categories)
                case .Region:      region      = parseJSON(categories)
                case .Appellation: appellation = parseJSON(categories)
                case .Vintage:     vintage     = parseJSON(categories)
                }
            }
        }
        
        self.wineData["Wine Type"]   = sorted(type) { $0.0 < $1.0 }
        self.wineData["Region"]      = sorted(region) { $0.0 < $1.0 }
        self.wineData["Vintage"]     = sorted(vintage) { $0.0 < $1.0 }
        self.wineData["Appellation"] = sorted(appellation) { $0.0 < $1.0 }
        self.wineData["Varietal"]    = sorted(varietal) { $0.0 < $1.0 }
        self.wineData["Wine Style"]  = sorted(style) { $0.0 < $1.0 }
    }
    
}