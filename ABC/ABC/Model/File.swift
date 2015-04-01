//
//  File.swift
//  ABC
//
//  Created by Matthew Korporaal on 4/1/15.
//  Copyright (c) 2015 Matthew Korporaal. All rights reserved.
//

import Foundation

class CartItem {
    var priceTotal: Double!
    var product: Product!
    var quantity: Int!
    
    init?(product: Product, qty: Int) {
        if qty < 0 { return nil }
        self.product = product
        self.quantity = qty
        calculateTotal()
    }
    
    func calculateTotal() {
        priceTotal = product.priceMin * Double(quantity)
    }
    
    func updateQuantity(qty: Int) {
        quantity = qty
        calculateTotal()
    }
}