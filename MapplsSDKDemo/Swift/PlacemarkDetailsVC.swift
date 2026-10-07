import Foundation

import UIKit
import MapplsMap
import MapplsAPIKit
import MapplsAPICore
class PlacemarkDetailsVC: UIViewController {
    lazy var tableView = UITableView(frame: .zero)
    
    var tableDict  : [[String : Any]] = [[String : Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.view.backgroundColor = .white
        self.tableView.reloadData()
    }
    
    private func setupViews() {
        self.view.addSubview(self.tableView)
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DemoMapStyleTableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension PlacemarkDetailsVC : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDict.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        var tableCell: UITableViewCell!
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier){
            tableCell = cell
        }else {
            tableCell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
        }
        if tableDict.indices.contains(indexPath.row), let key = tableDict[indexPath.row].keys.first , let value =  tableDict[indexPath.row].values.first{
            tableCell.textLabel?.text = "\(key)"
            tableCell.detailTextLabel?.text = "\(value)"
        }
        return tableCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
