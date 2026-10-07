import Foundation
import MapplsMap
import MapplsAPIKit

typealias CongestionSegment = ([CLLocationCoordinate2D], CongestionLevel)
typealias CoordinateForWayPointWithIndex = (Int, CLLocationCoordinate2D)
public let MoveCongestionAttribute = "congestion"
public let MoveCurrentLegAttribute = "isCurrentLeg"


extension UIColor {
    
    class var defaultRouteLayer: UIColor { get { return #colorLiteral(red: 0, green: 0.6134340167, blue: 0.9874320626, alpha: 1) } }
    class var defaultAlternateLine: UIColor { get { return #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1) } }
    class var defaultAlternateLineCasing: UIColor { get { return #colorLiteral(red: 0.5019607843, green: 0.4980392157, blue: 0.5019607843, alpha: 1) } }
    class var defaultManeuverArrowStroke: UIColor { get { return .defaultRouteLayer } }
    class var defaultManeuverArrow: UIColor { get { return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) } }
    
    class var defaultLaneArrowPrimary: UIColor { get { return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) } }
    class var defaultLaneArrowSecondary: UIColor { get { return #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 1) } }
    
    class var trafficUnknown: UIColor { get { return defaultRouteLayer } }
    class var trafficLow: UIColor { get { return defaultRouteLayer } }
    class var trafficModerate: UIColor { get { return #colorLiteral(red: 0.9529411765, green: 0.6509803922, blue: 0.3098039216, alpha: 1) } }
    class var trafficHeavy: UIColor { get { return #colorLiteral(red: 0.9137254902, green: 0.2, blue: 0.2509803922, alpha: 1) } }
    class var trafficSevere: UIColor { get { return #colorLiteral(red: 0.5411764706, green: 0.05882352941, blue: 0.2196078431, alpha: 1) } }
    class var trafficAlternateLow: UIColor { get { return #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) } }
}




open class PolylineLayerPlugin: NSObject {
    public var mapView: MapplsMapView!
    
    // Define colors for different traffic conditions and route alternatives
    public var routeAlternateColor: UIColor = .defaultAlternateLine
    public var trafficUnknownColor: UIColor = .trafficUnknown
    public var trafficLowColor: UIColor = .trafficLow
    public var trafficModerateColor: UIColor = .trafficModerate
    public var trafficHeavyColor: UIColor = .trafficHeavy
    public var trafficSevereColor: UIColor = .trafficSevere
    
    // Assign marker images
    public var sourceMarkerImage: UIImage? = UIImage(named: "source-location-pin")
    public var destinationMarkerImage: UIImage? = UIImage(named: "destination-icon")
    public var waypointMarkerImage: UIImage? = UIImage(named: "viapoint-image")
    
    private var routes: [Route]?
    private var tapGestureDistanceThreshold: CGFloat = 50
    
    // Initialize the plugin with a MapplsMapView
    init(mapView: MapplsMapView) {
        self.mapView = mapView
    }
    
    /// Selects a route based on a CGPoint (typically from a tap gesture).
    /// - Parameter point: The CGPoint representing the location where the user tapped.
    /// - Returns: A tuple containing an array of routes and the index of the selected route, or nil if no route is selected.
    public func selectRoute(point: CGPoint) -> (routes: [Route]?, selectedIndex: Int)? {
        // Get routes that are close to the tapped point
        if let closestRoutes = routes(closeTo: point),
           let firstClosestRoute = closestRoutes.first,
           let index = self.routes?.firstIndex(of: firstClosestRoute) {
            if let routeArray = self.routes {
                // Render the polyline for the selected route
                self.renderRoutePolyline(routes: routeArray, focusedRouteIndex: index)
            }
            return (routes: self.routes, selectedIndex: index)
        }
        return nil
    }

