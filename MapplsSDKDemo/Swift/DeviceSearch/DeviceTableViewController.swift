//
//  DeviceTableViewController.swift
//  MapplsSDKDemo
//
//  Created by ceinfo on 31/01/24.
//  Copyright © 2024 MMI. All rights reserved.
//

import UIKit

class DeviceTableViewController: UIViewController {
    var tableView: UITableView!
    var tableDict  :  [[[String : Any]]] = [[[String : Any]]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        view.backgroundColor = .gray
//        Dos
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapplsSheetViewController?.handleScrollView(tableView)
    }
    func setupTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
}

extension DeviceTableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableDict.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDict[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        var tableCell: UITableViewCell!
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            tableCell = cell
        }else {
            tableCell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
        }
        let tableDict = tableDict[indexPath.section]
        if let key = tableDict[indexPath.row].keys.first , let value =  tableDict[indexPath.row].values.first {
            tableCell.textLabel?.text = "\(key)"
            tableCell.detailTextLabel?.text = "\(value)"
        }
        return tableCell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let tableDict = tableDict[section]
        let aaa = tableDict.first(where: {$0.keys.contains("entityName")})
        
        return aaa?.values.first as? String ?? "Title"
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
