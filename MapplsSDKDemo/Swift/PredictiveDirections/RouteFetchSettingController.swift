import UIKit
import MapplsAPIKit
import MapplsUIWidgets
import IQKeyboardManagerSwift

enum RoutingEngineType: Int {
    case general = 0
    case predictive = 1
}

public enum RouteFetchSettingType: UInt, CustomStringConvertible, CaseIterable {
    case alternativesCount
    case attributions
    case resource
    case vehicleDetails
    
    case showAutosuggestWidget
    
    case profile
    
    case sourceLocations
    
    case destinationLocations
    
    case viaLocations
    
    case length
    case width
    case height
    case weight
    case axleLoad
    case isHazmat
    
    public var description: String{
        switch self {
        case .alternativesCount:
            return "Alternatives Count"
        case .attributions:
            return "Attributions"
        case .resource:
            return "Resource"
        case .vehicleDetails:
            return "Vehicle Details"
        case .showAutosuggestWidget:
            return "Autosuggest Widget"
        case .profile:
            return "Profile"
        case .sourceLocations:
            return "Source Locations"
        case .destinationLocations:
            return "Destination Locations"
        case .viaLocations:
            return "Via Locations"
        case .length:
            return "Length"
        case .width:
            return "Width"
        case .height:
            return "Height"
        case .weight:
            return "Weight"
        case .axleLoad:
            return "Axle Load"
        case .isHazmat:
            return "Hazmat"
        }
    }
}

protocol RouteFetchSettingDelegate {
    func settingsSelected(routeFetchSetting: RouteFetchSetting)
}

class RouteFetchSetting: NSObject {
    
    var alternativesCount: Int = 0
    var sourceLocations = [String]()
    var destinationLocations = [String]()
    var viaLocations = [String]()
    
    var selectedResourceDistance: MapplsDistanceMatrixResourceIdentifier = .default
    var selectedProfile: MapplsDirectionsProfileIdentifier = .driving
    
    var selectedResourceDirection: MapplsDirectionsResourceIdentifier = .routeAdv
    var selectedAttributions : [MapplsAttributeOptions] = []
    
    var vehicleDetails: MapplsVehicleDetails = MapplsVehicleDetails()
    
    fileprivate override init() {
        super.init()
    }
}

class RouteFetchSettingController: UITableViewController {
    public var routeEngine: RoutingEngineType = .predictive
    public var mode: LocationsChooserMode = .distance
    
    var delegate: RouteFetchSettingDelegate?
    
    var demoSettings: [RouteFetchSettingType] = []
    let numericTextFieldTypes: [RouteFetchSettingType] = [.length, .width, .height, .weight, .axleLoad]
    
    var routeFetchSetting: RouteFetchSetting = RouteFetchSetting()
    
    var shouldOpenAutocomplete: Bool = true
    
