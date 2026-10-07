//
//  TrackingExampleViewController.swift
//  MapplsUtilsExamples
//
//  Created by Siddharth  on 24/06/24.
//

import UIKit
import MapplsUtils
import CoreLocation
import MapplsMap
class TrackingExampleViewController: UIViewController, MapplsTrackingPluginDelegate {
    var animator: MapplsLocationAnimator!
    var mapView: MapplsMapView!
    
    var lastKnowLocation: CLLocationCoordinate2D?
    var intermidiateCoordinate: CLLocationCoordinate2D?
    
    
    var traveledCoordinates: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = MapplsMapView(frame: view.frame)
        mapView.showsUserLocation = true
        view.addSubview(mapView)
        mapView.setMapplsMapStyle("carplay_day")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        mapView.addGestureRecognizer(tapGesture)
        
        animator = MapplsLocationAnimator()
        animator.delegate = self
    
    }

    
    @objc func tapGesture(gestureRecognizer: UIGestureRecognizer) {
        
        let touchPoint = gestureRecognizer.location(in: mapView)
        let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        animator.valueAnimator?.end()
        guard let lastKnowLocation = lastKnowLocation else {
            self.lastKnowLocation = newCoordinates
            showMarker(mapView: self.mapView, coordinate: CLLocation(coordinate: newCoordinates))
            return
        }
        var coordinates = [lastKnowLocation,  newCoordinates]
        if let intermidiateCoordinate = intermidiateCoordinate {
            coordinates.insert(intermidiateCoordinate, at: 1)
        }
        animator.animateLocation(coordinates: coordinates, duration: 2)
        intermidiateCoordinate = newCoordinates
    }
    
    let TrackingMarkerIdentifer = "TrackingMarkerIdentifer"
}


extension TrackingExampleViewController {
    
    func addPolylineSource(coordinates: [CLLocationCoordinate2D], sourceIdentifier: String) -> MGLShapeSource? {
        guard let style = mapView?.style else { return nil }
        let polyline = MGLPolyline(coordinates: coordinates, count: UInt(coordinates.count))
        let lineSource = MGLShapeSource(identifier: sourceIdentifier, shape: polyline, options: nil)
        if let source = style.source(withIdentifier: sourceIdentifier) as? MGLShapeSource {
            source.shape = lineSource.shape
        } else {
            style.addSource(lineSource)
        }
        return lineSource
    }
    
    
    func addPolyline(coordinates: [CLLocationCoordinate2D]) {
        guard let style = self.mapView.style else {
            return
        }
        guard let lineSource = addPolylineSource(coordinates: coordinates, sourceIdentifier: "traveledPolyline") else {
            return
        }
        if style.layer(withIdentifier: "traveledPolyline") == nil {
            let layer = self.mapplsTrackingPlugin(source: lineSource, routeIdentifier: "traveledPolyline")
            
            style.addLayer(layer)
        }
    }
    
    public func showMarker(mapView: MapplsMapView?, coordinate: CLLocation) {
        var pointFeatureArray = [MGLPointFeature]()
        let pointFeature = MGLPointFeature()
        pointFeature.coordinate = CLLocationCoordinate2DMake(coordinate.coordinate.latitude , coordinate.coordinate.longitude)
        pointFeature.attributes = ["iconName": "carplayNavigationMarkerDay"]
        pointFeatureArray.append(pointFeature)
        
        guard let style = mapView?.style else { return }
        if let _ = style.image(forName: "carplayNavigationMarkerDay") {
            
        } else {
            let image = UIImage(named:"") //MapplsTrackingPluginConfiguration.shared.markerImage
            style.setImage(image!, forName: "carplayNavigationMarkerDay")
        }
        let source = MGLShapeSource(identifier: TrackingMarkerIdentifer, features: pointFeatureArray, options: nil)
        if let existingSource = style.source(withIdentifier: TrackingMarkerIdentifer) as? MGLShapeSource {
            existingSource.shape = source.shape
        } else {
            style.addSource(source)
        }
        
        if let symboleLayer = style.layer(withIdentifier: TrackingMarkerIdentifer) as? MGLSymbolStyleLayer {
            symboleLayer.iconRotation = NSExpression(forConstantValue: coordinate.course)
            symboleLayer.iconRotationAlignment = NSExpression(forConstantValue: NSValue(mglIconRotationAlignment: .map))
        } else {
            let symbols = MGLSymbolStyleLayer(identifier: TrackingMarkerIdentifer, source: source)
            symbols.iconImageName = NSExpression(forKeyPath: "iconName")
            symbols.iconScale = NSExpression(forConstantValue: 0.6)
            symbols.iconRotationAlignment = NSExpression(forConstantValue: NSValue(mglIconRotationAlignment: .map))
            symbols.iconAllowsOverlap = NSExpression(forConstantValue: true)
            if let coveredRouteLayer = style.layer(withIdentifier: "TraveledPathIdentifier") {
                style.insertLayer(symbols, above: coveredRouteLayer)
            } else {
                style.addLayer(symbols)
            }
            
        }
    }
}

extension TrackingExampleViewController: MapplsLocationAnimatorDelegate {
    func didUpdateLocation(location: CLLocation) {
        showMarker(mapView: self.mapView, coordinate: location)
        self.lastKnowLocation = location.coordinate
        traveledCoordinates.append(location.coordinate)
        self.addPolyline(coordinates: traveledCoordinates)
    }
    
    func onAnimationStart(animator: MapplsUtils.MapplsObjectAnimator<CLLocationCoordinate2D, MapplsUtils.LatLngEvaluator>) {
        
    }
    
    func onAnimationEnd(animator: MapplsUtils.MapplsObjectAnimator<CLLocationCoordinate2D, MapplsUtils.LatLngEvaluator>) {
        
    }
    
    
}
