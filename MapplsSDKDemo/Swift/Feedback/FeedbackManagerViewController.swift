import UIKit
import MapplsMap
import MapplsUIWidgets
import MapplsFeedbackKit
import MapplsFeedbackUIKit

class FeedbackManagerViewControllerSample: UIViewController {
    var mapView:MapplsMapView!
    
    public weak var delegate: PlacePickerViewExampleVCDelegate?
    
    var placePickerView: PlacePickerView!
    
    var refLocations = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = MapplsMapView()
        placePickerView = PlacePickerView(frame: self.view.bounds, parentViewController: self, mapView: mapView)
        placePickerView.delegate = self
        self.view.addSubview(placePickerView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleFeedbackSubmit), name: .feedbackSubmitSuccessNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleFeedbackFailed), name: .feedbackSubmitFailedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleReportCategoriesFetchSuccess), name: .reportCategoriesFetchSuccessNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleReportCategoriesFetchFailed), name: .reportCategoriesFetchFailedNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .feedbackSubmitSuccessNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .feedbackSubmitFailedNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .reportCategoriesFetchSuccessNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .reportCategoriesFetchFailedNotification, object: nil)
    }
    
    @objc public func handleFeedbackSubmit() {
        let alertController = UIAlertController(title: "Success", message: "Feedback Submitted Successfully!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc public func handleFeedbackFailed() {
        let alertController = UIAlertController(title: "Failed", message: "Feedback Submission Failed!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc public func handleReportCategoriesFetchSuccess() {
        let alertController = UIAlertController(title: "Success", message: "Report Categories Fetched Successfully!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc public func handleReportCategoriesFetchFailed() {
        let alertController = UIAlertController(title: "Failed", message: "Report Categories Fetching Failed!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    public func presentFeedbackControllerWithNavigationConroller() {
        let navVC = MapplsFeedbackUIKitManager.shared.getViewController(location: refLocations, appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, osVersionoptional: UIDevice.current.systemVersion, deviceName: UIDevice.current.name, theme: .night)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    
    public func pushFeedbackController() {
        let navVC = MapplsFeedbackUIKitManager.shared.getController(location: refLocations, appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, osVersionoptional: UIDevice.current.systemVersion, deviceName: UIDevice.current.name, theme: .auto)
        navVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(navVC, animated: true)
    }
}

extension FeedbackManagerViewControllerSample: PlacePickerViewDelegate {
    func didFailedReverseGeocode(error: NSError?) {
        if let error = error {
            // failed for error
        } else {
            // No results found
        }
    }
    
    func didPickedLocation(placemark: MapplsGeocodedPlacemark) {
        if let lat = placemark.longitude, let long = placemark.longitude {
            self.refLocations = "\(lat),\(long)"
        }
        
        let alertController = UIAlertController(title: "Choose Launch Type?", message: "Select type of launch of Controller", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Present", style: .default, handler: { (alertAction) in
            self.dismiss(animated: true) {
                self.presentFeedbackControllerWithNavigationConroller()
            }
        }))
        alertController.addAction(UIAlertAction(title: "Push", style: .default, handler: { (alertAction) in
            self.dismiss(animated: true) {
                self.pushFeedbackController()
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func didReverseGeocode(placemark: MapplsGeocodedPlacemark) {
        
    }
        
    func didCancelPlacePicker() {
        
    }
}
