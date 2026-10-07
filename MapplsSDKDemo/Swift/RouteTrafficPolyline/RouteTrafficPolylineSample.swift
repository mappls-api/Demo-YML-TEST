//
//  RouteTrafficPolylineSample.swift
//  MapplsSDKDemo
//
//  Created by Atul Sharan on 09/08/24.
//  Copyright © 2024 MMI. All rights reserved.
//

import UIKit
import Foundation
import MapplsMap
import MapplsAPIKit

public class RouteTrafficPolylineSample: UIViewController {
    
    private var mapView: MapplsMapView!
    private var polylinePluginObj: PolylineLayerPlugin?
    private var routes: [Route]?
    
    public override func loadView() {
        super.loadView()
        setUpMapView()
        applyConstraint()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setUpMapView() {
        mapView = MapplsMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        view.addSubview(mapView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleMapTap(_:)))
        self.mapView.addGestureRecognizer(tap)
        
        self.polylinePluginObj = PolylineLayerPlugin(mapView: self.mapView)
    }
    
    func applyConstraint() {
        mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }
    
    func displayRoutePolyline() {
        let origin = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 28.6139, longitude: 77.2090), name: "Source")
//        let waypoint1 = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 23.0225, longitude: 72.5714), name: "Waypoint 1")
//        let waypoint2 = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 18.5204, longitude: 73.8567), name: "Waypoint 2")
        let destination = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 19.0760, longitude: 72.8777), name: "Destiantion")
        
        let options = RouteOptions(waypoints: [origin, destination])
        options.routeShapeResolution = .full
        options.includesAlternativeRoutes = true
        options.resourceIdentifier = .routeETA
        options.attributeOptions = [.congestionLevel]
        Directions(restKey: MapplsAccountManager.restAPIKey()).calculate(options) { (waypoints, routes, error) in
            if let _ = error { return }
            
            guard let allRoutes = routes, allRoutes.count > 0 else { return }
            
            self.routes = allRoutes
            DispatchQueue.main.async {
                self.polylinePluginObj?.renderRoutePolyline(routes: allRoutes)
                if let markerImage = UIImage(named: "marker2"){
                    let focusedRoute = allRoutes[0]
                    self.addMarkersAlongRoute(route: focusedRoute, count: 5, image: markerImage, imageName: "marker2")
                } else {
                    print("Image not found in assets")
                }
            }
        }
    }
    
    
    private func generateMarkersAlongRoute(route: Route, numberOfMarkers: Int) -> [CLLocationCoordinate2D] {
        guard let coordinates = route.coordinates, coordinates.count > 1 else { return [] }
        
        let polyline = Polyline(coordinates)
        var markerCoordinates: [CLLocationCoordinate2D] = []

        let totalDistance = polyline.distance()
        let spacing = totalDistance / Double(numberOfMarkers + 1)

        for i in 1...numberOfMarkers {
            let distance = spacing * Double(i)
            if let coordinate = polyline.coordinateFromStart(distance: distance) {
                markerCoordinates.append(coordinate)
            }
        }
        return markerCoordinates
    }

    
    func addMarkersAlongRoute(route: Route, count: Int, image: UIImage, imageName: String) {
        guard let style = mapView.style else { return }

        let coordinates = generateMarkersAlongRoute(route: route, numberOfMarkers: count)
        var pointFeatures: [MGLPointFeature] = []

        for (index, coord) in coordinates.enumerated() {
            let feature = MGLPointFeature()
            feature.coordinate = coord
            feature.title = "route-marker-\(index)"
            feature.attributes = [
                "iconName": imageName,
                "markerType": "route-marker"
            ]

            pointFeatures.append(feature)
        }

        let shapeCollection = MGLShapeCollectionFeature(shapes: pointFeatures)

        let sourceId = "custom-route-marker-source"
        let layerId = "custom-route-marker-layer"

        if let source = style.source(withIdentifier: sourceId) as? MGLShapeSource {
            source.shape = shapeCollection
        } else {
            let source = MGLShapeSource(identifier: sourceId, shape: shapeCollection, options: nil)
            style.addSource(source)

            let symbolLayer = MGLSymbolStyleLayer(identifier: layerId, source: source)
            symbolLayer.iconImageName = NSExpression(forKeyPath: "iconName")
            symbolLayer.iconScale = NSExpression(forConstantValue: 0.2)
            symbolLayer.iconAllowsOverlap = NSExpression(forConstantValue: true)
            style.addLayer(symbolLayer)
        }

        if style.image(forName: imageName) == nil {
                style.setImage(image, forName: imageName)
            
        }
    }
    
    @objc func handleMapTap(_ gesture: UITapGestureRecognizer) {
        let tapPoint = gesture.location(in: mapView)

        let features = mapView.visibleFeatures(at: tapPoint)
        if let tappedMarker = features.first(where: {
            $0.attribute(forKey: "markerType") as? String == "route-marker"
        }) {
            showMessage("You tapped on a route marker")
            return
        }
        if let selectedRoutes = self.polylinePluginObj?.selectRoute(point: tapPoint) {
            print("Selected route index: \(selectedRoutes)")
        }
    }

    func showMessage(_ message: String) {
        let alert = UIAlertController(title: "Marker Tapped", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

}

//MARK: - MapView Delegates
extension RouteTrafficPolylineSample: MapplsMapViewDelegate {
    
    public func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        displayRoutePolyline()
    }
}