    /// Finds routes that are close to a given CGPoint.
    /// - Parameter point: The CGPoint representing the location where the user tapped.
    /// - Returns: An array of routes that are close to the tapped point.
    private func routes(closeTo point: CGPoint) -> [Route]? {
        let tapCoordinate = self.mapView.convert(point, toCoordinateFrom: self.mapView)
        
        // Filter routes that have at least 2 coordinates
        guard let routes = routes?.filter({ $0.coordinates?.count ?? 0 > 1 }) else { return nil }
        
        // Sort routes by the closest distance to the tap gesture
        let closest = routes.sorted { (left, right) -> Bool in
            let leftLine = Polyline(left.coordinates!)
            let rightLine = Polyline(right.coordinates!)
            let leftDistance = leftLine.closestCoordinate(to: tapCoordinate)!.distance
            let rightDistance = rightLine.closestCoordinate(to: tapCoordinate)!.distance
            
            return leftDistance < rightDistance
        }
        
        // Filter the closest routes by those within a certain distance threshold
        let candidates = closest.filter {
            let closestCoordinate = Polyline($0.coordinates!).closestCoordinate(to: tapCoordinate)!.coordinate
            let closestPoint = self.mapView.convert(closestCoordinate, toPointTo: self.mapView)
            
            return closestPoint.distance(to: point) < tapGestureDistanceThreshold
        }
        return candidates
    }

    /// Renders the polyline for the selected routes and adjusts the visible region to focus on the selected route.
    /// - Parameters:
    ///   - routes: An array of routes to be rendered.
    ///   - focusedRouteIndex: The index of the route to be focused on.
    ///   - legIndex: The index of the leg within the focused route to be highlighted (default is 0).
    ///   - edgeInset: The edge insets for the visible region (optional).
    public func renderRoutePolyline(routes: [Route], focusedRouteIndex: Int = 0, legIndex: Int = 0, edgeInset: UIEdgeInsets? = nil){
        guard let style = mapView.style else { return }
        
        self.routes = routes
        let focusedRoute = routes[focusedRouteIndex]
        
        // Generate the polyline shape for the routes
        let polylines = polylineShape(for: routes, focusedRoute: focusedRoute, legIndex: legIndex)
        
        // Add or update the source and layer for the route polyline
        if let source = style.source(withIdentifier: LayerIdentifiers.Route.sourceIdentifier) as? MGLShapeSource {
            source.shape = polylines
        } else {
            let lineSource = MGLShapeSource(identifier: LayerIdentifiers.Route.sourceIdentifier, shape: polylines, options: nil)
            style.addSource(lineSource)
            
            let line = routeStyleLayer(identifier: LayerIdentifiers.Route.layerIdentifier, source: lineSource)
            for layer in style.layers.reversed() {
                if layer is MGLSymbolStyleLayer {
                    style.insertLayer(line, below: layer)
                    break
                }
            }
        }
        
        // Show waypoints for the selected route
        self.showWaypoints(focusedRoute, 0, focusedRoute.routeOptions.waypoints)
        
        // Adjust the visible region to focus on the selected route with specified edge insets
        let polylineToBeFocused = MGLPolyline(coordinates: focusedRoute.coordinates!, count: UInt(focusedRoute.coordinates?.count ?? 0))
        let edgeInsetsForVisibleBound: UIEdgeInsets
        
        if let edgeInsets = edgeInset {
            edgeInsetsForVisibleBound = edgeInsets
        } else {
            edgeInsetsForVisibleBound = UIEdgeInsets(top: mapView.frame.height * 0.1,
                                                     left: mapView.frame.width * 0.1,
                                                     bottom: mapView.frame.height * 0.1,
                                                     right: mapView.frame.width * 0.1)
        }
        self.mapView.setVisibleCoordinateBounds(polylineToBeFocused.overlayBounds, edgePadding: edgeInsetsForVisibleBound, animated: true) {}
    }

    /// Creates polyline features for the given coordinates.
    /// - Parameter coordinates: An array of CLLocationCoordinate2D representing the route coordinates.
    /// - Returns: An array of `MGLPolylineFeature` objects representing the route polyline.
    private func getPolylines(coordinates: [CLLocationCoordinate2D]) -> [MGLPolylineFeature] {
        var lines: [MGLPolylineFeature] = []
        let polyline = MGLPolylineFeature(coordinates: coordinates, count: UInt(coordinates.count))
        polyline.attributes["isAlternateRoute"] = true
        polyline.attributes["symbol-sort-key"] = -1
        lines.append(polyline)
        return lines
    }

