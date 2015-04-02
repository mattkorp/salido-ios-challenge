//
//  FilterPopoverViewController.swift
//  ABC
//
//  Created by Matthew Korporaal on 4/2/15.
//  Copyright (c) 2015 Matthew Korporaal. All rights reserved.
//

import UIKit
import SwiftyJSON

class CartOutputPopoverViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var delegate: UIPopoverPresentationControllerDelegate!
    var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
    }
    
    func loadUI() {
        var blurredEffect = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        blurredEffect.frame = view.bounds
        view.addSubview(blurredEffect)
        
        containerView = UIView(frame: CGRectMake(20, 50, view.bounds.width-40, 400))
        containerView.layer.cornerRadius = 5
        containerView.backgroundColor = UIColor.whiteColor()
        view.addSubview(containerView)
        
        var textView = UITextView(frame: CGRectMake(0, 40, containerView.bounds.width, containerView.bounds.height))
        containerView.addSubview(textView)
        textView.font = Configuration.helveticaMedium10
        let d = DataManager.postUserCart()
        let e = SwiftyJSON.JSON(d)
        textView.text = "\(e)"
        
        var dismissbutton = UIButton(frame: CGRectMake(10, 10, 30, 30))
        dismissbutton.backgroundColor = Configuration.orangeUIColor
        dismissbutton.layer.cornerRadius = Configuration.cornerRadius
        dismissbutton.setTitle("😎", forState: .Normal)
        dismissbutton.addTarget(self, action: "dismissPopover", forControlEvents: .TouchUpInside)
        containerView.addSubview(dismissbutton)

    }

    func dismissPopover() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewWillAppear(animated: Bool) {
        self.preferredContentSize = containerView.frame.size
    }
    
}
