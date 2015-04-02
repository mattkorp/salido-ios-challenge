//
//  CartTableViewController.swift
//  ABC
//
//  Created by Matthew Korporaal on 4/1/15.
//  Copyright (c) 2015 Matthew Korporaal. All rights reserved.
//

import UIKit

class CartTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate, CartTableViewCellProtocol {
    
    var user: User!
    var tableView: UITableView!
    var rowHeight: CGFloat = 35
    var padding: CGFloat = 5
    var popover: CartOutputPopoverViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = LocalCache.user
        loadUI()
        loadTableView()
    }
    
    func loadUI() {
        navigationController?.navigationBarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Checkout", style: UIBarButtonItemStyle.Bordered, target: self, action: "checkout")
        navigationController?.title = "ABC"
    }
    
    func loadTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: UITableViewStyle.Plain)
        tableView.registerClass(CartTableViewCell.self, forCellReuseIdentifier: "cartCell")
        tableView.registerClass(CartTableViewCell.self, forCellReuseIdentifier: "totalCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = rowHeight
        tableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        tableView.tableFooterView  = UIView(frame: CGRectZero)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        view.addSubview(tableView)
    }
    
    // MARK: Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.cart.items.count + 4
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Qty     Item                                                               Price         Total  Remove"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: CartTableViewCell!
        
        let lastCellIndex = user.cart.items.count
        // Summary total items, subtotal, shipping, tax, Total
        if indexPath.row >= lastCellIndex {
            cell = tableView.dequeueReusableCellWithIdentifier("totalCell", forIndexPath: indexPath) as CartTableViewCell
            if lastCellIndex == indexPath.row {
                cell.updateTotalsCell(user.cart.totalItems, label: "Subtotal:", value: user.cart.subtotal)
            } else if lastCellIndex == indexPath.row - 1 {
                cell.updateTotalsCell(nil, label: "Tax:", value: user.cart.salesTax)
            } else if lastCellIndex == indexPath.row - 2 {
                cell.updateTotalsCell(nil, label: "Shipping:", value: user.cart.shipping)
            } else {
                cell.updateTotalsCell(nil, label: "Total:", value: user.cart.grandTotal)
            }
            // otherwise fill as itemized cell
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("cartCell", forIndexPath: indexPath) as CartTableViewCell
            
            // List item, quantity update, unit price, item total, delete option
            let item = user.cart.items[indexPath.row]
            cell.updateCell(indexPath.row, quantity: item.quantity, name: item.product.name, unitPrice: item.product.priceMin, totalPrice: item.priceTotal)
            
            cell.trashButton.addTarget(self, action: "trashItem:", forControlEvents: .TouchUpInside)
        }
        cell.quantityDelegate = self
        return cell
    }
    
    // MARK: Table View Delegate Protocol Methods
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as UITableViewHeaderFooterView
        header.contentView.backgroundColor = Configuration.medBlueUIColor
        header.textLabel.textColor         = Configuration.lightBlueUIColor
        header.textLabel.font              = Configuration.helveticaMedium10
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15.0
    }
    
    /**
    CartTableViewCellProtocol method
    
    :param: quantity
    :param: row      row index in table
    */
    func shouldUpdateCartWithNewQuantity(quantity: Int, row: Int) {
        user.cart.items[row].updateQuantity(quantity)
        user.cart.updateCart(user.cart.items[row])
        tableView.reloadData()
    }
    
    /**
    X button target to remove item from cart
    
    :param: button sender
    */
    func trashItem(button: UIButton) {
        user.cart.items[button.tag].updateQuantity(0)
        user.cart.updateCart(user.cart.items[button.tag])
        tableView.reloadData()
    }
    
    func checkout() {
        if user.cart.totalItems > 0 {
            searchViewLeftButtonPressed()
        }
    }

    func searchViewLeftButtonPressed() {
        popover = CartOutputPopoverViewController()
        popover.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        popover.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        presentViewController(popover, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!) -> UIModalPresentationStyle {
        return .OverCurrentContext
    }
    
    func successAlert() {
        let n = user.username
        let t = String(format: "%.2f", user.cart.grandTotal)
        var alert = UIAlertController(title: "Thanks " + n, message: "You have been charged: $" + t, preferredStyle: UIAlertControllerStyle.Alert)
        
        var action = UIAlertAction(title: "Ok", style: .Cancel) { _ in
            self.user.cart.removeAllItems()
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}
