import UIKit
import MapplsUtils
import CoreLocation
import MapplsMap

class MapRouteViewController: UIViewController {
    
    private var polyline: MGLPolyline?
    private var points: [CLLocationCoordinate2D] = []
    private var mapView: MapplsMapView!
    private var startAnnotation: MGLPointAnnotation?
    private var endAnnotation: MGLPointAnnotation?
    
    var trackingPlugin: MapplsTrackingPlugin!
    var route: Route? {
        didSet {
            guard let route = route, let coordinates = route.coordinates else {
                return
            }
            self.allCoordinate = coordinates
            
            let waypints = route.routeOptions.waypoints
            
            for (index, waypoint) in waypoints.enumerated() {
                let annotation = MGLPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: waypoint.latitude, longitude: waypoint.longitude)
                if index == 0 {
                    annotation.title = "source"
                } else if index == waypints.count - 1 {
                    annotation.title = "destination"
                } else {
                    annotation.title = "waypoint"
                }
                mapView.addAnnotation(annotation)
                
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.fitMap()
            }
        }
    }
    
    var currentIndex = 0
    var startCoordinate: CLLocationCoordinate2D?
    
    override func viewWillDisappear(_ animated: Bool) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        if let trackingPlugin = trackingPlugin {
            trackingPlugin.stopTracking()
        }
        
    }
    
    deinit {
        print("deinit: MapRouteViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MapplsMapView(frame: self.view.bounds)
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.showsUserLocation = true
        let longTapGesutre = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation))
        mapView.addGestureRecognizer(longTapGesutre)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        mapView.addGestureRecognizer(tapGesture)
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let userLocation = self.mapView.userLocation?.coordinate, CLLocationCoordinate2DIsValid(userLocation) {
                self.mapView.userTrackingMode = .none
            }
        }
        
        getWaypointRoute()
    }
    
    func fitMap(){
        let insets = view.safeAreaInsets
        print("padding: viewSafeAreaInsetsDidChange: \(insets)")
        
        let edgePadding = UIEdgeInsets(
            top: insets.top + 20,
            left: insets.left + 20,
            bottom: insets.bottom + 20,
            right: insets.right + 20
        )
        
        guard let route = route else {
            print("No current route available to fit.")
            return
        }
//        mapView.sizeToFit()
        self.fit(to: route, padding: edgePadding, animated: true)
        
    }
    
    @objc func updateMarker(gestureRecognizer: UIGestureRecognizer) {
        guard trackingPlugin != nil else { return }
        
        let touchPoint = gestureRecognizer.location(in: mapView)
        let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = MGLPointAnnotation()
        annotation.coordinate = newCoordinates
        annotation.title = "routeAnnotation"
        mapView.addAnnotation(annotation)
        
    }
    
    func removeMarker() {
        if let annotations = self.mapView.annotations {
            for annotation in annotations {
                if annotation.title == "routeAnnotation" {
                    mapView.removeAnnotation(annotation)
                }
            }
        }
    }
    var isAnimationEnded = false
    var lastKnowLocation: CLLocationCoordinate2D?
    var nextPoint: CLLocationCoordinate2D?
    var destinationCoordinate: CLLocationCoordinate2D?
    var waypoints: [CLLocationCoordinate2D] = []
    
    var allCoordinate = [CLLocationCoordinate2D]()
    var hasStartedSimulation = false
    var isInteractionLocked = false
    
    @objc func tapGesture(gestureRecognizer: UIGestureRecognizer) {
        guard let route = self.route, let coordinates = route.coordinates else { return }
        
        let touchPoint = gestureRecognizer.location(in: mapView)
        let tappedCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let annotation = MGLPointAnnotation()
//        annotation.coordinate = tappedCoordinate
//        mapView.addAnnotation(annotation)

        trackingPlugin.update(with: tappedCoordinate, duration: config.speedInMillis)
 
        
        lastKnowLocation = tappedCoordinate
        isAnimationEnded = false
    }
    
    func getWaypointRoute() {
        
        let sourceCoordinate = CLLocationCoordinate2D(latitude: 28.09, longitude: 77.323)
        
        let desitnation = CLLocationCoordinate2D(latitude: 29.09, longitude: 78.323)
        
//        guard let source = config.sourceLocation else {
//            return
//        }
//        guard let destination = config.destinationLocation else {
//            return
//        }
        self.calculateRoute(start: sourceCoordinate,  end: desitnation)
     }

    func reloadWaypointsOnMap() {
//        trackingPlugin?.updateWaypointMarkerIcon()
    }
    
    var isForSlowAnitation = false
    @objc func addAnnotation(gestureRecognizer: UIGestureRecognizer) {
        guard gestureRecognizer.state == .began else {
            return
        }
 
    }
    var config = MapplsTrackingPluginConfig()
    func calculateRoute(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) {
        let sourcePlacemark = Waypoint(coordinate: start)
        let destinationPlacemark = Waypoint(coordinate: end)
        let directionRequest = RouteOptions(waypoints: [sourcePlacemark, destinationPlacemark])
        directionRequest.profileIdentifier = .driving
        directionRequest.resourceIdentifier = .routeETA
        
        _ = Directions(restKey: MapplsAccountManager.restAPIKey()).calculate(directionRequest) { waypoints, routes, error in
            if let routes = routes, let _ = routes.first?.coordinates {
                self.route = routes.first
                 
                self.trackingPlugin = MapplsTrackingPlugin(mapView: self.mapView, route: self.route!, config: self.config)
//                self.trackingPlugin.config.viaPointMarkerImage = UIImage(named: "custom-waypoint-icon")
//                self.trackingPlugin.config.viaPointIconName = "custom-waypoint-icon"
                self.trackingPlugin.delegate = self
            }
        }
        print(Directions.shared.url(forCalculating: directionRequest))
    }
    
    func calculateRoute(start: CLLocationCoordinate2D, waypoints: [CLLocationCoordinate2D], end: CLLocationCoordinate2D) {
        let sourceWaypoint = Waypoint(coordinate: start)

        let waypointPlacemarks = waypoints.map { Waypoint(coordinate: $0) }
        let destinationWaypoint = Waypoint(coordinate: end)
        let allWaypoints = [sourceWaypoint] + waypointPlacemarks + [destinationWaypoint]
        let directionRequest = RouteOptions(waypoints: allWaypoints)
        directionRequest.profileIdentifier = .driving
        directionRequest.resourceIdentifier = .routeETA

        _ = Directions(restKey: MapplsAccountManager.restAPIKey()).calculate(directionRequest) { waypoints, routes, error in
            if let routes = routes, let _ = routes.first?.coordinates {
                self.route = routes.first
                self.trackingPlugin = MapplsTrackingPlugin(mapView: self.mapView, route: self.route!, config: self.config)
                self.trackingPlugin.delegate = self
            }
        }
    }

    
    
    @objc func startNavigation() {
        guard let coordinates = route?.coordinates else {
            return
        }
        if coordinates.indices.contains(currentIndex) {
            let coordinate = coordinates [currentIndex]
            trackingPlugin.update(with: coordinate, duration: config.speedInMillis)
            currentIndex = currentIndex + 4
        }
        perform(#selector(startNavigation), with: nil , afterDelay: 2)
    }
}