    /// Displays waypoints for the given route.
    /// - Parameters:
    ///   - route: The route for which waypoints will be displayed.
    ///   - legIndex: The index of the current leg within the route (default is 0).
    ///   - waypoints: An array of waypoints to be displayed.
    private func showWaypoints(_ route: Route, _ legIndex: Int = 0, _ waypoints: [Waypoint]) {
        var coordinatesForWaypoints = [CoordinateForWayPointWithIndex]()
        for (index, waypoint) in waypoints.enumerated() {
            coordinatesForWaypoints.append(((legIndex + index), waypoint.coordinate))
        }
        self.showWaypointForDirections(selectedRoute: route, coordinates: coordinatesForWaypoints)
    }

    /// Displays waypoint annotations on the map.
    /// - Parameters:
    ///   - selectedRoute: The selected route containing waypoints.
    ///   - coordinates: An array of tuples where each tuple contains the index and coordinate of a waypoint.
    private func showWaypointForDirections(selectedRoute: Route, coordinates: [(Int, CLLocationCoordinate2D)]) {
        guard let style = mapView.style else { return }
        var pointFeatureArray = [MGLPointFeature]()
        
        for coordinate in coordinates {
            if coordinate.0 == 0 {
                let sourcePointFeature = MGLPointFeature()
                sourcePointFeature.title = "directions-source-marker"
                sourcePointFeature.coordinate = coordinate.1
                sourcePointFeature.attributes = [
                    "iconName": "directions-source-icon"
                ]
                
                // Set the source icon image if not already set
                if let _ = style.image(forName: "directions-source-icon") {
                    // Image already set
                } else {
                    if let image = sourceMarkerImage {
                        style.setImage(image, forName: "directions-source-icon")
                    } else {
                        print("Image not found")
                    }
                }
                
                pointFeatureArray.append(sourcePointFeature)
            } else if coordinate.0 == selectedRoute.routeOptions.waypoints.count - 1 {
                let destinationPointFeature = MGLPointFeature()
                destinationPointFeature.title = "directions-destination-marker"
                destinationPointFeature.coordinate = coordinate.1
                destinationPointFeature.attributes = [
                    "iconName": "directions-destination-icon",
                ]
                
                // Set the destination icon image if not already set
                if let _ = style.image(forName: "directions-destination-icon") {
                    // Image already set
                } else {
                    if let image = destinationMarkerImage {
                        style.setImage(image, forName: "directions-destination-icon")
                    } else {
                        print("Image not found2")
                    }
                }
                pointFeatureArray.append(destinationPointFeature)
                
            } else {
                let waypointPointFeature = MGLPointFeature()
                waypointPointFeature.title = "directions-waypoint-marker"
                waypointPointFeature.coordinate = coordinate.1
                waypointPointFeature.attributes = [
                    "iconName": "directions-waypoint-icon",
                    "waypointNumber": coordinate.0
                ]
                
                // Set the waypoint icon image if not already set
                if let _ = style.image(forName: "directions-waypoint-icon") {
                    // Image already set
                } else {
                    if let image = waypointMarkerImage {
                        style.setImage(image, forName: "directions-waypoint-icon")
                    } else {
                        print("Image not found3")
                    }
                }
                
                pointFeatureArray.append(waypointPointFeature)
            }
        }
        
        // Create a shape collection of waypoint features
        let pointCollectionShape = MGLShapeCollectionFeature(shapes: pointFeatureArray)
        
        // Add or update the source and layer for waypoint icons
        if let source = style.source(withIdentifier: LayerIdentifiers.Waypoints.directionSourceIdentifier) as? MGLShapeSource {
            source.shape = pointCollectionShape
        } else {
            let destinationIconSource = MGLShapeSource(identifier: LayerIdentifiers.Waypoints.directionSourceIdentifier, shape: pointCollectionShape, options: nil)
            style.addSource(destinationIconSource)
            
            let destinationLayer = getDestinationIconStyle(identifier: LayerIdentifiers.Waypoints.directionLayerIdentifier, source: destinationIconSource)
            if let routeLayer = style.layers.last {
                style.insertLayer(destinationLayer, above: routeLayer)
            } else {
                style.addLayer(destinationLayer)
            }
        }
    }
    
