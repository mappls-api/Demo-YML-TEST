//
//  DynamicIconScaleController.swift
//  MapplsSDKDemo
//
//  Created by Akshit on 09/12/24.
//  Copyright © 2024 MMI. All rights reserved.
//

import MapplsMap

class IconScaleFactorController : UIViewController, MapplsMapViewDelegate {

    let sourceIdentifier = "sourceIdentifier"
    let layerIdentifier = "layerIdentifier"

    public let IconScaleZoomLevel: [Int: NSExpression] = [
        5: NSExpression(forConstantValue: 1),
        6: NSExpression(forConstantValue: 1.1),
        7: NSExpression(forConstantValue: 1.5),
        8: NSExpression(forConstantValue: 2),
        9: NSExpression(forConstantValue: 2.2),
        10: NSExpression(forConstantValue: 2.7),
        11: NSExpression(forConstantValue: 3)
    ]

    var mapView: MapplsMapView!
    var icon: UIImage = UIImage(named: "destination-icon")!
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
        
        var pointFeatures = [MGLPointFeature]()
        
        let coordintes = [
            CLLocationCoordinate2DMake(28.99, 77.89),
            CLLocationCoordinate2DMake(28.78, 77.98),
            CLLocationCoordinate2DMake(28.56, 77.2088),
            CLLocationCoordinate2DMake(28.7041, 77.1025)
        ]
        for coordinte in coordintes {
            let pointFeature = MGLPointFeature()
            pointFeature.coordinate = coordinte
            
            pointFeatures.append(pointFeature)
        }
        
        
        style.setImage(icon, forName: "my-image")
        
        let shape = MGLShapeCollectionFeature(shapes: pointFeatures)
        
        let source = MGLShapeSource(identifier: sourceIdentifier, shape: shape, options: [:])
        if let existingSource = style.source(withIdentifier: sourceIdentifier) as? MGLShapeSource {
            existingSource.shape = source.shape
        } else {
            
            style.addSource(source)
            let styleLayer = MGLSymbolStyleLayer(identifier: layerIdentifier, source: source)
            styleLayer.iconImageName = NSExpression(forConstantValue: "my-image")
            styleLayer.iconAllowsOverlap = NSExpression(forConstantValue: true)
            styleLayer.iconScale = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)", IconScaleZoomLevel)
            style.addLayer(styleLayer)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            let camera = self.mapView.cameraThatFitsShape(shape, direction: 0, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50))
            self.mapView.fly(to: camera, withDuration: 10)
        })
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        addSymbolLayer()
    }
    
   
}


