//
//  MovingMarkerViewController.swift
//  MapplsSDKDemo
//
//  Created by CE00124321 on 06/09/23.
//  Copyright © 2023 MMI. All rights reserved.
//

import UIKit
import MapplsMap
import MapplsAPICore
import MapplsDirectionUI

class MovingMarkerViewController: UIViewController {

    var mapView: MapplsMapView!
    
    var index = 0
    var previousCoordinates: CLLocationCoordinate2D?
    
    var locations: [CLLocationCoordinate2D] = []
    
    let movingMarkerSourceIdentifier = "movingMarkerSourceIdentifier"
    let movingMarkerLayerIdentifier = "movingMarkerLayerIdentifier"
    
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
extension MovingMarkerViewController: MapplsMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        mapView.setCenter(CLLocationCoordinate2D(latitude: 28.55106676597232, longitude: 77.26892899885115), zoomLevel: 15, animated: true)
        
        let currentWayPoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 28.551067906813493, longitude: 77.26890925366251), name: "Current Location")
        let destinationWayPoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 28.610231934703265, longitude: 77.22905502962782), name: "Destination")
        
        let options = RouteOptions(waypoints: [currentWayPoint, destinationWayPoint])
        Directions().calculate(options) { waypoints, routes, error in
            if let coordinates = routes?.first?.coordinates {
                self.locations = coordinates
                self.startRoutePlay()
            }
        }
    }
    
}

//MARK: - Start Tracking
extension MovingMarkerViewController {
    
    @objc func startRoutePlay() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(startRoutePlay), object: nil)
        addUpdateLayers()
        perform(#selector(self.startRoutePlay), with: nil, afterDelay: TimeInterval(0.5))
        index += 1
    }
    
    func addUpdateLayers() {
        guard locations.indices.contains(index) else {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(startRoutePlay), object: nil)
            return
        }
        var heading = 0.0
        let currentCoordinate = locations[index]
        
        if let previousCoordinates = previousCoordinates {
            heading = previousCoordinates.direction(to: currentCoordinate)
        }
        previousCoordinates = currentCoordinate
        
        mapView.setCenter(currentCoordinate, zoomLevel: mapView.zoomLevel, direction: heading, animated: true)
        addOrUpdateMovingMarkerLayer(coordinate: currentCoordinate, heading: heading)
        addUpdateLineLayer(currentIndex: index)
    }
    
}

//MARK: - Add Update Marker
extension MovingMarkerViewController {
    
    private func addOrUpdateMovingMarkerLayer(coordinate: CLLocationCoordinate2D, heading: Double = 0) {
        guard let style = mapView.style else { return }
        
        var pointCollection = [MGLPointFeature]()
        
        if coordinate.latitude > 0,
           coordinate.longitude > 0,
           CLLocationCoordinate2DIsValid(coordinate) {
            let pointFeature = MGLPointFeature()
            pointFeature.coordinate = coordinate
            pointFeature.title = "realView-Annotation"
            pointFeature.attributes = [
                "type": "realViewAnnotation",
                "icon-image": "Nearby-MapplsPin-Icon",
                "icon-rotate": heading
            ]
            pointCollection.append(pointFeature)
        }
        
        let pointCollectionShape = MGLShapeCollectionFeature(shapes: pointCollection)
        
        if let source = style.source(withIdentifier: movingMarkerSourceIdentifier) as? MGLShapeSource {
            source.shape = pointCollectionShape
        } else {
            
            let movingMarkerSource = MGLShapeSource(identifier: movingMarkerSourceIdentifier, shape: pointCollectionShape, options: nil)
            style.addSource(movingMarkerSource)
            
            let movingMarkerLayer = movingMarkerStyleLayer(identifier: movingMarkerLayerIdentifier, source: movingMarkerSource)
            style.addLayer(movingMarkerLayer)
        }
        
    }
    
    private func movingMarkerStyleLayer(identifier: String, source: MGLSource) -> MGLStyleLayer {
        let symbolLayer = MGLSymbolStyleLayer(identifier: identifier, source: source)
        
        if let style = mapView.style, style.image(forName: "Nearby-MapplsPin-Icon") == nil,  let image = UIImage(named: "Vehicle") {
            style.setImage(image, forName: "Nearby-MapplsPin-Icon")
        }
        symbolLayer.iconScale = NSExpression(forConstantValue: 0.7)
        symbolLayer.sourceLayerIdentifier = "MovingMarkerLayer"
        symbolLayer.iconImageName = NSExpression(forKeyPath: "icon-image")
        symbolLayer.iconRotation = NSExpression(forKeyPath: "icon-rotate")
        symbolLayer.iconRotationAlignment = NSExpression(forConstantValue: NSValue.init(mglIconRotationAlignment: .map))
        symbolLayer.textFontNames = NSExpression(forConstantValue: ["Open Sans Regular"])
        return symbolLayer
    }
    
    private func removeMovingMarkerLayer() {
        guard let style = mapView.style else { return }
        
        if let layer = style.layer(withIdentifier: movingMarkerLayerIdentifier) {
            style.removeLayer(layer)
        }
        if let source = style.source(withIdentifier: movingMarkerSourceIdentifier) {
            style.removeSource(source)
        }
    }
    
}

//MARK: - Add Update PolyLine
extension MovingMarkerViewController {
    
    func addUpdateLineLayer(currentIndex: Int) {
        guard let style = self.mapView.style else { return }
        
        let sourceFeatures = getSourceFeatures(currentIndex: currentIndex)
        // Create source and add it to the map style.
        let source = MGLShapeSource(identifier: lineSourceIdentifier, shape: sourceFeatures, options: nil)
        
        if let existingSource = style.source(withIdentifier: lineSourceIdentifier) as? MGLShapeSource {
            existingSource.shape = sourceFeatures
        } else {
            style.addSource(source)
            
            let polylineLayer = MGLLineStyleLayer(identifier: lineLayerIdentifier, source: source)
            polylineLayer.lineColor = NSExpression(forConstantValue: UIColor.blue)
            polylineLayer.lineOpacity = NSExpression(forConstantValue: 0.5)
            polylineLayer.lineWidth = NSExpression(forConstantValue: 8)
            style.addLayer(polylineLayer)
        }
        
    }
    
    func getSourceFeatures(currentIndex: Int) -> MGLPolylineFeature? {
        guard currentIndex < locations.count else { return nil }
        var coordinates = Array(locations[currentIndex ..< locations.count])
        let polyline = MGLPolylineFeature(coordinates: &coordinates, count: UInt(coordinates.count))
        return polyline
    }
    
}