    /// Generates a polyline shape for the given routes, with congestion information added to the focused route.
    /// - Parameters:
    ///   - routes: An array of routes to be displayed as alternative routes.
    ///   - focusedRoute: The route that is currently focused and will have congestion information added.
    ///   - legIndex: The index of the leg within the focused route to be highlighted (optional).
    /// - Returns: An `MGLShape` representing the collection of polylines for the routes with congestion information.
    private func polylineShape(for routes: [Route], focusedRoute: Route, legIndex: Int?) -> MGLShape? {
        // Add congestion information to the focused route
        guard let congestedRoute = addCongestion(to: focusedRoute, legIndex: legIndex) else { return nil }
        
        var altRoutes: [MGLPolylineFeature] = []
        
        // Generate polylines for alternative routes
        for route in routes.suffix(from: 0) {
            let lines = self.getPolylines(coordinates: route.coordinates!)
            altRoutes.append(contentsOf: lines)
        }
        
        // Return a shape collection featuring the congested route and alternative routes
        return MGLShapeCollectionFeature(shapes: congestedRoute + altRoutes)
    }

    /// Configures the style layer for destination icons.
    /// - Parameters:
    ///   - identifier: The identifier for the style layer.
    ///   - source: The source data for the style layer.
    /// - Returns: An `MGLStyleLayer` configured with the destination icon style.
    private func getDestinationIconStyle(identifier: String, source: MGLSource) -> MGLStyleLayer {
        let symbolLayer = MGLSymbolStyleLayer(identifier: identifier, source: source)
        symbolLayer.iconImageName = NSExpression(forKeyPath: "iconName")
        symbolLayer.iconScale = NSExpression(forConstantValue: 1)
        symbolLayer.iconAnchor = NSExpression(forConstantValue: NSValue(mglIconAnchor: .bottom))
        symbolLayer.text = NSExpression(forKeyPath: "waypointNumber")
        symbolLayer.textAnchor = NSExpression(forConstantValue: -30)
        symbolLayer.textFontNames = NSExpression(forConstantValue: ["Open Sans Medium"])
        symbolLayer.textAllowsOverlap = NSExpression(forConstantValue: true)
        symbolLayer.textOffset = NSExpression(forConstantValue: CGVector(dx: 0, dy: -2.5))
        symbolLayer.textFontSize = NSExpression(forConstantValue: NSNumber(floatLiteral: 12))
        symbolLayer.iconAllowsOverlap = NSExpression(forConstantValue: true)
        return symbolLayer
    }

    /// Configures the style layer for route lines.
    /// - Parameters:
    ///   - identifier: The identifier for the style layer.
    ///   - source: The source data for the style layer.
    /// - Returns: An `MGLStyleLayer` configured with the route line style.
    private func routeStyleLayer(identifier: String, source: MGLSource) -> MGLStyleLayer {
        let line = MGLLineStyleLayer(identifier: identifier, source: source)
        line.lineWidth = getLineWidth()
        line.lineOpacity = NSExpression(forConditional:
                                            NSPredicate(format: "isAlternateRoute == true"),
                                        trueExpression: NSExpression(forConstantValue: 1),
                                        falseExpression: NSExpression(forConditional: NSPredicate(format: "isCurrentLeg == true"),
                                                                      trueExpression: NSExpression(forConstantValue: 1),
                                                                      falseExpression: NSExpression(forConstantValue: 1)))
        line.lineColor = NSExpression(format: "TERNARY(isAlternateRoute == true, %@, MGL_MATCH(congestion, 'low' , %@, 'moderate', %@, 'heavy', %@, 'severe', %@, %@))", routeAlternateColor, trafficLowColor, trafficModerateColor, trafficHeavyColor, trafficSevereColor, trafficUnknownColor)
        line.lineJoin = NSExpression(forConstantValue: "round")
        line.lineSortKey =  NSExpression(forKeyPath: "symbol-sort-key")
        return line
    }

    /// Returns an `NSExpression` for the line width based on the zoom level.
    /// - Returns: An `NSExpression` representing the line width.
    private func getLineWidth() -> NSExpression {
        let multiplier: CGFloat = 3.5 // Example multiplier
        let stops: [NSNumber: NSNumber] = [
            10: NSNumber(value: 2.0 * multiplier),
            12: NSNumber(value: 3.0 * multiplier),
            14: NSNumber(value: 4.0 * multiplier),
            16: NSNumber(value: 6.0 * multiplier),
            18: NSNumber(value: 7.0 * multiplier)
        ]
        return NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)", stops)
    }

