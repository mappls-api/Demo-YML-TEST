import UIKit
import MapplsAPIKit

protocol AttributionChooserVCDelegate {
    func didSelectAttributions(attributions: [MapplsAttributeOptions])
}

class AttributionChooserVC: UIViewController {
    var delegate: AttributionChooserVCDelegate?
    
    var tableView: UITableView!
    
    public var attributions = MapplsAttributeOptions.allCases
    
    public var selectedAttributions: [MapplsAttributeOptions] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonClicked))  
    }
    
    @objc func doneButtonClicked() {
        self.delegate?.didSelectAttributions(attributions: self.selectedAttributions)
    }
    
    func setupTableView(){
        tableView = UITableView()
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: self.view.safeTopAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
    }
    @objc func switchChanged(_ sender : UISwitch) {
        guard let customSwitch = sender as? CustomUISwitch, let tableRowIndexPath = customSwitch.tableRowIndexPath else { return }
        let attribution = attributions[tableRowIndexPath.row]
        
        
        if sender.isOn && selectedAttributions.contains(attribution) {
            selectedAttributions.removeAll { $0 == attribution }
        } else if !sender.isOn && !selectedAttributions.contains(attribution) {
            selectedAttributions.append(attribution)
        }
        

        tableView.reloadData()
        
    }
    
    func getValueForSwitchFromSetting(indexPath: IndexPath) -> Bool {
        let attribution = attributions[indexPath.section]
        
        return selectedAttributions.contains(attribution)
    }
}

extension AttributionChooserVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell: UITableViewCell!
        let cellIdentifier = "attriutionCell"
        let currentType = attributions[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            if let accessoryView = returnCell.accessoryView, accessoryView.isKind(of: CustomUISwitch.self) {
                let switchView = accessoryView as! CustomUISwitch
                switchView.isOn = getValueForSwitchFromSetting(indexPath: indexPath)
            }
            returnCell = cell
        } else {
            let newCell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
            let switchView = CustomUISwitch(frame: .zero)
            newCell.accessoryView = switchView
            switchView.tableRowIndexPath = indexPath
            switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
            switchView.isOn = getValueForSwitchFromSetting(indexPath: indexPath)
            returnCell = newCell
        }
        returnCell.textLabel?.text = attributions[indexPath.row].descriptionText
        return returnCell
    }
}
