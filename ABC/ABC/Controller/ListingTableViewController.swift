//
//  ListingTableViewController.swift
//  ABC
//
//  Created by Matthew Korporaal on 4/1/15.
//  Copyright (c) 2015 Matthew Korporaal. All rights reserved.
//

import UIKit

class ListingTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var json: UILabel!
    
    var tableView: UITableView!
    var wine = Wine()
    lazy var wData = [String: [String, Int]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
        loadTableView()
        loadData()
    }
    
    /**
    load basic ui preferences
    */
    func loadUI() {
        view.backgroundColor = UIColor.whiteColor()
        navigationController?.navigationBarHidden = false
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cart", style: UIBarButtonItemStyle.Bordered, target: self, action: "showCart")
        navigationItem.title = "ABC"
    }
    
    /**
    load tableView preferences and add to VC
    */
    func loadTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.rowHeight = 18
        tableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        view.addSubview(tableView)
    }
    
    /**
    get data for table
    */
    func loadData() {
        DataManager.retrieveCategories { data, error in
            if let data = data {
                self.wine = data
            }
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }
    }
    
    // MARK: Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return wine.wineData.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numRows = wine.wineData[wine.categories[section]]!.count
        return numRows
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return wine.categories[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellId") as? UITableViewCell ?? UITableViewCell(style: .Default, reuseIdentifier: "cellId")
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.font = Configuration.helveticaLight12
        cell.textLabel?.text = wine.wineData[wine.categories[indexPath.section]]![indexPath.row].0
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let id = wine.wineData[wine.categories[indexPath.section]]![indexPath.row].1
        let dvc = DetailTableViewController()
        dvc.id = id
        self.navigationController?.pushViewController(dvc, animated: true)
        
    }
    
    // MARK: Table View Delegate Protocol Methods
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as UITableViewHeaderFooterView
        header.contentView.backgroundColor = Configuration.medBlueUIColor
        header.textLabel.textColor = Configuration.lightBlueUIColor
        header.textLabel.font = Configuration.helveticaMedium14
    }
    
    /**
    Cart button target
    */
    func showCart() {
        navigationController?.pushViewController(CartTableViewController(), animated: true)
    }
}