    /// Creates a shape collection of waypoints for a specific leg.
    /// - Parameters:
    ///   - waypoints: An array of waypoints to be displayed.
    ///   - legIndex: The index of the current leg within the route.
    /// - Returns: An `MGLShape` representing the waypoints as a shape collection.
    private func waypointShape(for waypoints: [Waypoint], legIndex: Int) -> MGLShape? {
        var features = [MGLPointFeature]()
        
        for (waypointIndex, waypoint) in waypoints.enumerated() {
            let feature = MGLPointFeature()
            feature.coordinate = waypoint.coordinate
            feature.attributes = [
                "waypointCompleted": waypointIndex < legIndex
            ]
            features.append(feature)
        }
        
        return MGLShapeCollectionFeature(shapes: features)
    }

    /// Adds congestion information to the specified route and returns the resulting polyline features.
    /// - Parameters:
    ///   - route: The route to which congestion information will be added.
    ///   - legIndex: The index of the leg within the route to be highlighted (optional).
    /// - Returns: An array of `MGLPolylineFeature` objects representing the congested route segments.
    private func addCongestion(to route: Route, legIndex: Int?) -> [MGLPolylineFeature]? {
        guard let coordinates = route.coordinates else { return nil }
        var linesPerLeg: [MGLPolylineFeature] = []
        
        for (index, leg) in route.legs.enumerated() {
            // If there is no congestion, don't try and add it
            guard let legCongestion = leg.segmentCongestionLevels, legCongestion.count < coordinates.count else {
                return getPolylines(coordinates: route.coordinates!)
            }
            
            // The last coord of the preceding step, is shared with the first coord of the next step, we don't need both.
            let legCoordinates: [CLLocationCoordinate2D] = leg.steps.enumerated().reduce([]) { allCoordinates, current in
                let index = current.offset
                let step = current.element
                let stepCoordinates = step.coordinates!
                
                return index == 0 ? stepCoordinates : allCoordinates + stepCoordinates.suffix(from: 1)
            }
            let lines = combineCongestion(coordinates: legCoordinates, congestions: legCongestion, legIndex: legIndex, index: index)
            linesPerLeg.append(contentsOf: lines)
        }
        
        return linesPerLeg
    }

    /// Combines congestion levels with route coordinates into segments.
    /// - Parameters:
    ///   - coordinates: The coordinates of the route segment.
    ///   - congestions: The congestion levels corresponding to the route segments.
    ///   - legIndex: The index of the current leg (optional).
    ///   - index: The index of the current route leg.
    /// - Returns: An array of `MGLPolylineFeature` objects representing the segmented congested route.
    private func combineCongestion(coordinates: [CLLocationCoordinate2D], congestions: [CongestionLevel], legIndex: Int?, index: Int) -> [MGLPolylineFeature] {
        let mergedCongestionSegments = combine(coordinates, with: congestions)
        let lines: [MGLPolylineFeature] = mergedCongestionSegments.map { (congestionSegment: CongestionSegment) -> MGLPolylineFeature in
            let polyline = MGLPolylineFeature(coordinates: congestionSegment.0, count: UInt(congestionSegment.0.count))
            polyline.attributes[MoveCongestionAttribute] = String(describing: congestionSegment.1)
            polyline.attributes["isAlternateRoute"] = false
            if let legIndex = legIndex {
                polyline.attributes[MoveCurrentLegAttribute] = index == legIndex
            } else {
                polyline.attributes[MoveCurrentLegAttribute] = index == 0
            }
            return polyline
        }
        return lines
    }

    /// Combines coordinates with congestion levels into segments based on the congestion level.
    /// - Parameters:
    ///   - coordinates: The coordinates of the route segment.
    ///   - congestions: The congestion levels corresponding to the route segments.
    /// - Returns: An array of `CongestionSegment` objects representing the combined congestion segments.
    private func combine(_ coordinates: [CLLocationCoordinate2D], with congestions: [CongestionLevel]) -> [CongestionSegment] {
        var segments: [CongestionSegment] = []
        segments.reserveCapacity(congestions.count)
        for (index, congestion) in congestions.enumerated() {
            
            let congestionSegment: ([CLLocationCoordinate2D], CongestionLevel) = ([coordinates[index], coordinates[index + 1]], congestion)
            let coordinates = congestionSegment.0
            let congestionLevel = congestionSegment.1
            
            if segments.last?.1 == congestionLevel {
                segments[segments.count - 1].0 += coordinates
            } else {
                segments.append(congestionSegment)
            }
        }
        return segments
    }

