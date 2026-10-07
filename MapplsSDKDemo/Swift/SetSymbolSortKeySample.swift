//
//  SetSymbolSortKeySample.swift
//  MapplsSDKDemo
//
//  Created by CE00120420 on 25/01/23.
//  Copyright © 2023 MMI. All rights reserved.
//

import UIKit
import MapplsMap
class SetSymbolSortKeySample: UIViewController {
    
    let sourceIdentifier = "sourceIdentifier"
    let layerIdentifier = "layerIdentifier"

    
    var mapView: MapplsMapView!
    var icon: UIImage = UIImage(named: "Vehicle")!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
    }
    
    func setupMapView() {
        mapView = MapplsMapView()
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func addSymbolLayer() {
        
        guard let style = mapView.style else {
            return
        }
        
        let pointFeatures1 = CustomPointFeature(coordinate: CLLocationCoordinate2DMake(28.551635, 77.268805))
        pointFeatures1.attributes = ["iconImageName": "Vehicle", "symbol-sort-key": 3]
        if let image = UIImage(named: "Vehicle") {
            style.setImage(image, forName: "Vehicle")
        }
        
        let pointFeatures2 = CustomPointFeature(coordinate: CLLocationCoordinate2DMake(28.551041, 77.267979))
        pointFeatures2.attributes = ["iconImageName": "ic_delete_forever", "symbol-sort-key": 2]
        if let image = UIImage(named: "ic_delete_forever") {
            style.setImage(image, forName: "ic_delete_forever")
        }
        
        let pointFeatures3 = CustomPointFeature(coordinate: CLLocationCoordinate2DMake(28.552115, 77.265833))
        pointFeatures3.attributes = ["iconImageName": "ic_delete", "symbol-sort-key": 5]
        if let image = UIImage(named: "ic_delete") {
            style.setImage(image, forName: "ic_delete")
        }
        
        let pointFeatures4 = CustomPointFeature(coordinate: CLLocationCoordinate2DMake(28.559786, 77.238859))
        pointFeatures4.attributes = ["iconImageName": "icMarkerFocused", "symbol-sort-key": 4]
        if let image = UIImage(named: "icMarkerFocused") {
            style.setImage(image, forName: "icMarkerFocused")
        }
        
        let pointFeatures5 = CustomPointFeature(coordinate: CLLocationCoordinate2DMake(28.561535, 77.233345))
        pointFeatures5.attributes = ["iconImageName": "marker1", "symbol-sort-key": 1]
        if let image = UIImage(named: "marker1") {
            style.setImage(image, forName: "marker1")
        }
        
        let pointFeatures6 = CustomPointFeature(coordinate: CLLocationCoordinate2DMake(28.562469, 77.235072))
        pointFeatures6.attributes = ["iconImageName": "marker3", "symbol-sort-key": 6]
        if let image = UIImage(named: "marker3") {
            style.setImage(image, forName: "marker3")
        }
        
        let pointFeatures7 = CustomPointFeature(coordinate: CLLocationCoordinate2DMake(28.435931, 77.304689))
        pointFeatures7.attributes = ["iconImageName": "circle", "symbol-sort-key": 8]
        if let image = UIImage(named: "circle") {
            style.setImage(image, forName: "circle")
        }
        
        let pointFeatures = [
            pointFeatures1, pointFeatures2, pointFeatures3, pointFeatures4, pointFeatures5, pointFeatures6, pointFeatures7
        ]
        
        let shape = MGLShapeCollectionFeature(shapes: pointFeatures)
        
        let source = MGLShapeSource(identifier: sourceIdentifier, shape: shape, options: [:])
        style.addSource(source)
        
        
        // source features.
        let ports = MGLSymbolStyleLayer(identifier: layerIdentifier, source: source)
        ports.iconImageName = NSExpression(forKeyPath: "iconImageName")
        
        
        // Sorts features in ascending order based on this value. Features with lower sort keys are drawn and placed first.  When `iconAllowsOverlap` or `textAllowsOverlap` is `false`, features with a lower sort key will have priority during placement. When `iconAllowsOverlap` or `textAllowsOverlap` is set to `YES`, features with a higher sort key will overlap over features with a lower sort key.
        ports.symbolSortKey = NSExpression(forKeyPath: "symbol-sort-key")
        
        ports.iconAllowsOverlap = NSExpression(forConstantValue: true)
        style.addLayer(ports)
    }
}

extension SetSymbolSortKeySample: MapplsMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        print("style: didFinishLoading")
        addSymbolLayer()
    }
}
