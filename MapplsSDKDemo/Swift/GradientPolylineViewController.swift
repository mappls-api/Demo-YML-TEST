
import UIKit
import MapplsMap
import MapplsAPICore
import MapplsDirectionUI

class GradientPolylineViewController: UIViewController {

    var mapView: MapplsMapView!
    
    let lineSourceIdentifier = "lineSourceIdentifier"
    let lineLayerIdentifier = "lineLayerIdentifier"
    
    override func loadView() {
        super.loadView()
        setUpMapView()
        applyConstraint()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setUpMapView() {
        mapView = MapplsMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    func applyConstraint() {
        mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }
    
}

//MARK: - MapView Delegates
extension GradientPolylineViewController: MapplsMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        mapView.setCenter(CLLocationCoordinate2D(latitude: 28.55106676597232, longitude: 77.26892899885115), zoomLevel: 15, animated: true)
        
        let currentWayPoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 28.551067906813493, longitude: 77.26890925366251), name: "Current Location")
        let destinationWayPoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 28.610231934703265, longitude: 77.22905502962782), name: "Destination")
        
        let options = RouteOptions(waypoints: [currentWayPoint, destinationWayPoint])
        Directions().calculate(options) { waypoints, routes, error in
            if let coordinates = routes?.first?.coordinates {
                self.addPolylineLayer(coordinates: coordinates)
            }
        }
    }
    
}

//MARK: - Add Update PolyLine
extension GradientPolylineViewController {
    
    func addPolylineLayer(coordinates: [CLLocationCoordinate2D]) {
        
        let stops = [0: UIColor.red,
                     0.1: UIColor.yellow,
                     0.3: UIColor.green,
                     0.5: UIColor.cyan,
                     0.7: UIColor.systemBlue,
                     1: UIColor.blue]
        
        guard let style = self.mapView.style else { return }
        let sourceFeatures = getSourceFeatures(coordinates: coordinates)
        // Create source and add it to the map style.
        let sourceOptions: [MGLShapeSourceOption: Any] = [.lineDistanceMetrics: true]
        let source = MGLShapeSource(identifier: lineSourceIdentifier, shape: sourceFeatures, options: sourceOptions)
        
        if let existingSource = style.source(withIdentifier: lineSourceIdentifier) as? MGLShapeSource {
            existingSource.shape = sourceFeatures
        } else {
            style.addSource(source)
            let polylineLayer = MGLLineStyleLayer(identifier: lineLayerIdentifier, source: source)
            polylineLayer.lineWidth = NSExpression(forConstantValue: 8)
            polylineLayer.lineGradient = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($lineProgress, 'linear', nil, %@)", stops)
            style.addLayer(polylineLayer)
        }
        
    }
    
    func getSourceFeatures(coordinates: [CLLocationCoordinate2D]) -> MGLPolylineFeature? {
        var coordinatess = coordinates
        let polyline = MGLPolylineFeature(coordinates: &coordinatess, count: UInt(coordinatess.count))
        let edgePadding = UIEdgeInsets(top: 10, left: 50, bottom: 10, right: 50)
        let camera = mapView.cameraThatFitsCoordinateBounds(polyline.overlayBounds, edgePadding: edgePadding)
        mapView.setCamera(camera, animated: true)
        return polyline
    }
    
}
