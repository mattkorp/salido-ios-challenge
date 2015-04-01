//
//  Configuration.swift
//  ABC
//
//  Created by Matthew Korporaal on 4/1/15.
//  Copyright (c) 2015 Matthew Korporaal. All rights reserved.
//

import UIKit

struct Configuration {
    
    // UI elements
    static let lightGreyUIColor = UIColor(red: 0.937, green: 0.937, blue: 0.937, alpha: 1.0)
    static let lightBlueUIColor = UIColor(red: 0.741, green: 0.831, blue: 0.871, alpha: 1.0)
    static let medBlueUIColor   = UIColor(red: 0.247, green: 0.341, blue: 0.396, alpha: 1.0)
    static let darkBlueUIColor  = UIColor(red: 0.168, green: 0.227, blue: 0.258, alpha: 1.0)
    static let orangeUIColor    = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
    static let greenUIColor     = UIColor(red:0.34, green:0.68, blue:0.42, alpha:1)
    
    static let helveticaLight10 = UIFont(name: "HelveticaNeue-Light", size: 10.0)
    static let helveticaLight12 = UIFont(name: "HelveticaNeue-Light", size: 12.0)
    static let helveticaMedium10 = UIFont(name: "HelveticaNeue-Medium", size: 10.0)
    static let helveticaMedium14 = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
    static let helveticaMedium20 = UIFont(name: "HelveticaNeue-Medium", size: 20.0)
    
    static let cornerRadius     = CGFloat(3)
    
    // Image placeholder. Making it the same size as the labels
    static func getPlaceholderImage() -> UIImage {
        let placeholderURL   = NSURL(string: "http://cache.wine.com/images/logos/80x80_winecom_logo.png")!
        let placeholderData  = NSData(contentsOfURL: placeholderURL)!
        let resizer = ImageResizer(size: CGSizeMake(100, 100), scaleMode: ImageResizer.ScaleMode.AspectFill, allowUpscaling: false, compressionQuality: 1.0)
        return(resizer.resizeImage(UIImage(data: placeholderData)!))
    }
    static let placeholderImg = Configuration.getPlaceholderImage()
    
    // Cart
    static let salesTax         = 0.08
    static let shippingRate     = 0.10
    
}