    /// Removes all route-related layers and sources from the map style.
    /// - Note: This function will remove all layers and sources related to routes and congestion.
    public func removeRoutes() {
        guard let style = mapView.style else {
            return
        }
        
        // Remove route layers and sources
        if let line = style.layer(withIdentifier: LayerIdentifiers.Route.layerIdentifier) {
            style.removeLayer(line)
        }
        
        if let lineSource = style.source(withIdentifier: LayerIdentifiers.Route.sourceIdentifier) {
            style.removeSource(lineSource)
        }
        
        // Remove congestion layers and sources
        if let source = style.source(withIdentifier: LayerIdentifiers.Congestion.pointSourceIdentifier) as? MGLShapeSource {
            style.removeSource(source)
        }
        if let styleLayer = style.layer(withIdentifier: LayerIdentifiers.Congestion.pointLayerIdentifier) as? MGLSymbolStyleLayer {
            style.removeLayer(styleLayer)
        }
        
        // Remove end and start route layers and sources
        if let styleLayer = style.layer(withIdentifier: LayerIdentifiers.Route.endIdentifier) {
            style.removeLayer(styleLayer)
        }
        
        if let source = style.source(withIdentifier: LayerIdentifiers.Route.endIdentifier) {
            style.removeSource(source)
        }
        
        if let styleLayer = style.layer(withIdentifier: LayerIdentifiers.Route.startIdentifier) {
            style.removeLayer(styleLayer)
        }
        
        if let source = style.source(withIdentifier: LayerIdentifiers.Route.startIdentifier) {
            style.removeSource(source)
        }
    }

    /// Removes all waypoint-related layers and sources from the map style and clears map annotations.
    /// - Note: This function will remove all layers and sources related to waypoints and clear any annotations from the map.
    public func removeWaypoints() {
        guard let style = mapView.style else { return }
        
        // Remove all map annotations
        mapView.removeAnnotations(mapView.annotations ?? [])
        
        // Remove waypoint layers and sources
        if let symbolLayer = style.layer(withIdentifier: LayerIdentifiers.Waypoints.symbolIdentifier) {
            style.removeLayer(symbolLayer)
        }
        
        if let symbolLayer = style.layer(withIdentifier:  LayerIdentifiers.Waypoints.directionLayerIdentifier) {
            style.removeLayer(symbolLayer)
        }
        
        if let waypointSource = style.source(withIdentifier: LayerIdentifiers.Waypoints.directionSourceIdentifier) {
            style.removeSource(waypointSource)
        }
        
        if let waypointSource = style.source(withIdentifier: LayerIdentifiers.Waypoints.sourceIdentifier) {
            style.removeSource(waypointSource)
        }

        if let symbolSource = style.source(withIdentifier: LayerIdentifiers.Waypoints.symbolIdentifier) {
            style.removeSource(symbolSource)
        }
    }
}



fileprivate struct LayerIdentifiers {
    struct Route {
        static let sourceIdentifier = "routeSource"
        static let layerIdentifier = "routeLayer"
        static let startIdentifier = "routeStartIdentifier"
        static let endIdentifier = "routeEndIdentifier"
    }
    
    struct Waypoints {
        static let sourceIdentifier = "waypointsSource"
        static let symbolIdentifier = "waypointsSymbol"
        static let directionSourceIdentifier = "Direction-Waypoint-SourceIdentifier"
        static let directionLayerIdentifier = "Direction-Waypoint-LayerIdentifier"
    }
    
    struct Congestion {
        static let pointSourceIdentifier = "identifierCongestionPointSource"
        static let pointLayerIdentifier = "identifierCongestionPointLayer"
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        let dx = self.x - point.x
        let dy = self.y - point.y
        return sqrt(dx * dx + dy * dy)
    }
}
