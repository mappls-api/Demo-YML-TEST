import UIKit
import MapplsAPIKit
import MapplsMap
class DemoNearbyReportViewController: UIViewController {
    var mapView: MapplsMapView!
    let progressHUD = ProgressHUD(text: "Loading..")
    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance;
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show Result", style: .plain, target: self, action: #selector(getNearbyReport))
        
        mapView = MapplsMapView(frame: self.view.bounds)
        mapView.delegate = self
        mapView.zoomLevel = 14
        self.view.addSubview(mapView)
        
        mapView.setMapCenterAtMapplsPin("mmi000", animated: false, completionHandler: nil)
        self.view.addSubview(progressHUD)
        progressHUD.hide()
    }
    var reports: [MapplsNearbyReports] =  [MapplsNearbyReports]()
    @objc func getNearbyReport() {
        progressHUD.show()
        let report = MapplsNearbyReportManager.shared
        let mapBound = mapView.visibleCoordinateBounds
        let bound = MapplsRectangularRegion(topLeft: mapBound.sw, bottomRight: mapBound.ne)
        let options = MapplsNearbyReportOptions(bound: bound)
        report.getNearbyReportResult(options) { placemarks, error in
            if let error = error {
                let alertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (alertAction) in
                    self.dismiss(animated: false, completion: nil)
                }))
                self.present(alertController, animated: false, completion: nil)
                self.progressHUD.hide()
                print(error.localizedDescription)
            } else {
                if let response : MapplsNearbyReportResponse = placemarks {
                    if let reports: [MapplsNearbyReports] = response.reports {
                        self.reports = reports
                        self.removeAnnotations()
                        self.addAnnotations()
                        self.progressHUD.hide()
                    }
                }
            }
        }
    }
    
    func addAnnotations() {
        var annotations = [MGLPointAnnotation]()
        for report in self.reports {
            let annotation = MGLPointAnnotation()
            if let lat = report.latitude, let long = report.longitude {
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                annotation.coordinate = coordinate
                let cat = report.category ?? report.parentCategory ?? report.childCategory ?? ""
                annotation.title =  "\(cat)"
                annotations.append(annotation)
            }
        }
        self.mapView.addAnnotations(annotations)
        self.mapView.showAnnotations(annotations, animated: true)
    }
    func removeAnnotations() {
        if let annotations = mapView.annotations {
            for annotation in annotations {
                mapView.removeAnnotation(annotation)
            }
            
        }
    }
}

extension DemoNearbyReportViewController : MapplsMapViewDelegate {
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}
