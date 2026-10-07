//
//  DottedLineViewController.swift
//  MapplsSDKDemo
//
//  Created by ceinfo on 24/11/23.
//  Copyright © 2023 MMI. All rights reserved.
//

import UIKit
import MapplsMap
import MapplsAPIKit
class DottedLineViewController: UIViewController {

    var mapView: MapplsMapView!
    let SourceIdentifier = "DottedLineSourceIndetifier"
    let LayerIdentifier = "DottedLineLayerIndetifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMapView()
    }
    
    func callRoutingAPI() {
        let sourceLocation = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 28.00, longitude: 77.98))
        let destination = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 29.87, longitude: 78.98))
        
        
        let waypints = [sourceLocation, destination]
        let routeOptions = RouteOptions(waypoints: waypints)
        Directions.shared.calculate(routeOptions) { waypoints, routes, error in
            guard let routes = routes, let selectedRoute = routes.first else {
                return
            }
            self.showDottedPolyline(coordinates: selectedRoute.coordinates)
        }
    }
    
    func setupMapView() {
        mapView = MapplsMapView()
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension DottedLineViewController {
    func showDottedPolyline(coordinates: [CLLocationCoordinate2D]?) {
        guard var coordinates = coordinates, let style = mapView.style else {
            return
        }
        let sourceFeatures = MGLPolylineFeature(coordinates: &coordinates, count: UInt(coordinates.count))
        
        let source = MGLShapeSource(identifier: SourceIdentifier, shape: sourceFeatures, options: nil)
        
        if let existingSource = style.source(withIdentifier: SourceIdentifier) as? MGLShapeSource {
            existingSource.shape = source.shape
        } else {
            style.addSource(source)
            let layer = dotRouteStyleLayer(identifier: LayerIdentifier, source: source)
            style.addLayer(layer)
        }
        let shapeCam = self.mapView.cameraThatFitsShape(sourceFeatures, direction: CLLocationDirection(0), edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        self.mapView.setCamera(shapeCam, animated: false)
    }
    
    func dotRouteStyleLayer(identifier: String, source: MGLSource) -> MGLStyleLayer {
        let shapeLayer = MGLSymbolStyleLayer(identifier: identifier, source: source)
        
        if let style = mapView.style, style.image(forName: "dot-image") == nil,  let image = UIImage(named: "dotImage") {
            style.setImage(image, forName: "dot-image")
        }
        
        shapeLayer.minimumZoomLevel = 3.0
        shapeLayer.iconImageName = NSExpression(forConstantValue: "dot-image")
        shapeLayer.iconAllowsOverlap = NSExpression(forConstantValue: true)
        shapeLayer.symbolPlacement =  NSExpression(forConstantValue: NSValue(mglSymbolPlacement: .line))
        shapeLayer.symbolSpacing =  NSExpression(forConstantValue: 1.0)
        shapeLayer.symbolSortKey =  NSExpression(forKeyPath: "symbol-sort-key")
        shapeLayer.iconScale = NSExpression(forConstantValue: 0.4)
        
        return shapeLayer
    }
}

extension DottedLineViewController: MapplsMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        callRoutingAPI()
    }
}
