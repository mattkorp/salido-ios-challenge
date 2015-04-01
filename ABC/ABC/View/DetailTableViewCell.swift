//
//  DetailTableViewCell.swift
//  ABC
//
//  Created by Matthew Korporaal on 4/1/15.
//  Copyright (c) 2015 Matthew Korporaal. All rights reserved.
//

import UIKit

protocol DetailTableViewCellProtocol {
    func shouldUpdateCartWithNewQuantity(quantity: Int, row: Int)
}

class DetailTableViewCell: UITableViewCell, UITextFieldDelegate {
    var labelImage: UIImageView!
    var quantityTextField: UITextField!
    var quantityView: UIView!
    var quantityUpdate: UIButton!
    var quantityDelegate: DetailTableViewCellProtocol?
    var row: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        styleCell()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        styleCell()
    }
    
    func styleCell() {
        // Label Image
        labelImage = UIImageView()
        contentView.addSubview(labelImage)
        
        // Cart quantity UI
        let quantityLabel = UILabel(frame: CGRectMake(0, 0, 40, 20))
        quantityLabel.text = "Qty:"
        quantityLabel.font = Configuration.helveticaLight12
        
        quantityTextField = UITextField(frame: CGRectMake(40, 0, 40, 20))
        quantityTextField.font = Configuration.helveticaLight12
        quantityTextField.borderStyle = UITextBorderStyle.RoundedRect
        quantityTextField.backgroundColor = UIColor.whiteColor()
        quantityTextField.delegate = self
        quantityTextField.textAlignment = NSTextAlignment.Center
        quantityTextField.keyboardType = UIKeyboardType.NumbersAndPunctuation
        quantityTextField.autocorrectionType = UITextAutocorrectionType.No
        
        quantityUpdate = UIButton(frame: CGRectMake(84, 0, 60, 20))
        quantityUpdate.setTitle("Update", forState: .Normal)
        quantityUpdate.titleLabel?.font = Configuration.helveticaLight12
        quantityUpdate.addTarget(self, action: "updateCart:", forControlEvents: .TouchUpInside)
        quantityUpdate.backgroundColor = Configuration.greenUIColor
        quantityUpdate.layer.cornerRadius = Configuration.cornerRadius
        
        quantityView = UIView()
        quantityView.addSubview(quantityLabel)
        quantityView.addSubview(quantityTextField)
        quantityView.addSubview(quantityUpdate)
        quantityView.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(quantityView)
        addQtyViewConstraints()
        
        textLabel?.font = Configuration.helveticaMedium20
        textLabel?.numberOfLines = 3
        
        detailTextLabel?.font = Configuration.helveticaLight12
        detailTextLabel?.numberOfLines = 2
        
        selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    func addQtyViewConstraints() {
        // Constraints for Cart updating view
        addConstraints([
            NSLayoutConstraint(item: quantityView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: -8.0),
            NSLayoutConstraint(item: quantityView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1.0, constant: -8.0),
            NSLayoutConstraint(item: quantityView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 164.0),
            NSLayoutConstraint(item: quantityView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 20.0)
            ])
    }
    
    override func prepareForReuse() {
        labelImage.hnk_cancelSetImage()
        labelImage.image = nil
        quantityUpdate.setTitle("Update", forState: .Normal)
        quantityTextField.placeholder = ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame.origin.y = 10
        detailTextLabel?.frame.origin.y = self.contentView.bounds.maxY - 50
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        quantityTextField.resignFirstResponder()
        return false
    }
    
    func updateCell(row: Int, colors: (UIColor, UIColor), image: NSURL, name: String, detail: String) {
        self.row = row
        // Set colors
        backgroundColor = colors.0
        textLabel?.textColor = colors.1
        
        // Set image with url or fetch from cache
        let resizer = ImageResizer(size: CGSizeMake(100, 100), scaleMode: ImageResizer.ScaleMode.None, allowUpscaling: false, compressionQuality: 1.0)
        let resizedImg = resizer.resizeImage(UIImage(data: NSData(contentsOfURL: image)!)!)
        imageView?.hnk_setImage(resizedImg, animated: true, success: nil)
        
        
        // Set labels text
        textLabel?.text = name
        detailTextLabel?.text = detail
    }
    
    /**
    Update button target. sets delegate method
    
    :param: sender 
    */
    func updateCart(sender: UIButton) {
        var quantity: Int!
        var name: String!
        if quantityTextField.text.toInt() >= 0 {
            quantity = quantityTextField.text.toInt()
            if let text = textLabel?.text {
                name = text
                quantityDelegate?.shouldUpdateCartWithNewQuantity(quantity, row: row)
            }
        }
        quantityTextField.resignFirstResponder()
        animateButton()
    }
    /**
    Animates the update button for feedback
    */
    func animateButton() {
        UIView.animateWithDuration(2.0, delay: 0.3, options: .CurveEaseInOut, animations: {
            self.quantityUpdate.setTitle("✓", forState: .Normal)
            self.quantityUpdate.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            self.quantityUpdate.backgroundColor = self.quantityUpdate.backgroundColor?.colorWithAlphaComponent(0.5)
            }, completion: { _ in
                self.quantityUpdate.setTitle("Update", forState: .Normal)
                self.quantityUpdate.backgroundColor = Configuration.greenUIColor
                self.quantityTextField.placeholder = self.quantityTextField.text
                self.quantityTextField.text = ""
        })
    }
}