extension MapRouteViewController: MapplsTrackingPluginDelegate {
    
    func mapplsTrackingPlugin(_ mapView: MapplsMapView?, didArriveAt coordinate: CLLocationCoordinate2D) {
        
    }
    
    func mapplsTrackingPlugin(_ mapView: MapplsMapView?, didRerouted route: MapplsAPIKit.Route?, error: NSError?) {
        
    }
    
    func mapplsTrackingPlugin(_ mapView: MapplsMapView?, willRerouted route: MapplsAPIKit.Route?) {
        
    }
    
    func mapplsTrackingPlugin(_ mapView: MapplsMapView?, remainingDistanceDidChange remaningDistance: Double?) {
        if let remaningDistance = remaningDistance {
            print("remaningDistance:\(remaningDistance)")
        }
    }
    
    func getRouteLayer(source: MGLShapeSource, identifier: String) -> MGLLineStyleLayer {
        let line = MGLLineStyleLayer(identifier: identifier, source: source)
        line.lineColor = NSExpression(forConstantValue: UIColor.green)
        line.lineWidth =  NSExpression(forConstantValue: 10)
        line.lineCap = NSExpression(forConstantValue: NSValue(mglLineCap: .round))
        line.lineJoin = NSExpression(forConstantValue: NSValue(mglLineJoin: .round))
        return line
    }
    