    var indexPathForSourceOrDesitnation: IndexPath?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Location Chooser"
        self.tableView.separatorStyle = .none
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonClicked))
        
        if mode == .direction {
            routeFetchSetting.sourceLocations = [""]
            routeFetchSetting.destinationLocations = [""]
        }
        
        routeFetchSetting.selectedAttributions = [.speed, .distance, .congestionLevel, .expectedTravelTime]
        
        demoSettings = [.showAutosuggestWidget, .profile, .resource, .sourceLocations, .destinationLocations, .viaLocations]
        
        if self.routeEngine == .predictive {
            demoSettings = [.showAutosuggestWidget, .profile, .alternativesCount, .sourceLocations, .destinationLocations, .viaLocations,
                            .length,
                            .width,
                            .height,
                            .weight,
                            .axleLoad,
                            .isHazmat]
        }
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @objc func doneButtonClicked() {
        if routeFetchSetting.sourceLocations.count > 0 && routeFetchSetting.destinationLocations.count > 0 {
            delegate?.settingsSelected(routeFetchSetting: routeFetchSetting)
            dismiss()
        } else {
            emptyFieldError()
        }
    }
    
    func emptyFieldError(){
        let alert = UIAlertController(title: "Empty Field!", message: "Please fill empty fields first.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func dismiss(){
        if let navVC = self.navigationController {
            navVC.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func textFieldValueChanged(_ textField: UITextField) {
        guard let customTextField = textField as? CustomUITextField, let tableRowIndexPath = customTextField.tableRowIndexPath else { return }
        
        let settingsType = demoSettings[tableRowIndexPath.section]
        
        let text =  textField.text ?? ""
        
        switch settingsType {
        case .sourceLocations:
            routeFetchSetting.sourceLocations[tableRowIndexPath.row] = text
        case .destinationLocations:
            routeFetchSetting.destinationLocations[tableRowIndexPath.row] = text
        case .viaLocations:
            routeFetchSetting.viaLocations[tableRowIndexPath.row] = text
        case .length:
            if let doubleValue = Double(text) {
                routeFetchSetting.vehicleDetails.length = doubleValue
            } else {
                routeFetchSetting.vehicleDetails.length = nil
            }
        case .width:
            if let doubleValue = Double(text) {
                routeFetchSetting.vehicleDetails.width = doubleValue
            } else {
                routeFetchSetting.vehicleDetails.width = nil
            }
        case .height:
            if let doubleValue = Double(text) {
                routeFetchSetting.vehicleDetails.height = doubleValue
            } else {
                routeFetchSetting.vehicleDetails.height = nil
            }
        case .weight:
            if let doubleValue = Double(text) {
                routeFetchSetting.vehicleDetails.weight = doubleValue
            } else {
                routeFetchSetting.vehicleDetails.weight = nil
            }
        case .axleLoad:
            if let doubleValue = Double(text) {
                routeFetchSetting.vehicleDetails.axleLoad = doubleValue
            } else {
                routeFetchSetting.vehicleDetails.axleLoad = nil
            }
        default:
            break
        }
    }
    
    @objc func locationButtonPressed(_ button: UIButton) {
        guard let customButton = button as? CustomUIButton, let tableRowIndexPath = customButton.tableRowIndexPath else { return }
        
        let settingsType = demoSettings[tableRowIndexPath.section]
        
        switch settingsType {
        case .sourceLocations, .destinationLocations, .viaLocations:
            indexPathForSourceOrDesitnation = tableRowIndexPath
            openAutocompleteController()
        default:
            break
        }
    }
    
    @objc func openAutocompleteController() {
        let autoCompleteVC = MapplsAutocompleteViewController()
        autoCompleteVC.delegate = self
        present(autoCompleteVC, animated: true, completion: nil)
    }
    
    @objc func addLocationButtonPressed(_ button: UIButton) {
        let section = button.tag
        let emptySourceFields = routeFetchSetting.sourceLocations.filter { (location) -> Bool in
            let newLocation = location.trimmingCharacters(in: .whitespacesAndNewlines)
            return newLocation.isEmpty
        }
        let emptyDestinationFields = routeFetchSetting.destinationLocations.filter { (location) -> Bool in
            let newLocation = location.trimmingCharacters(in: .whitespacesAndNewlines)
            return newLocation.isEmpty
        }
        let emptyViaFields = routeFetchSetting.viaLocations.filter { (location) -> Bool in
            let newLocation = location.trimmingCharacters(in: .whitespacesAndNewlines)
            return newLocation.isEmpty
        }
        if emptySourceFields.count > 0 || emptyDestinationFields.count > 0
            || emptyViaFields.count > 0 {
            let alert = UIAlertController(title: "Empty Field!", message: "Please fill empty fields first.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let settingsType = demoSettings[section]
            switch settingsType {
            case .sourceLocations:
                if mode == .direction && routeFetchSetting.sourceLocations.count >= 1 {
                    break
                }
                routeFetchSetting.sourceLocations.append("")
            case .destinationLocations:
                if mode == .direction && routeFetchSetting.destinationLocations.count >= 1 {
                    break
                }
                routeFetchSetting.destinationLocations.append("")
            case .viaLocations:
                routeFetchSetting.viaLocations.append("")
            default:
                break
            }
            
            self.tableView.reloadData()
        }
    }
    
    @objc func openActionSheetToChooseLocationType(selectedPlace: MapplsAtlasSuggestion) {
        let alterView = UIAlertController(title: "Select Mappls Pin or Coordinate", message: "Please select Mappls Pin or coordinate.", preferredStyle: .actionSheet)
        alterView.addAction(UIAlertAction(title: "Coordinate", style: .default, handler: { [self] (handler) in
            setCoordinateValueForSourceOrDestinationLocationField(selectedPlace: selectedPlace)
        }))
        alterView.addAction(UIAlertAction(title: "Mappls Pin", style: .default, handler: { [self] (handler) in
            setMapplsPinValueForSourceOrDestinationLocationField(selectedPlace: selectedPlace)
        }))
        alterView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (handler) in
        }))
        present(alterView, animated: true, completion: nil)
    }
    
    
    @objc func setCoordinateValueForSourceOrDestinationLocationField(selectedPlace: MapplsAtlasSuggestion) {
        guard let indexPath = indexPathForSourceOrDesitnation, let latitude = selectedPlace.latitude, let longitude = selectedPlace.longitude else { return }
        let settingsType = demoSettings[indexPath.section]
        switch settingsType {
        case .sourceLocations:
            routeFetchSetting.sourceLocations[indexPath.row] = "\(longitude),\(latitude)"
        case .destinationLocations:
            routeFetchSetting.destinationLocations[indexPath.row] = "\(longitude),\(latitude)"
        case .viaLocations:
            routeFetchSetting.viaLocations[indexPath.row] = "\(longitude),\(latitude)"
        default:
            break
        }
        tableView.reloadData()
    }
    
    @objc func openAttributionSetting(){
        let attributionVC = AttributionChooserVC()
        attributionVC.delegate = self
        self.navigationController?.pushViewController(attributionVC, animated: false)
    }
    
    @objc func setMapplsPinValueForSourceOrDestinationLocationField(selectedPlace: MapplsAtlasSuggestion) {
        guard let indexPath = indexPathForSourceOrDesitnation, let mapplsPin = selectedPlace.mapplsPin else { return }
        let settingsType = demoSettings[indexPath.section]
        switch settingsType {
        case .sourceLocations:
            routeFetchSetting.sourceLocations[indexPath.row] = mapplsPin
        case .destinationLocations:
            routeFetchSetting.destinationLocations[indexPath.row] = mapplsPin
        case .viaLocations:
            routeFetchSetting.viaLocations[indexPath.row] = mapplsPin
        default:
            break
        }
        tableView.reloadData()
    }
    
    @objc func openActionSheetToChooseResource() {
        let alterView = UIAlertController(title: "Select Mappls Pin or Coordinate", message: "Please select Mappls Pin or coordinate.", preferredStyle: .actionSheet)
        alterView.addAction(UIAlertAction(title: "default", style: .default, handler: { [self] (handler) in
            if mode == .distance {
                routeFetchSetting.selectedResourceDistance = .default
            } else if mode == .direction {
                routeFetchSetting.selectedResourceDirection = .routeAdv
            }
            tableView.reloadData()
        }))
        alterView.addAction(UIAlertAction(title: "eta", style: .default, handler: { [self] (handler) in
            if mode == .distance {
                routeFetchSetting.selectedResourceDistance = .eta
            } else if mode == .direction {
                routeFetchSetting.selectedResourceDirection = .routeETA
            }
            tableView.reloadData()
        }))
        alterView.addAction(UIAlertAction(title: "traffic", style: .default, handler: { [self] (handler) in
            if mode == .distance {
                routeFetchSetting.selectedResourceDistance = .traffic
            } else if mode == .direction {
                routeFetchSetting.selectedResourceDirection = .routeTraffic
            }
            tableView.reloadData()
        }))
        alterView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (handler) in
        }))
        present(alterView, animated: true, completion: nil)
    }
    
    @objc func openActionSheetToChooseProfile() {
        let alterView = UIAlertController(title: "Select Mappls Pin or Coordinate", message: "Please select Mappls Pin or coordinate.", preferredStyle: .actionSheet)
        alterView.addAction(UIAlertAction(title: "driving", style: .default, handler: { [self] (handler) in
            routeFetchSetting.selectedProfile = .driving
            tableView.reloadData()
        }))
        alterView.addAction(UIAlertAction(title: "walking", style: .default, handler: { [self] (handler) in
            routeFetchSetting.selectedProfile = .walking
            tableView.reloadData()
        }))
        alterView.addAction(UIAlertAction(title: "biking", style: .default, handler: { [self] (handler) in
            routeFetchSetting.selectedProfile = .biking
            tableView.reloadData()
        }))
        alterView.addAction(UIAlertAction(title: "trucking", style: .default, handler: { [self] (handler) in
            routeFetchSetting.selectedProfile = .trucking
            tableView.reloadData()
        }))
        alterView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (handler) in
        }))
        present(alterView, animated: true, completion: nil)
    }
    
    func getSwitchCell(indexPath: IndexPath) -> UITableViewCell {
        var returnCell = UITableViewCell()
        let cellIdentifier = "switchCell"
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            if let accessoryView = cell.accessoryView, accessoryView.isKind(of: UISwitch.self) {
                let switchView = accessoryView as! CustomUISwitch
                switchView.isOn = getValueForSwitchFromSetting(indexPath: indexPath)
                switchView.tableRowIndexPath = indexPath
            }
            returnCell = cell
        } else {
            let newCell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
            let switchView = CustomUISwitch(frame: .zero)
            switchView.isOn = getValueForSwitchFromSetting(indexPath: indexPath)
            switchView.tableRowIndexPath = indexPath // for detect which row switch Changed
            switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
            newCell.accessoryView = switchView
            returnCell = newCell
        }
        returnCell.textLabel?.text = getDescription(indexPath: indexPath)
        return returnCell
    }
    
    func getDescription(indexPath: IndexPath) -> String {
        let settingsType = demoSettings[indexPath.section]
        
        return settingsType.description
    }
    
    func getStringValueForSettings(indexPath: IndexPath) -> String {
        let settingsType = demoSettings[indexPath.section]
        
        switch settingsType {
        case .attributions:
            return "\(routeFetchSetting.selectedAttributions)"
        case .resource:
            return mode == .direction ? routeFetchSetting.selectedResourceDirection.rawValue : routeFetchSetting.selectedResourceDistance.rawValue
        case .sourceLocations:
            return routeFetchSetting.sourceLocations[indexPath.row]
        case .destinationLocations:
            return routeFetchSetting.destinationLocations[indexPath.row]
        case .viaLocations:
            return routeFetchSetting.viaLocations[indexPath.row]
        case .alternativesCount:
            return "\(self.routeFetchSetting.alternativesCount)"
        case .vehicleDetails:
            break
        case .showAutosuggestWidget:
            break
        case .profile:
            return "\(routeFetchSetting.selectedProfile.rawValue)"
        case .length:
            var returnString = ""
            if let length = routeFetchSetting.vehicleDetails.length {
                returnString = "\(length)"
            }
            return returnString
        case .width:
            var returnString = ""
            if let width = routeFetchSetting.vehicleDetails.width {
                returnString = "\(width)"
            }
            return returnString
        case .height:
            var returnString = ""
            if let height = routeFetchSetting.vehicleDetails.height {
                returnString = "\(height)"
            }
            return returnString
        case .weight:
            var returnString = ""
            if let weight = routeFetchSetting.vehicleDetails.weight {
                returnString = "\(weight)"
            }
            return returnString
        case .axleLoad:
            var returnString = ""
            if let axleLoad = routeFetchSetting.vehicleDetails.axleLoad {
                returnString = "\(axleLoad)"
            }
            return returnString
        case .isHazmat:
            return ""
        }
        
        return ""
    }
    
    @objc func getSubDescriptionForDetailTextCell(indexPath: IndexPath) -> String {
        let settingsType = demoSettings[indexPath.section]
        
        switch settingsType {
        case .resource:
            if mode == .distance {
                switch routeFetchSetting.selectedResourceDistance {
                case .default:
                    return "default"
                case .eta:
                    return "eta"
                case .traffic:
                    return "traffic"
                default:
                    return ""
                }
            } else if mode == .direction {
                switch routeFetchSetting.selectedResourceDirection {
                case .routeAdv:
                    return "default"
                case .routeETA:
                    return "eta"
                case .routeTraffic:
                    return "traffic"
                default:
                    return ""
                }
            }
        case .profile:
            return routeFetchSetting.selectedProfile.rawValue
        default:
            return ""
        }
        return ""
    }
    
    func getValueForSwitchFromSetting(indexPath: IndexPath) -> Bool {
        let settingsType = demoSettings[indexPath.section]
        
        switch settingsType {
        case .showAutosuggestWidget:
            return shouldOpenAutocomplete
        case .isHazmat:
            return routeFetchSetting.vehicleDetails.isHazmat
        default:
            break
        }
        
        return false
    }
    
    @objc func switchChanged(_ sender : UISwitch) {
        guard let customSwitch = sender as? CustomUISwitch, let tableRowIndexPath = customSwitch.tableRowIndexPath else { return }
        let settingsType = demoSettings[tableRowIndexPath.section]
        switch settingsType {
        case .showAutosuggestWidget:
            shouldOpenAutocomplete = sender.isOn
            self.tableView.reloadData()
        case .isHazmat:
            routeFetchSetting.vehicleDetails.isHazmat = sender.isOn
            self.tableView.reloadData()
        default:
            break
        }
    }
    
    func getTextFieldCell(indexPath: IndexPath) -> UITableViewCell {
        var returnCell = UITableViewCell()
        let cellIdentifier = "locationPickerTableCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? LocationPickerTableCell {
            returnCell = cell
        } else {
            let newCell = LocationPickerTableCell(style: .default, reuseIdentifier: cellIdentifier)
            newCell.locationTextField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
            newCell.autocompleteWidgetButton.addTarget(self, action: #selector(locationButtonPressed), for: .touchUpInside)
            returnCell = newCell
        }
        if let returnCell = returnCell as? LocationPickerTableCell {
            returnCell.locationTextField.tableRowIndexPath = indexPath
            returnCell.locationTextField.keyboardType = .default
            returnCell.locationTextField.text = getStringValueForSettings(indexPath: indexPath)
            
            returnCell.autocompleteWidgetButton.tableRowIndexPath = indexPath
            returnCell.layer.borderColor = UIColor.lightGray.cgColor
            returnCell.layer.borderWidth = 0.4
                
            let settingsType = demoSettings[indexPath.section]
            if numericTextFieldTypes.contains(settingsType) {
                returnCell.autocompleteWidgetButton.isHidden = true
                returnCell.locationTextField.keyboardType = .decimalPad
            } else {
                returnCell.autocompleteWidgetButton.isHidden = shouldOpenAutocomplete ? false : true
            }
        }
        
        return returnCell
    }
    
    func getStepperCell(indexPath: IndexPath) -> UITableViewCell {
        var returnCell = UITableViewCell()
        let cellIdentifier = "stepperCell"
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            if let accessoryView = cell.accessoryView, accessoryView.isKind(of: CustomUIStepper.self) {
                let stepper = accessoryView as! CustomUIStepper
                stepper.tableRowIndexPath = indexPath
                let stepperValue = getValueForStepperFromSetting(indexPath: indexPath)
                stepper.value = stepperValue
                cell.detailTextLabel?.text = "\(stepperValue)"
            }
            returnCell = cell
        } else {
            let newCell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
            let stepper = createGetStepperForSetting(indexPath: indexPath)
            stepper.tableRowIndexPath = indexPath
            stepper.addTarget(self, action: #selector(stepperChanged(_:)), for: .valueChanged)
            newCell.accessoryView = stepper
            let stepperValue = getValueForStepperFromSetting(indexPath: indexPath)
            stepper.value = stepperValue
            newCell.detailTextLabel?.text = "\(stepperValue)"
            returnCell = newCell
        }
        returnCell.textLabel?.text = getDescription(indexPath: indexPath)
        return returnCell
    }
    
    func getDetailTextCell(indexPath: IndexPath) -> UITableViewCell {
        var returnCell = UITableViewCell()
        let cellIdentifier = "detailTextCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier){
            returnCell = cell
        } else {
            let newCell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
            newCell.accessoryType = .disclosureIndicator
            returnCell = newCell
        }
        returnCell.textLabel?.text = getDescription(indexPath: indexPath)
        returnCell.detailTextLabel?.text = getStringValueForSettings(indexPath: indexPath)
        return returnCell
    }
    
    func getSubtitleCell(indexPath: IndexPath) -> UITableViewCell {
        var returnCell = UITableViewCell()
        let cellIdentifier = "attributionCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier){
            returnCell = cell
        }else {
            returnCell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
            returnCell.accessoryType = .disclosureIndicator
        }
        returnCell.textLabel?.text = getDescription(indexPath: indexPath)
        returnCell.detailTextLabel?.text = getStringValueForSettings(indexPath: indexPath)
        return returnCell
    }
    
    func createGetStepperForSetting(indexPath: IndexPath) -> CustomUIStepper {
        let stepper = CustomUIStepper(frame: .zero)
        stepper.minimumValue = 0
        stepper.maximumValue = 100
        stepper.stepValue = 10
        stepper.value = 0
        
        let settingsType = demoSettings[indexPath.section]
        switch settingsType {
        case .alternativesCount:
            stepper.minimumValue = 0
            stepper.maximumValue = 5
            stepper.stepValue = 1
            stepper.value = 0
        default:
            break
        }
        
        return stepper
    }
    
    @objc func stepperChanged(_ sender: UIStepper) {
        guard let customStepper = sender as? CustomUIStepper, let tableRowIndexPath = customStepper.tableRowIndexPath else { return }
        let settingsType = demoSettings[tableRowIndexPath.section]
        switch settingsType {
        case .alternativesCount:
            routeFetchSetting.alternativesCount = Int(customStepper.value)
        default:
            break
        }
        
        self.tableView.reloadRows(at: [tableRowIndexPath], with: .automatic)
    }
    
    func getValueForStepperFromSetting(indexPath: IndexPath) -> Double {
        let settingsType = demoSettings[indexPath.section]
        switch settingsType {
        case .alternativesCount:
            return Double(routeFetchSetting.alternativesCount)
        default:
            break
        }
        return 1
    }
    
    func getTableViewCell(indexPath: IndexPath) -> UITableViewCell {
        let settingsType = demoSettings[indexPath.section]
        switch settingsType {
        case .alternativesCount:
            return getStepperCell(indexPath: indexPath)
        case .attributions:
            return getSubtitleCell(indexPath: indexPath)
        case .profile:
            return getDetailTextCell(indexPath: indexPath)
        case .resource:
            return getDetailTextCell(indexPath: indexPath)
        case .showAutosuggestWidget, .isHazmat:
            return getSwitchCell(indexPath: indexPath)
        case .sourceLocations, .destinationLocations, .viaLocations, .length, .width, .height, .weight, .axleLoad:
            return getTextFieldCell(indexPath: indexPath)
        case .vehicleDetails:
            break
        }
        
        return UITableViewCell()
    }
}

