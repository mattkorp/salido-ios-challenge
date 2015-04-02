//
//  Cart.swift
//  ABC
//
//  Created by Matthew Korporaal on 4/1/15.
//  Copyright (c) 2015 Matthew Korporaal. All rights reserved.
//

import Foundation

class Cart {
    lazy var items = [CartItem]()
    var totalItems = 0
    let taxRate = Configuration.salesTax
    let shippingRate = Configuration.shippingRate
    lazy var salesTax = 0.0
    lazy var shipping = 0.0
    lazy var subtotal = 0.0
    lazy var grandTotal = 0.0
    
    /**
    Add items to cart
    :param: item new CartItem
    */
    func addItem(item: CartItem) {
        // check if item exists in cart
        var idMatch = items.filter { $0.product.id == item.product.id }
        if idMatch.isEmpty {
            items.append(item)
        } else {
            updateCart(item)
        }
        calculateTotals()
    }
    
    /**
    update cart and remove items from cart if necessary
    :param: item CartItem with new/updated quantities
    */
    func updateCart(item: CartItem) {
        // if quantity is zero, find and remove
        if item.quantity == 0 {
            items = items.filter { $0.product.id != item.product.id }
        } else {
            var match = items.filter { $0.product.id == item.product.id }
            if !match.isEmpty {
                match[0].updateQuantity(item.quantity)
            }
        }
        calculateTotals()
    }
    
    func removeAllItems() {
        items.removeAll(keepCapacity: false)
        calculateTotals()
    }
    /**
    Calculations
    */
    func calculateTotals() {
        totalItems = Int(items.map { Double($0.quantity) }.reduce(0,{ $0 + $1 }))
        subtotal = items.map { $0.priceTotal }.reduce(0,+)
        salesTax = subtotal * taxRate
        shipping = subtotal * shippingRate
        grandTotal = subtotal + shipping + salesTax
    }
    
    func getDictionaryValues() -> [String: AnyObject] {
        var itemDictionary = [String: AnyObject]()
        for (index, item) in enumerate(items) {
            itemDictionary["\(index)"] = item.getDictionaryValues()
        }
        
        var dictionary = [String: AnyObject]()
        dictionary["items"] = itemDictionary
        dictionary["subtotal"] = subtotal
        dictionary["tax"] = salesTax
        dictionary["shipping"] = shipping
        dictionary["total"] = grandTotal
        return dictionary
    }
}