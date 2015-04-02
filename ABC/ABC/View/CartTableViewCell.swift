//
//  CartTableViewCell.swift
//  ABC
//
//  Created by Matthew Korporaal on 4/1/15.
//  Copyright (c) 2015 Matthew Korporaal. All rights reserved.
//

import UIKit

import UIKit

protocol CartTableViewCellProtocol {
    func shouldUpdateCartWithNewQuantity(quantity: Int, row: Int)
}

class CartTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    var cellView          = UIView()
    var border            = UIView()
    var quantityTextField = UITextField()
    var name              = UILabel()
    var price             = UILabel()
    var total             = UILabel()
    var summaryLabel      = UILabel()
    var summaryValue      = UILabel()
    var itemTotal         = UILabel()
    var trashButton       = UIButton()
    var padding: CGFloat  = 5.0
    var quantityDelegate: CartTableViewCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        styleCell(reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func styleCell(reuseIdentifier: String) {
        
        if reuseIdentifier == "cartCell" {
            quantityTextField.borderStyle = UITextBorderStyle.RoundedRect
            quantityTextField.delegate = self
            quantityTextField.font = Configuration.helveticaMedium10
            quantityTextField.textAlignment = NSTextAlignment.Center
            quantityTextField.keyboardType = UIKeyboardType.NumbersAndPunctuation
            
            name.font  = Configuration.helveticaLight12
            price.font = Configuration.helveticaLight10
            price.textAlignment = NSTextAlignment.Right
            total.font = Configuration.helveticaLight10
            total.textAlignment = NSTextAlignment.Right
            
            trashButton.setTitle("╳", forState: .Normal)
            trashButton.setTitleColor(Configuration.orangeUIColor, forState: .Normal)
            
            cellView.addSubview(quantityTextField)
            cellView.addSubview(name)
            cellView.addSubview(price)
            cellView.addSubview(total)
            cellView.addSubview(trashButton)
            
        } else {
            // Summary views
            itemTotal.font = Configuration.helveticaLight12
            itemTotal.textAlignment = NSTextAlignment.Center
            cellView.addSubview(itemTotal)
            summaryLabel.font = Configuration.helveticaMedium14
            summaryLabel.textAlignment = NSTextAlignment.Right
            cellView.addSubview(summaryLabel)
            summaryValue.font = Configuration.helveticaMedium10
            summaryValue.textAlignment = NSTextAlignment.Right
            cellView.addSubview(summaryValue)
        }
        
        contentView.addSubview(cellView)
        cellView.setTranslatesAutoresizingMaskIntoConstraints(false)
    
    }
    
    func updateCell(row: Int, quantity: Int, name: String, unitPrice: Double, totalPrice: Double) {
        trashButton.tag               = row
        self.name.text                = name
        price.text                    = "\(unitPrice)"
        total.text                    = "\(totalPrice)"
        quantityTextField.placeholder = String(quantity)
    }
    
    func updateTotalsCell(quantity: Int?, label: String, value: Double) {
        if let qty = quantity {
            itemTotal.text = "\(qty)"
            // make border
            border.backgroundColor = Configuration.orangeUIColor.colorWithAlphaComponent(0.3)
            border.frame = CGRectMake(0, 4, frame.width, 0.5)
            contentView.addSubview(border)
        }
        summaryLabel.text = label
        let valueStr = String(format: "%.2f", value)
        summaryValue.text = "$ " + valueStr
    }

    override func layoutSubviews() {
        quantityTextField.frame = CGRectMake(0, padding, 40, 20)
        name.frame              = CGRectMake(40+padding, 0, 130, 30)
        price.frame             = CGRectMake(170+padding, 0, 50, 30)
        total.frame             = CGRectMake(220+padding, 0, 50, 30)
        trashButton.frame       = CGRectMake(280+padding, 2, 20, 30)
        
        let viewsDict = ["cellView": cellView]
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[cellView]-|", options: .allZeros, metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[cellView]-|", options: .allZeros, metrics: nil, views: viewsDict))
        
        itemTotal.frame = CGRectMake(0, 0, 30, 30)
        let labelLen: CGFloat = 80
        summaryLabel.frame = CGRectMake(contentView.bounds.width-2.5*labelLen, 0, labelLen, 30)
        summaryValue.frame = CGRectMake(contentView.bounds.width-1.5*labelLen, 0, labelLen, 30)
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        quantityDelegate?.shouldUpdateCartWithNewQuantity(quantityTextField.text.toInt()!, row: trashButton.tag)
        quantityTextField.resignFirstResponder()
        return false
    }
    
}
