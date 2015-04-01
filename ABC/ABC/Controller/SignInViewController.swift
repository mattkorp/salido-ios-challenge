//
//  SignInViewController.swift
//  ABC
//
//  Created by Matthew Korporaal on 4/1/15.
//  Copyright (c) 2015 Matthew Korporaal. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Views
    var spinner: UIActivityIndicatorView!
    var username: UITextField!
    var password: UITextField!
    var loginSuccessErrorLabel: UILabel!
    var scrollView: UIScrollView!
    var titleLabel: UILabel!
    
    // MARK: Customizable view properties
    let paddingX:CGFloat     = 30
    let paddingY:CGFloat     = 10
    
    // MARK: VC Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Configuration.lightGreyUIColor
        
        DataManager.retrieveCategories { _,_ in }
        
        loadUI()
        
        spinner.hidden = true
        spinner.hidesWhenStopped = true
        
        username.delegate = self
        password.delegate = self
        
        var tapToDismissKeyboard = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tapToDismissKeyboard.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapToDismissKeyboard)
        
    }
    
    /**
    load UI elements
    */
    func loadUI() {
        let screenBounds = UIScreen.mainScreen().bounds
        
        navigationController?.navigationBarHidden = true
        // scrollview
        scrollView = UIScrollView(frame: CGRectMake(0, 0, screenBounds.width, screenBounds.height))
        scrollView.contentSize = CGSize(width: screenBounds.width, height: screenBounds.height + 500)
        scrollView.autoresizingMask = .FlexibleBottomMargin | .FlexibleLeftMargin | .FlexibleRightMargin | .FlexibleTopMargin
        scrollView.scrollEnabled = false
        scrollView.userInteractionEnabled = true
        view.addSubview(scrollView)
        
        // spinner
        spinner = UIActivityIndicatorView()//frame: CGRectMake(screenBounds.width/2, screenBounds.height/2, 50, 50))
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        spinner.autoresizingMask = .FlexibleBottomMargin | .FlexibleLeftMargin | .FlexibleRightMargin | .FlexibleTopMargin
        scrollView.addSubview(spinner)
        
        // title. replace with logo
        titleLabel = UILabel(frame: CGRectMake(paddingX,topLayoutGuide.length+paddingY*10, screenBounds.width-paddingX*2, 50))
        titleLabel.text = "ABC"
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.textColor = Configuration.darkBlueUIColor
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 50.0)
        titleLabel.autoresizingMask = .FlexibleBottomMargin | .FlexibleLeftMargin | .FlexibleRightMargin | .FlexibleWidth
        scrollView.addSubview(titleLabel)
        
        // Error/Success label
        loginSuccessErrorLabel = UILabel(frame: CGRectMake(paddingX, titleLabel.frame.maxY+paddingY, screenBounds.width-paddingX*2, 20))
        loginSuccessErrorLabel.textAlignment = NSTextAlignment.Center
        scrollView.addSubview(loginSuccessErrorLabel)
        
        // text fields
        username = UITextField(frame: CGRectMake(paddingX*2, loginSuccessErrorLabel.frame.maxY+paddingY, screenBounds.width-paddingX*4, 40))
        username.autoresizingMask = .FlexibleBottomMargin | .FlexibleLeftMargin | .FlexibleRightMargin
        username.backgroundColor = UIColor.whiteColor()
        username.placeholder = "Username"
        username.textAlignment = NSTextAlignment.Center
        username.layer.cornerRadius = Configuration.cornerRadius
        username.autocorrectionType = UITextAutocorrectionType.No
        
        scrollView.addSubview(username)
        password = UITextField(frame: CGRectMake(paddingX*2, username.frame.maxY+paddingY, screenBounds.width-paddingX*4, 40))
        password.autoresizingMask = .FlexibleBottomMargin | .FlexibleLeftMargin | .FlexibleRightMargin
        password.backgroundColor = UIColor.whiteColor()
        password.placeholder = "Password"
        password.secureTextEntry = true
        password.textAlignment = NSTextAlignment.Center
        password.layer.cornerRadius = Configuration.cornerRadius
        password.autocorrectionType = UITextAutocorrectionType.No
        scrollView.addSubview(password)
        
        // Buttons
        var signInButton = UIButton(frame: CGRectMake(paddingX*2, password.frame.maxY+paddingY, screenBounds.width-paddingX*4, 50))
        signInButton.autoresizingMask = .FlexibleBottomMargin | .FlexibleLeftMargin | .FlexibleRightMargin
        signInButton.setTitle("Sign In", forState: .Normal)
        signInButton.setTitleColor(Configuration.lightGreyUIColor, forState: .Normal)
        signInButton.layer.cornerRadius = Configuration.cornerRadius
        signInButton.backgroundColor = Configuration.greenUIColor
        signInButton.addTarget(self, action: "signInPressed:", forControlEvents: .TouchUpInside)
        scrollView.addSubview(signInButton)
        
        
    }
    
    // MARK: Button Target methods
    
    // Sign in user and send to main app upon success, otherwise give feedback
    func signInPressed(sender: UIButton?) {
        spinner.hidden = false
        spinner.startAnimating()
        if username.text != "" && password.text != "" {
            if validateUsername() && validatePassword() {
                LocalCache.user = User(username: username.text, password: password.text)
                spinner.stopAnimating()
                displaySuccessErrorLabel("Welcome back, \(username.text)", valid: true)
                navigationController?.pushViewController(ListingTableViewController(), animated: true)
            } else {
                displaySuccessErrorLabel("5 character minimum", valid: false)
            }
        } else {
            displaySuccessErrorLabel("Fill both fields", valid: false)
        }
    }
    
    // MARK: Text Field Validation
    func validateUsername() -> Bool {
        var passwordRegex = "^.{5,40}$"
        if let match = username.text.rangeOfString(passwordRegex, options: .RegularExpressionSearch) {
            return true
        } else {
            return false
        }
    }
    func validatePassword() -> Bool {
        var passwordRegex = "^.{5,40}$"
        if let match = password.text.rangeOfString(passwordRegex, options: .RegularExpressionSearch) {
            return true
        } else {
            return false
        }
    }
    
    // Error label
    func displaySuccessErrorLabel(text: String, valid: Bool) {
        loginSuccessErrorLabel.text = text
        loginSuccessErrorLabel.textColor = valid ? UIColor.greenColor() : UIColor.redColor()
        UIView.animateWithDuration(1, delay: 0.0, options: .CurveEaseInOut, animations: { self.loginSuccessErrorLabel.alpha = 1.0 }, completion: { _ in UIView.animateWithDuration(3) { self.loginSuccessErrorLabel.alpha = 0.0 } })
    }
    
    // MARK: TextFieldDelegate methods and keyboard behavior
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == username {
            password.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            signInPressed(nil)
        }
        return true
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        username.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    func dismissKeyboard() {
        touchesBegan(NSSet(), withEvent: UIEvent())
        textFieldDidEndEditing(username)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let scrollTo: CGPoint = CGPointMake(0, titleLabel.frame.origin.y - topLayoutGuide.length)
        UIView.animateWithDuration(0.5) {
            self.scrollView.setContentOffset(scrollTo, animated: true)
        }
    }
    func textFieldDidEndEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPointZero, animated: true)
    }
    
}