    func onAnimationEnd(animator: MapplsObjectAnimator<CLLocationCoordinate2D, LatLngEvaluator>) {
        print("on animation end")
    }
}

extension CLLocationCoordinate2D {
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let destination=CLLocation(latitude:from.latitude,longitude:from.longitude)
        return CLLocation(latitude: latitude, longitude: longitude).distance(from: destination)
    }
}


extension MapRouteViewController: MapplsMapViewDelegate {
    func mapView(_ mapView: MapplsMapView, authorizationCompleted isSuccess: Bool, withError error: Error?) {
        if let error = error {
            print("error :\(error.localizedDescription)")
        } else {
            print(isSuccess)
        }
    }
    func mapView(_ mapView: MGLMapView, regionIsChangingWith reason: MGLCameraChangeReason) {
        if trackingPlugin != nil {
            trackingPlugin.regionIsChanging(mapView: mapView)
        }
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: any MGLAnnotation) -> MGLAnnotationView? {
        if trackingPlugin != nil {
            if let view = trackingPlugin.get3DMarkerForUserLocation(for: annotation, reuseIdentifier: "3dObjectIdentifier") {
                return view
            }
        }
        guard annotation is MGLPointAnnotation else {
            return nil
        }
        let castAnnotation = annotation as? MGLPointAnnotation
        if castAnnotation?.title  == "rider-icon" {
            
            let reuseIdentifier = "StartPoint"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
            if annotationView != nil {
                return annotationView
            } else {
                annotationView = RotatableAnnotationView(reuseIdentifier: reuseIdentifier, image: config.markerImage!)
                return annotationView
            }
           
            
        }
         
        return nil
    }
}

extension [CLLocationCoordinate2D] {
    func closestIndex(to coordinate: CLLocationCoordinate2D) -> Int? {
        var closestIndex: Int?
        var smallestDistance = Double.greatestFiniteMagnitude

        for (index, coord) in self.enumerated() {
            let distance = coord.distance(from: coordinate)
            if distance < smallestDistance {
                smallestDistance = distance
                closestIndex = index
            }
        }
        return closestIndex
    }
}

extension MapRouteViewController {
    
    /// Fits the map view camera to the provided route.
    ///
    /// - Parameters:
    ///   - route: A `Route` object holding the coordinates to fit.
    ///   - direction: Optional facing direction (default: 0).
    ///   - padding: Edge insets around the route (default: 20 on all sides).
    ///   - animated: Whether to animate the camera movement (default: false).
    func fit(to route: Route,
             facing direction: CLLocationDirection = 0,
             padding: UIEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
             animated: Bool = false) {
        
        // Enable frame-by-frame tracking if available
     
        guard let coords = route.coordinates, !coords.isEmpty else {
            debugPrint("⚠️ No coordinates found in route; skipping fit.")
            return
        }
        
        // Build polyline from coordinates
        let line = MGLPolyline(coordinates: coords, count: UInt(coords.count))
        
        
        // Reset pitch if map is tilted
        if mapView.camera.pitch > 5 {
            var flatCamera = mapView.camera
            flatCamera.pitch = 0
            mapView.setCamera(flatCamera, animated: false)
        }
        
        // Calculate camera to fit the line
        let fitCamera = mapView.cameraThatFitsShape(line, direction: direction, edgePadding: padding)
        
        if animated {
            mapView.setCamera(fitCamera, withDuration: 0.01, animationTimingFunction: .none) {
                self.resetNorthSafely()
            }
        } else {
            mapView.setCamera(fitCamera, animated: false)
            self.resetNorthSafely()
        }
        
     }
    
    /// Safely resets the map’s north orientation if supported.
    private func resetNorthSafely() {
//        if responds(to: #selector(resetNorth)) {
//            self.resetNorth()
//        }
    }
    
}
