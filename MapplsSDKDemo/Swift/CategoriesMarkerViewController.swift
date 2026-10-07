//
//  CategoriesMarkerViewController.swift
//  MapplsSDKDemo
//
//  Created by CE00124321 on 25/10/23.
//  Copyright © 2023 MMI. All rights reserved.
//

import UIKit
import MapplsMap

struct CoordinateMode {
    let coordinates: [CLLocationCoordinate2D]
    let type: String
    let imageName: String

    let iconScale: Double
}

class CategoriesMarkerViewController: UIViewController {
    
    let categoriesMarkerSourceIdentifier = "categoriesMarkerSourceIdentifier"
    let categoriesMarkerLayerIdentifier = "categoriesMarkerLayerIdentifier"
    var pointCollection = [MGLPointFeature]()
    var coordinateModes = [CoordinateMode]()
    var mapView: MapplsMapView!
    
    override func loadView() {
        super.loadView()
        setUpMapView()
        applyConstraint()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coordinateModes.append(CoordinateMode(coordinates: [
            CLLocationCoordinate2D(latitude: 28.551066333120303, longitude: 77.26894112705402),
            CLLocationCoordinate2D(latitude: 28.551032386058182, longitude: 77.26857784675235),
            CLLocationCoordinate2D(latitude: 28.55100251263445, longitude: 77.2681589150002),
            CLLocationCoordinate2D(latitude: 28.5509864404147, longitude: 77.26788643376327),
            CLLocationCoordinate2D(latitude: 28.550966655081883, longitude: 77.2676358488731)
        ], type: "type1", imageName: "marker1", iconScale: 0.5))
        
        coordinateModes.append(CoordinateMode(coordinates: [
            CLLocationCoordinate2D(latitude: 28.55124520780553, longitude: 77.26962574301831),
            CLLocationCoordinate2D(latitude: 28.551022885593035, longitude: 77.26968158978625),
            CLLocationCoordinate2D(latitude: 28.5507148687776, longitude: 77.26976529749032)
        ], type: "type2", imageName: "marker3", iconScale: 0.3))
        
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

extension CategoriesMarkerViewController: MapplsMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        mapView.setCenter(CLLocationCoordinate2D(latitude: 28.551066333120303, longitude: 77.26894112705402), zoomLevel: 16, animated: true)
        
        for coordinateMode in coordinateModes {
            if let style = mapView.style,
               style.image(forName: coordinateMode.imageName) == nil,
               let image = UIImage(named: coordinateMode.imageName) {
                style.setImage(image, forName: coordinateMode.imageName)
            }
            addOrUpdateCategoriesMarkerOnLayer(coordinateMode: coordinateMode)
        }
        
    }
    
    private func addOrUpdateCategoriesMarkerOnLayer(coordinateMode: CoordinateMode) {
        guard let style = mapView.style else { return }
        
        for coordinate in coordinateMode.coordinates {
            if CLLocationCoordinate2DIsValid(coordinate) {
                let pointFeature = MGLPointFeature()
                pointFeature.coordinate = coordinate
                pointFeature.title = coordinateMode.type
                pointFeature.attributes = [
                    "type": coordinateMode.type,
                    "icon-image": coordinateMode.imageName,
                    "icon-rotate": 0,
                    "icon-scale": coordinateMode.iconScale,
                ]
                pointCollection.append(pointFeature)
            }
        }
        
        let pointCollectionShape = MGLShapeCollectionFeature(shapes: pointCollection)
        
        if let source = style.source(withIdentifier: categoriesMarkerSourceIdentifier) as? MGLShapeSource {
            source.shape = pointCollectionShape
        } else {
            let movingMarkerSource = MGLShapeSource(identifier: categoriesMarkerSourceIdentifier, shape: pointCollectionShape, options: nil)
            style.addSource(movingMarkerSource)
            
            let movingMarkerLayer = getCategoriesMarkerStyleLayer(identifier: categoriesMarkerLayerIdentifier, source: movingMarkerSource)
            style.addLayer(movingMarkerLayer)
        }
        
    }
    
    private func getCategoriesMarkerStyleLayer(identifier: String, source: MGLSource) -> MGLStyleLayer {
        let symbolLayer = MGLSymbolStyleLayer(identifier: identifier, source: source)
        symbolLayer.sourceLayerIdentifier = "MovingMarkerLayer"
        symbolLayer.iconScale = NSExpression(forKeyPath: "icon-scale")
        symbolLayer.iconImageName = NSExpression(forKeyPath: "icon-image")
        symbolLayer.iconRotation = NSExpression(forKeyPath: "icon-rotate")
        symbolLayer.iconAnchor = NSExpression(forConstantValue: NSValue(mglIconAnchor: .bottom))
        symbolLayer.iconAllowsOverlap = NSExpression(forConstantValue: true)
        symbolLayer.iconRotationAlignment = NSExpression(forConstantValue: NSValue.init(mglIconRotationAlignment: .map))
        return symbolLayer
    }
    
    private func removeCategoriesMarkerLayer() {
        guard let style = mapView.style else { return }
        
        if let layer = style.layer(withIdentifier: categoriesMarkerLayerIdentifier) {
            style.removeLayer(layer)
        }
        if let source = style.source(withIdentifier: categoriesMarkerSourceIdentifier) {
            style.removeSource(source)
        }
    }
    
}
