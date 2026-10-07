//
// SettingsVC.swift

//
//  Created by Apple on 06/08/20.
//  Copyright © 2022 Mappls. All rights reserved.
//

import UIKit
import MapplsAPIKit

class MapplsDemoSettingsVC: UITableViewController {
    
//    let demoSettings = DemoSettingType.allCases
    var demoSettings: [DemoSettingType] = []
    let placePickerSettings = PlacePickerSettingType.allCases
    let autocompleteSetttings = AutocompleteSettingType.allCases
    let identifierSettings = IdentifierSettingType.allCases
    let drivingRangeSettings = DrivingRangeSettingType.allCases
    var selectedOption = ""
    var didClicked : Bool = false
    
    var selectedPlacePickerSetting: PlacePickerSettingType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func switchChanged(_ sender : UISwitch) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let currentType = placePickerSettings[indexPath.row]
        
        if currentType == .isCustomMarkerView {
            UserDefaultsManager.isCustomMarkerView = sender.isOn
        } else if currentType == .isMarkerShadowViewHidden {
            UserDefaultsManager.isMarkerShadowViewHidden = sender.isOn
        } else if currentType == .isCustomSearchButtonBackgroundColor {
            UserDefaultsManager.isCustomSearchButtonBackgroundColor = sender.isOn
        } else if currentType == .isCustomSearchButtonImage {
            UserDefaultsManager.isCustomSearchButtonImage = sender.isOn
        } else if currentType == .isSearchButtonHidden {
            UserDefaultsManager.isSearchButtonHidden = sender.isOn
        } else if currentType == .isCustomPlaceNameTextColor {
            UserDefaultsManager.isCustomPlaceNameTextColor = sender.isOn
        } else if currentType == .isCustomAddressTextColor {
            UserDefaultsManager.isCustomAddressTextColor = sender.isOn
        } else if currentType == .isCustomPickerButtonTitleColor {
            UserDefaultsManager.isCustomPickerButtonTitleColor = sender.isOn
        } else if currentType == .isCustomPickerButtonBackgroundColor {
            UserDefaultsManager.isCustomPickerButtonBackgroundColor = sender.isOn
        } else if currentType == .isCustomPickerButtonTitle {
            UserDefaultsManager.isCustomPickerButtonTitle = sender.isOn
        } else if currentType == .isCustomInfoLabelTextColor {
            UserDefaultsManager.isCustomInfoLabelTextColor = sender.isOn
        } else if currentType == .isCustomInfoBottomViewBackgroundColor {
            UserDefaultsManager.isCustomInfoBottomViewBackgroundColor = sender.isOn
        } else if currentType == .isCustomPlaceDetailsViewBackgroundColor {
            UserDefaultsManager.isCustomPlaceDetailsViewBackgroundColor = sender.isOn
        } else if currentType == .isInitializeWithCustomLocation {
            UserDefaultsManager.isInitializeWithCustomLocation = sender.isOn
        } else if currentType == .isBottomInfoViewHidden {
            UserDefaultsManager.isBottomInfoViewHidden = sender.isOn
        } else if currentType == .isBottomPlaceDetailViewHidden {
            UserDefaultsManager.isBottomPlaceDetailViewHidden = sender.isOn
        } else if currentType == .isBuildingFootprintsOverlayEnabled {
           UserDefaultsManager.isBuildingFootprintsOverlayEnabled = sender.isOn
        } else if currentType == .isUseDefaultStyleForBuildingAppearance {
            UserDefaultsManager.isUseDefaultStyleForBuildingAppearance = sender.isOn
        }
    }
    
    func presentAlertConrollerForDefaultController(currentType: AutocompleteSettingType, didClicked: Bool) -> Int {
 
        let alertController = UIAlertController(title: "Customize attributes?", message: "Select type of attribute you want in search Widgets ", preferredStyle: .actionSheet)
        
        switch currentType {
        case .horizontalAlignment:
            let selectedOptions = 1
            alertController.addAction(UIAlertAction(title: "Left", style: .default, handler: { (alertAction) in
                UserDefaultsManager.attributionHorizontalAlignment = 0
                self.tableView.reloadData()
            }))
            alertController.addAction(UIAlertAction(title: "Center", style: .default, handler: { (alertAction) in
                UserDefaultsManager.attributionHorizontalAlignment = 1
                self.tableView.reloadData()
            }))
            alertController.addAction(UIAlertAction(title: "Right", style: .default, handler: { (alertAction) in
                UserDefaultsManager.attributionHorizontalAlignment = 2
                self.tableView.reloadData()
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
            }))
            if didClicked{
                present(alertController, animated: false, completion: nil)
            }
            
            return selectedOptions
            
        case .attributionSize:
            let selectedOptions = 2
            alertController.addAction(UIAlertAction(title: "Small", style: .default, handler: { (alertAction) in
                UserDefaultsManager.attributionSize = 0
                self.tableView.reloadData()
            }))
            alertController.addAction(UIAlertAction(title: "Medium", style: .default, handler: { (alertAction) in
                UserDefaultsManager.attributionSize = 1
                self.tableView.reloadData()
            }))
            alertController.addAction(UIAlertAction(title: "Large", style: .default, handler: { (alertAction) in
                UserDefaultsManager.attributionSize = 2
                self.tableView.reloadData()
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
            
            }))
            if didClicked{
                present(alertController, animated: false, completion: nil)
            }
            return selectedOptions
            
        case .attributionVerticalPlacement:
            let selectedOptions = 3
            alertController.addAction(UIAlertAction(title: "Top", style: .default, handler: { (alertAction) in
                
                UserDefaultsManager.attributionVerticalPlacement = 0
                self.tableView.reloadData()
            }))
            alertController.addAction(UIAlertAction(title: "Bottom", style: .default, handler: { (alertAction) in
                
                UserDefaultsManager.attributionVerticalPlacement = 1
                self.tableView.reloadData()
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
            }))
            
            if didClicked{
                present(alertController, animated: false, completion: nil)
            }
            return selectedOptions
        case .attributionLogoType:
            let selectedOptions = 4
            if didClicked {
                let vc = ItemPickerViewController(pickerViewType: .logoType)
                vc.modalPresentationStyle = .overFullScreen
                vc.delegate = self
                present(vc, animated: false, completion: nil)
            }
            return selectedOptions
        }
    }
    
    func setIdentifierValue(currentType: IdentifierSettingType, didClicked: Bool) -> String {
        let alertController = UIAlertController(title: "Customize attributes?", message: "Select type of attribute you want in search Widgets ", preferredStyle: .actionSheet)
        switch currentType {
        case .profileIdentifier:
            alertController.addAction(UIAlertAction(title: "Driving", style: .default, handler: { (alertAction) in
                UserDefaultsManager.profileIdentifier = MapplsDirectionsProfileIdentifier.driving.rawValue
                self.tableView.reloadData()
            }))
            alertController.addAction(UIAlertAction(title: "Walking", style: .default, handler: { (alertAction) in
                UserDefaultsManager.profileIdentifier = MapplsDirectionsProfileIdentifier.walking.rawValue
                self.tableView.reloadData()
            }))
            alertController.addAction(UIAlertAction(title: "Biking", style: .default, handler: { (alertAction) in
                UserDefaultsManager.profileIdentifier = MapplsDirectionsProfileIdentifier.biking.rawValue
                self.tableView.reloadData()
            }))
            alertController.addAction(UIAlertAction(title: "Truking", style: .default, handler: { (alertAction) in
                UserDefaultsManager.profileIdentifier = MapplsDirectionsProfileIdentifier.trucking.rawValue
                self.tableView.reloadData()
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
            
            }))
            if didClicked{
                present(alertController, animated: false, completion: nil)
            }
            return UserDefaultsManager.profileIdentifier
        case .resourceIdentifier:
            alertController.addAction(UIAlertAction(title: "Default", style: .default, handler: { (alertAction) in
                UserDefaultsManager.resourceIdentifier = MapplsDirectionsResourceIdentifier.routeAdv.rawValue
                self.tableView.reloadData()
            }))
            alertController.addAction(UIAlertAction(title: "Eta", style: .default, handler: { (alertAction) in
                UserDefaultsManager.resourceIdentifier = MapplsDirectionsResourceIdentifier.routeETA.rawValue
                self.tableView.reloadData()
            }))
            alertController.addAction(UIAlertAction(title: "Trrafic", style: .default, handler: { (alertAction) in
                UserDefaultsManager.resourceIdentifier = MapplsDirectionsResourceIdentifier.routeTraffic.rawValue
                self.tableView.reloadData()
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
            
            }))
            if didClicked{
                present(alertController, animated: false, completion: nil)
            }
            return UserDefaultsManager.resourceIdentifier
        }
    }
    
    func setDrivingRangeValue(currentType: DrivingRangeSettingType, didClicked: Bool) -> String {
        let alertController = UIAlertController(title: "Customize attributes?", message: "Select type of attribute you want in search Widgets ", preferredStyle: .actionSheet)
        switch currentType {
        case .location:
            return UserDefaultsManager.profileIdentifier
        case .rangeInfo:
            alertController.addAction(UIAlertAction(title: "Time", style: .default, handler: { (alertAction) in
                self.showInputTimeTextField(title: "Time", unit: "mins")
            }))
            alertController.addAction(UIAlertAction(title: "Distance", style: .default, handler: { (alertAction) in
                self.showInputTimeTextField(title: "Distance", unit: "mtrs")
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
            
            }))
            if didClicked{
                present(alertController, animated: false, completion: nil)
            }
            return UserDefaultsManager.resourceIdentifier
            
        case .showLocations:
            return UserDefaultsManager.resourceIdentifier
        case .speedInfo:
            return UserDefaultsManager.resourceIdentifier
        }
    }
    
    
    func showInputTimeTextField(title: String, unit: String) {
        let alert = UIAlertController(title: title, message: "Please input \(title) in \(unit)", preferredStyle: .alert)
        
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter time"
            textField.keyboardType = .numberPad
        }
        
        let action = UIAlertAction(title: "Done", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            if (textField.text ?? "").isEmpty {
                
            } else {
                
            }
        }
        
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getValueForPlacePickerSetting(_ placePickerSetting : PlacePickerSettingType) -> Bool {
        switch placePickerSetting {
        case .isCustomMarkerView:
            return UserDefaultsManager.isCustomMarkerView
        case .isMarkerShadowViewHidden:
            return UserDefaultsManager.isMarkerShadowViewHidden
        case .isCustomSearchButtonBackgroundColor:
            return UserDefaultsManager.isCustomSearchButtonBackgroundColor
        case .isCustomSearchButtonImage:
            return UserDefaultsManager.isCustomSearchButtonImage
        case .isSearchButtonHidden:
            return UserDefaultsManager.isSearchButtonHidden
        case .isCustomPlaceNameTextColor:
            return UserDefaultsManager.isCustomPlaceNameTextColor
        case .isCustomAddressTextColor:
            return UserDefaultsManager.isCustomAddressTextColor
        case .isCustomPickerButtonTitleColor:
            return UserDefaultsManager.isCustomPickerButtonTitleColor
        case .isCustomPickerButtonBackgroundColor:
            return UserDefaultsManager.isCustomPickerButtonBackgroundColor
        case .isCustomPickerButtonTitle:
            return UserDefaultsManager.isCustomPickerButtonTitle
        case .isCustomInfoLabelTextColor:
            return UserDefaultsManager.isCustomInfoLabelTextColor
        case .isCustomInfoBottomViewBackgroundColor:
            return UserDefaultsManager.isCustomInfoBottomViewBackgroundColor
        case .isCustomPlaceDetailsViewBackgroundColor:
            return UserDefaultsManager.isCustomPlaceDetailsViewBackgroundColor
        case .isInitializeWithCustomLocation:
            return UserDefaultsManager.isInitializeWithCustomLocation
        case .isBottomInfoViewHidden:
            return UserDefaultsManager.isBottomInfoViewHidden
        case .isBottomPlaceDetailViewHidden:
            return UserDefaultsManager.isBottomPlaceDetailViewHidden
        case .isBuildingFootprintsOverlayEnabled:
            return UserDefaultsManager.isBuildingFootprintsOverlayEnabled
        case .isUseDefaultStyleForBuildingAppearance:
            return UserDefaultsManager.isUseDefaultStyleForBuildingAppearance
        case .placePickerBuildingLayerFillColor, .placePickerBuildingLayerFillOpacity,
                .placePickerBuildingLayerStrokeColor, .placePickerBuildingLayerStrokeOpacity,
                .placePickerBuildingLayerStrokeWidth:
            return false
        }
    }
    
    func getColorFromSetting(setting: PlacePickerSettingType) -> UIColor {
        switch setting {
        case .placePickerBuildingLayerFillColor:
            return UserDefaultsManager.placePickerBuildingLayerFillColor
        case .placePickerBuildingLayerStrokeColor:
            return UserDefaultsManager.placePickerBuildingLayerStrokeColor
        default:
            break
        }
        
        return .white
    }
    
    func getValueForStepperFromSetting(setting: PlacePickerSettingType) -> Double {
        switch setting {
        case .placePickerBuildingLayerFillOpacity:
            return UserDefaultsManager.placePickerBuildingLayerFillOpacity
        case .placePickerBuildingLayerStrokeOpacity:
            return UserDefaultsManager.placePickerBuildingLayerStrokeOpacity
        case .placePickerBuildingLayerStrokeWidth:
            return UserDefaultsManager.placePickerBuildingLayerStrokeWidth
        default:
            return 0.1
        }
    }
    
    func getValueForAutocompleteLogoOptions(_ autocompleteSetting: AutocompleteSettingType) -> String {
        
        let intValue = presentAlertConrollerForDefaultController(currentType: autocompleteSetting, didClicked: false)
        if intValue == 1 {
            switch UserDefaultsManager.attributionHorizontalAlignment {
            case 0:
                return "Left"
            case 1:
                return "Center"
            case 2:
                return "Right"
            default:
                return ""
            }
        } else if intValue == 2 {
            switch UserDefaultsManager.attributionSize {
            case 0:
                return "Small"
            case 1:
                return "Medium"
            case 2:
                return "Large"
            default:
                return ""
            }
        } else if intValue == 3 {
            switch UserDefaultsManager.attributionVerticalPlacement {
            case 0:
                return "Top"
            case 1:
                return "Bottom"
            default:
                return ""
            }
        } else if intValue == 4 {
            switch UserDefaultsManager.attributionLogoType {
            case 0:
                return "Auto"
            case 1:
                return "Mappls|MapmyIndia"
            case 2:
                return "Mappls"
            case 3:
                return "MapmyIndia"
            default:
                return ""
            }
        } else {
            return ""
        }
    }
    
    @objc func colorButtonPressed(_ sender : UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: Int(DemoSettingType.placePicker.rawValue))
        let setting = placePickerSettings[indexPath.row]
        selectedPlacePickerSetting = setting
        openColorPickerController()
    }
    
    func createGetStepperForSetting(setting: PlacePickerSettingType) -> UIStepper {
        let stepper = UIStepper(frame: .zero)
        stepper.minimumValue = 0
        stepper.maximumValue = 1
        stepper.stepValue = 0.1
        stepper.value = 0.3
        
        switch setting {
        case.placePickerBuildingLayerStrokeWidth:
            stepper.minimumValue = 0
            stepper.maximumValue = 10
            stepper.stepValue = 0.1
            stepper.value = 0.3
        default:
            break
        }
        
        return stepper
    }
    
    @objc func stepperChanged(_ sender: UIStepper) {
        let indexRow = sender.tag
        let setting = placePickerSettings[indexRow]
        switch setting {
        case .placePickerBuildingLayerFillOpacity:
            UserDefaultsManager.placePickerBuildingLayerFillOpacity = sender.value
        case .placePickerBuildingLayerStrokeOpacity:
            UserDefaultsManager.placePickerBuildingLayerStrokeOpacity = sender.value
        case .placePickerBuildingLayerStrokeWidth:
            UserDefaultsManager.placePickerBuildingLayerStrokeWidth = sender.value
        default:
            break
        }
        
        let indexPath = IndexPath(row: indexRow, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    @objc func openColorPickerController() {
        let colorPickerVC = ColorPickerViewController(nibName: nil, bundle: nil)
        colorPickerVC.delegate = self
        colorPickerVC.modalPresentationStyle = .fullScreen
        self.navigationController?.present(colorPickerVC, animated: true, completion: nil)
    }
}

//MARK:- Table View Controller Methods
extension MapplsDemoSettingsVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return demoSettings.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = demoSettings[section]
        switch currentSection {
        case .placePicker:
            return placePickerSettings.count
        case .autocomplete:
            return autocompleteSetttings.count
        case .Identifier:
            return identifierSettings.count
        case .DrivingRange:
            return drivingRangeSettings.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let currentSection = demoSettings[section]
        switch currentSection {
        case .placePicker:
            return "Place Picker"
        case .autocomplete:
            return "Autocomplete Logo Settings"
        case .Identifier:
            return "Identifier Setting"
        case .DrivingRange:
            return "Driving Range Setting"
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection = demoSettings[indexPath.section]
        
        if currentSection == .placePicker {
            var returnCell = UITableViewCell()
            let currentType = placePickerSettings[indexPath.row]
            switch currentType {
            case .placePickerBuildingLayerFillColor, .placePickerBuildingLayerStrokeColor:
                let cellIdentifier = "colorPickerCell"
                if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
                    if let colorButton = cell.accessoryView, colorButton.isKind(of: UIButton.self) {
                        colorButton.backgroundColor = getColorFromSetting(setting: currentType)
                        colorButton.tag = indexPath.row
                    }
                    returnCell = cell
                } else {
                    let newCell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
                    newCell.textLabel?.text = currentType.description
                    let colorButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                    colorButton.backgroundColor = getColorFromSetting(setting: currentType)
                    colorButton.tag = indexPath.row
                    colorButton.addTarget(self, action: #selector(colorButtonPressed(_:)), for: .touchUpInside)
                    newCell.accessoryView = colorButton
                    returnCell = newCell
                }
            case .placePickerBuildingLayerFillOpacity, .placePickerBuildingLayerStrokeOpacity, .placePickerBuildingLayerStrokeWidth:
                let cellIdentifier = "stepperCell"
                if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
                    if let accessoryView = cell.accessoryView, accessoryView.isKind(of: UIStepper.self) {
                        let stepper = accessoryView as! UIStepper
                        stepper.tag = indexPath.row
                        let stepperValue = getValueForStepperFromSetting(setting: currentType)
                        stepper.value = stepperValue
                        cell.detailTextLabel?.text = String(format: "%.1f", stepperValue)
                    }
                    returnCell = cell
                } else {
                    let newCell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
                    newCell.textLabel?.text = currentType.description
                    let stepper = createGetStepperForSetting(setting: currentType)
                    stepper.tag = indexPath.row
                    stepper.addTarget(self, action: #selector(stepperChanged(_:)), for: .valueChanged)
                    newCell.accessoryView = stepper
                    let stepperValue = getValueForStepperFromSetting(setting: currentType)
                    stepper.value = stepperValue
                    newCell.detailTextLabel?.text = String(format: "%.1f", stepperValue)
                    returnCell = newCell
                }
            default:
                let cellIdentifier = "switchCell"
                if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
                    if let accessoryView = cell.accessoryView, accessoryView.isKind(of: UISwitch.self) {
                        let switchView = accessoryView as! UISwitch
                        switchView.isOn = getValueForPlacePickerSetting(currentType)
                        switchView.tag = indexPath.row
                    }
                    returnCell = cell
                } else {
                    let newCell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
                    newCell.textLabel?.text = currentType.description
                    let switchView = UISwitch(frame: .zero)
                    switchView.isOn = getValueForPlacePickerSetting(currentType)
                    switchView.tag = indexPath.row // for detect which row switch Changed
                    switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
                    newCell.accessoryView = switchView
                    returnCell = newCell
                }
            }
            
            return returnCell
        }
        else if currentSection == .autocomplete {
            let cellIdentifier = "autocompleteOptions"
            let currentType = autocompleteSetttings[indexPath.row]
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier){
                cell.detailTextLabel?.text = getValueForAutocompleteLogoOptions(currentType)
                return cell
            }else{
                let newCell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
                newCell.accessoryType = .disclosureIndicator
                newCell.textLabel?.text = currentType.description
                newCell.detailTextLabel?.text = getValueForAutocompleteLogoOptions(currentType)
                return newCell
            }  
        }
        else if currentSection == .Identifier {
            let cellIdentifier = "identifier"
            let currentType = identifierSettings[indexPath.row]
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier){
                cell.detailTextLabel?.text = setIdentifierValue(currentType: currentType, didClicked: false)
                return cell
            }else{
                let newCell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
                newCell.accessoryType = .disclosureIndicator
                newCell.textLabel?.text = currentType.description
                newCell.detailTextLabel?.text = setIdentifierValue(currentType: currentType, didClicked: false)
                return newCell
            }
        } else if currentSection == .DrivingRange {
            let cellIdentifier = "drivingRange"
            let currentType = drivingRangeSettings[indexPath.row]
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier){
                cell.detailTextLabel?.text = setDrivingRangeValue(currentType: currentType, didClicked: false)
                return cell
            }else{
                let newCell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
                newCell.accessoryType = .disclosureIndicator
                newCell.textLabel?.text = currentType.description
                newCell.detailTextLabel?.text = setDrivingRangeValue(currentType: currentType, didClicked: false)
                return newCell
            }
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentSection = demoSettings[indexPath.section]
        if currentSection == .autocomplete{
            let currentType = autocompleteSetttings[indexPath.row]
            didClicked = true
            _ = presentAlertConrollerForDefaultController(currentType: currentType, didClicked: didClicked)
        }
        else if currentSection == .Identifier {
            let currentType = identifierSettings[indexPath.row]
            _ = setIdentifierValue(currentType: currentType, didClicked: true)
        } else if currentSection == .DrivingRange {
            let currentType = drivingRangeSettings[indexPath.row]
            _ = setDrivingRangeValue(currentType: currentType, didClicked: true)
        }
       
    }
}

