import UIKit
import MapplsMap
import MapplsUIWidgets

protocol PlacePickerViewExampleVCDelegate: class {
    func didPickedLocation(viewController: PlacePickerViewExampleVC, placemark: MapplsGeocodedPlacemark)
    
    func didReverseGeocode(viewController: PlacePickerViewExampleVC, placemark: MapplsGeocodedPlacemark)
    
    func didCancelPlacePicker(pickerController: PlacePickerViewExampleVC)
}

class PlacePickerViewExampleVC: UIViewController {
    var mapView:MapplsMapView!
    public weak var delegate: PlacePickerViewExampleVCDelegate?
    
    var placePickerView: PlacePickerView!
    
    public var isForCustom: Bool = false
    
    
//    override class func demoTitle() -> String? {
//        return "Place Picker"
//    }
    
    func hexStringFromColor(color: UIColor) -> String {
        let components = color.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(format: "%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        print(hexString)
        return hexString
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = MapplsMapView()
        // Do any additional setup after loading the view.
        placePickerView = PlacePickerView(frame: self.view.bounds, parentViewController: self, mapView: mapView)
        
        placePickerView.isBuildingFootprintEnabled = UserDefaultsManager.isBuildingFootprintsOverlayEnabled
        
        if UserDefaultsManager.isUseDefaultStyleForBuildingAppearance == false {
            let buildingAppearance = MapplsBuildingAppearance()
            buildingAppearance.fillColor = "\(hexStringFromColor(color: UserDefaultsManager.placePickerBuildingLayerFillColor))"
            buildingAppearance.fillOpacity = "\(UserDefaultsManager.placePickerBuildingLayerFillOpacity)"
            buildingAppearance.strokeColor = "\(hexStringFromColor(color: UserDefaultsManager.placePickerBuildingLayerStrokeColor))"
            buildingAppearance.strokeOpacity = "\(UserDefaultsManager.placePickerBuildingLayerStrokeOpacity)"
            buildingAppearance.strokeWidth = "\(UserDefaultsManager.placePickerBuildingLayerStrokeWidth)"
            
            placePickerView.buildingAppearance = buildingAppearance
        }
        
        placePickerView.delegate = self
        self.view.addSubview(placePickerView)
        // placeView.autocompleAttributionsSetting
        let attributionSetting = MapplsAttributionsSettings()
        attributionSetting.attributionSize = MapplsContentSize(rawValue: UserDefaultsManager.attributionSize) ?? .medium
        attributionSetting.attributionHorizontalContentAlignment = MapplsHorizontalContentAlignment(rawValue: Int(UserDefaultsManager.attributionHorizontalAlignment)) ?? .center
        attributionSetting.attributionVerticalPlacement = MapplsVerticalPlacement(rawValue: UserDefaultsManager.attributionVerticalPlacement) ?? .before
        attributionSetting.attributionLogoType = MapplsAttributionLogoType(rawValue: UserDefaultsManager.attributionLogoType) ?? .auto
        placePickerView.autocompleteAttributionSettings = attributionSetting
        if isForCustom {
            let customView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 200))
            customView.backgroundColor = .red
            
            if UserDefaultsManager.isCustomMarkerView {
                placePickerView.markerView = customView
            }
            if UserDefaultsManager.isMarkerShadowViewHidden {
                placePickerView.isMarkerShadowViewHidden = true
            }
            
            //placePickerView.autocompleteFilter = MapplsAutocompleteFilter()
            
            if UserDefaultsManager.isCustomSearchButtonBackgroundColor {
                placePickerView.searchButtonBackgroundColor = .yellow
            }
            if UserDefaultsManager.isCustomSearchButtonImage {
                placePickerView.searchButtonImage = UIImage(named: "userSearch")!
            }
            if UserDefaultsManager.isSearchButtonHidden {
                placePickerView.isSearchButtonHidden = true
            }
            
            if UserDefaultsManager.isCustomPlaceNameTextColor {
                placePickerView.placeNameLabelTextColor = .blue
            }
            if UserDefaultsManager.isCustomAddressTextColor {
                placePickerView.addressLabelTextColor = .green
            }
            
            if UserDefaultsManager.isCustomPickerButtonTitleColor {
                placePickerView.pickerButtonTitleColor = .blue
            }
            if UserDefaultsManager.isCustomPickerButtonBackgroundColor {
                placePickerView.pickerButtonBackgroundColor = .yellow
            }
            if UserDefaultsManager.isCustomPickerButtonTitle {
                placePickerView.pickerButtonTitle = "Pick it"
            }
            
            if UserDefaultsManager.isCustomInfoLabelTextColor {
                placePickerView.infoLabelTextColor = .green
            }
            
            if UserDefaultsManager.isCustomInfoBottomViewBackgroundColor {
                placePickerView.infoBottomViewBackgroundColor = .gray
            }
            if UserDefaultsManager.isCustomPlaceDetailsViewBackgroundColor {
                placePickerView.placeDetailsViewBackgroundColor = .lightGray
            }
            if UserDefaultsManager.isInitializeWithCustomLocation {
                placePickerView.isInitializeWithCustomLocation = true
                placePickerView.mapView.setCenter(CLLocationCoordinate2DMake(28.612936, 77.229546), zoomLevel: 15, animated: false)
            }
            
            if UserDefaultsManager.isBottomInfoViewHidden {
                placePickerView.isBottomInfoViewHidden = true
            }
            if UserDefaultsManager.isBottomPlaceDetailViewHidden {
                placePickerView.isBottomPlaceDetailViewHidden = true
            }
        }
    }
}

extension PlacePickerViewExampleVC: PlacePickerViewDelegate {
    func didFailedReverseGeocode(error: NSError?) {
        if let error = error {
            // failed for error
        } else {
            // No results found
        }
    }
    
    func didPickedLocation(placemark: MapplsGeocodedPlacemark) {
        self.delegate?.didPickedLocation(viewController: self, placemark: placemark)
    }
    
    func didReverseGeocode(placemark: MapplsGeocodedPlacemark) {
        self.delegate?.didReverseGeocode(viewController: self, placemark: placemark)
    }
        
    func didCancelPlacePicker() {
        self.delegate?.didCancelPlacePicker(pickerController: self)
    }
}