extension RouteFetchSettingController {
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return demoSettings.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = demoSettings[section]
        switch currentSection {
        case .attributions:
            return (mode == .direction ? 1 : 0)
        case .sourceLocations:
            return routeFetchSetting.sourceLocations.count
        case .destinationLocations:
            return routeFetchSetting.destinationLocations.count
        case .viaLocations:
            return routeFetchSetting.viaLocations.count
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getTableViewCell(indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let settingsType = demoSettings[section]
        
        if settingsType == .sourceLocations
            || settingsType == .destinationLocations
            || settingsType == .viaLocations
            || settingsType == .length
            || settingsType == .width
            || settingsType == .height
            || settingsType == .weight
            || settingsType == .axleLoad {
            let viewHeader = UIView()
            viewHeader.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            
            let addButton = UIButton()
            addButton.translatesAutoresizingMaskIntoConstraints = false
            addButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            addButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
            addButton.layer.cornerRadius = 15
            addButton.layer.borderWidth = 1
            addButton.layer.borderColor = UIColor.white.cgColor
            addButton.setImage(UIImage(named: "plus.png"), for: .normal)
            addButton.imageView?.contentMode = .scaleAspectFit
            addButton.tag = section
            addButton.addTarget(self, action: #selector(addLocationButtonPressed), for: .touchUpInside)
            viewHeader.addSubview(addButton)
            
            let textLabel = UILabel()
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            textLabel.textColor = .white
            textLabel.font = UIFont.boldSystemFont(ofSize: 20)
            //text.textAlignment = .right
            textLabel.text = settingsType.description
            
            viewHeader.addSubview(textLabel)
            
            addButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
            addButton.heightAnchor.constraint(equalTo: addButton.widthAnchor).isActive = true
            addButton.trailingAnchor.constraint(equalTo: viewHeader.trailingAnchor, constant: -8).isActive = true
            addButton.centerYAnchor.constraint(equalTo: viewHeader.centerYAnchor, constant: 0).isActive = true
            //addButton.topAnchor.constraint(equalTo: viewHeader.topAnchor, constant: 10).isActive = true
            //addButton.bottomAnchor.constraint(equalTo: viewHeader.bottomAnchor, constant: -10).isActive = true
            
            textLabel.leftAnchor.constraint(equalTo: viewHeader.leftAnchor, constant: 8).isActive = true
            textLabel.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -8).isActive = true
            textLabel.centerYAnchor.constraint(equalTo: viewHeader.centerYAnchor, constant: 0).isActive = true
            //textLabel.topAnchor.constraint(equalTo: viewHeader.topAnchor, constant: 0).isActive = true
            //textLabel.bottomAnchor.constraint(equalTo: viewHeader.bottomAnchor, constant: 0).isActive = true
            
            addButton.isHidden = true
            
            if ((settingsType == .sourceLocations
                 || settingsType == .destinationLocations)
                    && mode == .distance)
                || (settingsType == .viaLocations && mode == .direction) {
                addButton.isHidden = false
            }
            
            return viewHeader
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let settingsType = demoSettings[indexPath.section]
        switch settingsType {
        case .attributions:
            openAttributionSetting()
        case .profile:
            openActionSheetToChooseProfile()
        case .resource:
            openActionSheetToChooseResource()
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let settingsType = demoSettings[section]
        switch settingsType {
        case .sourceLocations, .destinationLocations, .viaLocations, .length, .width, .height, .weight, .axleLoad:
            return 40
        default:
            break
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let settingsType = demoSettings[indexPath.section]
        if settingsType == .sourceLocations && mode == .distance {
            return true
        } else if settingsType == .destinationLocations && mode == .distance {
            return true
        } else {
            return false
        }
        
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let settingsType = demoSettings[indexPath.section]
            if settingsType == .sourceLocations && mode == .distance && routeFetchSetting.sourceLocations.count > 1 {
                routeFetchSetting.sourceLocations.remove(at: indexPath.row)
                tableView.reloadData()
            } else if settingsType == .destinationLocations && mode == .distance && routeFetchSetting.destinationLocations.count > 1 {
                routeFetchSetting.destinationLocations.remove(at: indexPath.row)
                 tableView.reloadData()
             }
        }
    }
    
}

extension RouteFetchSettingController: MapplsAutocompleteViewControllerDelegate {
    func didAutocomplete(viewController: MapplsUIWidgets.MapplsAutocompleteViewController, withFavouritePlace place: MapplsUIWidgets.MapplsUIWidgetAutosuggestFavouritePlace) {
        
    }
    
    func didAutocomplete(viewController: MapplsAutocompleteViewController, withSuggestion suggestion: MapplsSearchPrediction) {
        
    }
    
    
    
    func didAutocomplete(viewController: MapplsAutocompleteViewController, withPlace place: MapplsAtlasSuggestion, resultType type: MapplsAutosuggestResultType) {
        self.dismiss(animated: false) {
            if let _ = place.latitude, let _ = place.longitude {
                self.openActionSheetToChooseLocationType(selectedPlace: place)
            } else {
                self.setMapplsPinValueForSourceOrDestinationLocationField(selectedPlace: place)
            }
        }
    }
    
    func didFailAutocomplete(viewController: MapplsAutocompleteViewController, withError error: NSError) {
        
    }
    
    func wasCancelled(viewController: MapplsAutocompleteViewController) {
        
    }
}

extension RouteFetchSettingController:  AttributionChooserVCDelegate {
    func didSelectAttributions(attributions: [MapplsAttributeOptions]) {
        self.routeFetchSetting.selectedAttributions = attributions
    }
}
