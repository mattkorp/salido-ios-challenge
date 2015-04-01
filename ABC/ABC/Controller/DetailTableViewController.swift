//
//  DetailTableViewController.swift
//  ABC
//
//  Created by Matthew Korporaal on 4/1/15.
//  Copyright (c) 2015 Matthew Korporaal. All rights reserved.
//

import UIKit

class DetailTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DetailTableViewCellProtocol {
    
    var id: Int!
    lazy var products = [Product]()
    var tableView: UITableView!
    let rowHeight: CGFloat = 140
    var pageCount = 0
    var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        loadUI()
        loadTableView()
    }
    
    /**
    Initialize VC look and feel
    */
    func loadUI() {
        view.backgroundColor = UIColor.whiteColor()
        navigationController?.navigationBarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cart", style: UIBarButtonItemStyle.Bordered, target: self, action: "showCart")
        navigationItem.title = "ABC"
        
    }
    
    /**
    Initialize table view
    */
    func loadTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: UITableViewStyle.Plain)
        tableView.registerClass(DetailTableViewCell.self, forCellReuseIdentifier: "detailCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = rowHeight
        tableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        view.addSubview(tableView)
        
        loadSpinner()
    }
    
    func loadSpinner() {
        spinner = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        spinner.center.x = view.center.x
        spinner.center.y = view.center.y
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        tableView.addSubview(spinner)
    }
    
    /**
    Retrieves more data when end of table view is reached
    */
    func loadData() {
        DataManager.searchCatalog(id, page: pageCount) { data, error in
            if let data = data {
                data.map { self.products.append($0) }
                self.pageCount++
                if let tv = self.tableView {
                    tv.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath) as DetailTableViewCell
        spinner.stopAnimating()
        // set delegate for updating cart quantities
        cell.quantityDelegate = self
        // get colors
        let cellColors = chooseBackgroundColor(indexPath.row)
        
        // Setter for cell components
        cell.updateCell(indexPath.row, colors: cellColors, image: products[indexPath.row].label, name: products[indexPath.row].name, detail: "Retail: \(products[indexPath.row].priceMax)\nOur Price: \(products[indexPath.row].priceMin)")
        
        // Load more data if scrolled to bottom
        if indexPath.row == products.count - 1 {
            loadData()
        }
        return cell
    }
    
    /**
    Getter for alternating cell background and text colors
    
    :param: index cell index
    :returns: tuple: bkgColor, txtColor both UIColors
    */
    func chooseBackgroundColor(index: Int) -> (bkgColor: UIColor, txtColor: UIColor) {
        var bkgColor = UIColor()
        var txtColor = UIColor()
        
        switch index % 2 {
        case 0:
            bkgColor = Configuration.lightGreyUIColor
            txtColor = Configuration.medBlueUIColor
        case 1:
            bkgColor = Configuration.lightBlueUIColor
            txtColor = Configuration.darkBlueUIColor
        default:
            bkgColor = Configuration.lightGreyUIColor
            txtColor = UIColor.blackColor()
        }
        return (bkgColor, txtColor)
    }
    
    /**
    Target for Cart button. Opens the Cart VC
    */
    func showCart() {
        navigationController?.pushViewController(CartTableViewController(), animated: true)
    }
    
    // MARK: DetailCellViewDelegate Method
    /**
    updates user cart with new items and quantities
    
    :param: quantity how many. from text field
    :param: row
    */
    func shouldUpdateCartWithNewQuantity(quantity: Int, row: Int) {
        if let item = CartItem(product: products[row], qty: quantity) {
            LocalCache.user.cart.addItem(item)
        } else {
            println("cannot update cart")
        }
    }
}