//
//  User.swift
//  ABC
//
//  Created by Matthew Korporaal on 4/1/15.
//  Copyright (c) 2015 Matthew Korporaal. All rights reserved.
//

import Foundation

class User: Printable {
    
    var username: String!
    var password: String!
    var cart: Cart!
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
        cart = Cart()
    }
    
    var description: String {
        return "\(username)"
    }
    
    func debugQuickLookObject() -> AnyObject? {
        return "\(username)"
    }
}