
import UIKit
//import MapplsAPIKit
import MapplsMap
import MapplsGeofenceUI

class DefaultGeofenceVC: UIViewController,MapplsGeofenceViewDelegate {
    func didDragGeofence(isdragged: Bool) {
        
    }
    
    func hasIntersectPoints(_ shape: MapplsGeofenceShape) {
        
    }
    
    func circleRadiusChanged(radius: Double) {
        print(radius)
    }
    
    func didPolygonReachedMaximumPoints() {
        
    }
    func geofenceModeChanged(mode: MapplsOverlayShapeGeometryType) {
        if mode == .circle {
            
        }
        else if mode == .polygon {
        
        }
    }
    
    func geofenceShapeDidChanged(_ shape: MapplsGeofenceShape) {
        print(shape)
        print(shape.circleCenterCoordinate as Any)
        print(shape.polygonCoords as Any)
        print(shape.type?.rawValue ?? "")
        print(shape.circleRadius as Any)
        
    }
    
    var mapView: MapplsMapView!
    var geofenceView: MapplsGeofenceView!
    public var shapeEdit1: Bool?
    public var editShapeIndex1: Int?
    public var editGeofence1: MapplsGeofenceShape?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Geofence View"
        self.view.backgroundColor = .white
        self.setupGeofenceView()
        self.setupGeofenceConfiguration()
    }
    
    func setupGeofenceView() {
        geofenceView = MapplsGeofenceView.init(geofenceframe: view.bounds)
        geofenceView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        geofenceView.delegate = self
        self.view.addSubview(geofenceView)
    }
    func setupGeofenceConfiguration() {
        
        geofenceView.setMode(mode: .circle)
        geofenceView.draggingEdgesLineColor = UserDefaultsManager.draggingEdgesLineColor
        geofenceView.isShowDeleteControl = true
        geofenceView.isShowDrawingOverlayComponents = true
        geofenceView.polygonDrawingOverlayColor = UserDefaultsManager.polygonDrawingOverlayColor
        geofenceView.convertPointsToClockWise(pointsType: .antiClockWise)
        
        geofenceView.isShowDefaultModePanel = false
        geofenceView.isShowDefaultSliderForCircle = false
        
        geofenceView.circleFillColor = UserDefaultsManager.circleFillColor
        geofenceView.circleStrokeColor = UserDefaultsManager.circleStrokeColor
    }
    
}