extension MapplsDemoSettingsVC: ColorPickerViewControllerDelegate {
    func didPickedColor(color: UIColor) {
        if let setting = selectedPlacePickerSetting {
            switch setting {
            case .placePickerBuildingLayerFillColor:
                UserDefaultsManager.placePickerBuildingLayerFillColor = color
            case .placePickerBuildingLayerStrokeColor:
                UserDefaultsManager.placePickerBuildingLayerStrokeColor = color
            default:
                break
            }
            
            if let indexRow = placePickerSettings.firstIndex(of: setting) {
                let indexPath = IndexPath(row: indexRow, section: Int(DemoSettingType.placePicker.rawValue))
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        selectedPlacePickerSetting = nil
    }
    
    func didCancelColorPicker() {
        selectedPlacePickerSetting = nil
    }
}

extension MapplsDemoSettingsVC: ItemPickerViewControllerDelegate {
    func itemSelected(sender: ItemPickerViewController, item: Int) {
        let pickerType = sender.pickerViewType
        switch pickerType {
        case .logoType:
            UserDefaultsManager.attributionLogoType = item
            self.tableView.reloadData()
        default:
            break
        }
    }
}

public enum DemoSettingType: UInt, CustomStringConvertible, CaseIterable {
    case placePicker
    case autocomplete
    case Identifier
    case DrivingRange
    
    public var description: String{
        switch self {
        case .placePicker:
            return "Place Picker"
        case .autocomplete:
            return "Autocomplete"
        case .Identifier:
            return "Identifier"
        case .DrivingRange:
            return "DrivingRange"
        
        }
    }
}

public enum AutocompleteSettingType: UInt, CustomStringConvertible, CaseIterable{
    
    case attributionSize
    case horizontalAlignment
    case attributionVerticalPlacement
    case attributionLogoType
    
    public var description: String{
        switch self {
        case .horizontalAlignment:
            return "Attribution Horizontal Alignment"
        case .attributionSize:
            return "Attribution Size"
        case .attributionVerticalPlacement:
            return "Attribution Vertical Placement"
        case .attributionLogoType:
            return "Attribution Logo Type"
        }
    }
}

public enum IdentifierSettingType: UInt, CustomStringConvertible, CaseIterable {
    case profileIdentifier
    case resourceIdentifier
    public var description: String {
        switch self {
        case .profileIdentifier:
            return "Profile Identifier"
        case .resourceIdentifier:
            return "Resource Identifier"
        }
    }
}

public enum DrivingRangeSettingType: UInt, CustomStringConvertible, CaseIterable {
    case rangeInfo
    case speedInfo
    case location
    case showLocations
    public var description: String {
        switch self {
        case .rangeInfo:
            return "Range Info"
        case .speedInfo:
            return "Speed Info"
        case .location:
            return "Location"
        case .showLocations:
            return "Show Locations"
            
        }
    }
}

public enum PlacePickerSettingType: UInt, CustomStringConvertible, CaseIterable {
    case isCustomMarkerView
    case isMarkerShadowViewHidden
    case isCustomSearchButtonBackgroundColor
    case isCustomSearchButtonImage
    case isSearchButtonHidden
    case isCustomPlaceNameTextColor
    case isCustomAddressTextColor
    case isCustomPickerButtonTitleColor
    case isCustomPickerButtonBackgroundColor
    case isCustomPickerButtonTitle
    case isCustomInfoLabelTextColor
    case isCustomInfoBottomViewBackgroundColor
    case isCustomPlaceDetailsViewBackgroundColor
    case isInitializeWithCustomLocation
    case isBottomInfoViewHidden
    case isBottomPlaceDetailViewHidden
    
    case isBuildingFootprintsOverlayEnabled
    case isUseDefaultStyleForBuildingAppearance
    case placePickerBuildingLayerFillColor
    case placePickerBuildingLayerFillOpacity
    case placePickerBuildingLayerStrokeColor
    case placePickerBuildingLayerStrokeOpacity
    case placePickerBuildingLayerStrokeWidth
    
    public var description: String {
        switch self {
        case .isCustomMarkerView:
            return "Custom Marker"
        case .isMarkerShadowViewHidden:
            return "Marker Shadow Hidden"
        case .isCustomSearchButtonBackgroundColor:
            return "Search Button Custom Back Color"
        case .isCustomSearchButtonImage:
            return "Search Button Custom Image"
        case .isSearchButtonHidden:
            return "Search Button Hidden"
        case .isCustomPlaceNameTextColor:
            return "Place Name Custom Text Color"
        case .isCustomAddressTextColor:
            return "Address Custom Text Color"
        case .isCustomPickerButtonTitleColor:
            return "Picker Button Custom Title Color"
        case .isCustomPickerButtonBackgroundColor:
            return "Picker Button Custom Back Color"
        case .isCustomPickerButtonTitle:
            return "Picker Button Custom Title"
        case .isCustomInfoLabelTextColor:
            return "Info Label Custom Text Color"
        case .isCustomInfoBottomViewBackgroundColor:
            return "Info View Custom Back Color"
        case .isCustomPlaceDetailsViewBackgroundColor:
            return "Place Detail View Custom Back Color"
        case .isInitializeWithCustomLocation:
            return "Custom Initial Location"
        case .isBottomInfoViewHidden:
            return "Info View Hidden"
        case .isBottomPlaceDetailViewHidden:
            return "Place Details View Hidden"
            
        case .isBuildingFootprintsOverlayEnabled:
            return "Enable Building Layer"
        case .isUseDefaultStyleForBuildingAppearance:
            return "Default Style For Building"
        case .placePickerBuildingLayerFillColor:
            return "Building Fill Color"
        case .placePickerBuildingLayerFillOpacity:
            return "Building Fill Opacity"
        case .placePickerBuildingLayerStrokeColor:
            return "Building Stroke Color"
        case .placePickerBuildingLayerStrokeOpacity:
            return "Building Stroke Opacity"
        case .placePickerBuildingLayerStrokeWidth:
            return "Building Stroke Width"
        }
    }
}
