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
            quantityTextField.font = Configuration.helveticaBold14
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

        var padding: CGFloat  = 12.0
        let cvB = contentView.bounds.width
        let qL:CGFloat = 40, nL:CGFloat = 150, pL:CGFloat = 50, tL:CGFloat = 50, tbL:CGFloat = 20
        quantityTextField.frame = CGRectMake(0, 2, qL, 20)
        name.frame              = CGRectMake(qL+padding, 0, nL, 30)
        price.frame             = CGRectMake(cvB-tbL-tL-pL-padding, 0, pL, 30)
        total.frame             = CGRectMake(cvB-tbL-tL-padding, 0, tL, 30)
        trashButton.frame       = CGRectMake(cvB-tbL-padding, 2, tbL, 30)

        let viewsDict = ["cellView": cellView]
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[cellView]-|", options: .allZeros, metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[cellView]-|", options: .allZeros, metrics: nil, views: viewsDict))
        
        itemTotal.frame = CGRectMake(0, 0, 30, 30)
        let labelLen: CGFloat = 80
        summaryLabel.frame = CGRectMake(cvB-2.5*labelLen, 0, labelLen, 30)
        summaryValue.frame = CGRectMake(cvB-1.5*labelLen, 0, labelLen, 30)
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if checkTextFieldInputValidity() {
            quantityTextField.resignFirstResponder()
        }
        return false
    }
    
    /**
        Check if integer in textField
    :returns: bool
    */
    func checkTextFieldInputValidity() -> Bool {
        let stringLen = distance(quantityTextField.text.startIndex, quantityTextField.text.endIndex)
        let range = NSMakeRange(0, stringLen)
        let text = (quantityTextField.text as NSString).stringByReplacingCharactersInRange(range, withString: quantityTextField.text)
        
        if let intVal = text.toInt() {
            if text != "" {
                // Text field converted to an Int, if not empty
                quantityDelegate?.shouldUpdateCartWithNewQuantity(text.toInt()!, row: trashButton.tag)
                return true
            }
        }
        return false
    }
    
}
